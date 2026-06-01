from flask import Flask, render_template, request, redirect, session, url_for
import pymysql
import os
import smtplib
from email.message import EmailMessage
from email.header import Header
from email.utils import formataddr
app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "health_checkin_secret_key")

def get_db_connection():
    """连接 MySQL 数据库：本地运行用默认值，部署到 Railway 后自动读取环境变量"""
    return pymysql.connect(
        host=os.getenv("MYSQLHOST", "localhost"),
        port=int(os.getenv("MYSQLPORT", "3306")),
        user=os.getenv("MYSQLUSER", "checkin_user"),
        password=os.getenv("MYSQLPASSWORD", "Checkin@123456"),
        database=os.getenv("MYSQLDATABASE", "health_checkin_db"),
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
    )

def send_email(to_email, subject, content):
    """发送邮件提醒"""
    email_host = os.getenv("EMAIL_HOST")
    email_port = int(os.getenv("EMAIL_PORT", "465"))
    email_user = os.getenv("EMAIL_USER")
    email_password = os.getenv("EMAIL_PASSWORD")
    email_sender_name = os.getenv("EMAIL_SENDER_NAME", "健康打卡系统")

    if not email_host or not email_user or not email_password:
        raise RuntimeError("邮件发送配置不完整，请检查 EMAIL_HOST、EMAIL_USER、EMAIL_PASSWORD")

    if not to_email:
        raise RuntimeError("收件人邮箱为空，无法发送邮件")

    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = f"{email_sender_name} <{email_user}>"
    msg["To"] = to_email
    msg.set_content(content)

    # timeout=5：防止 Railway 云端连接 QQ SMTP 端口时长时间卡死
    with smtplib.SMTP_SSL(email_host, email_port, timeout=5) as smtp:
        smtp.login(email_user, email_password)
        smtp.send_message(msg)

def get_count(cursor, table_name):
    """查询某张表的数据总数"""
    sql = f"SELECT COUNT(*) AS total FROM {table_name};"
    cursor.execute(sql)
    result = cursor.fetchone()
    return result["total"]


@app.route("/")
def index():
    if "user_id" not in session:
        return redirect("/login")

    if session.get("role") == "管理员":
        return redirect("/admin/home")
    else:
        return redirect("/user/home")


@app.route("/tasks")
def tasks():
    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    t.task_id,
                    u.username,
                    c.type_name,
                    t.task_name,
                    t.target_time,
                    t.start_date,
                    t.end_date,
                    t.frequency,
                    t.elder_mode,
                    t.task_status
                FROM t_checkin_task t
                JOIN t_user u ON t.user_id = u.user_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                ORDER BY t.task_id;
            """
            cursor.execute(sql)
            task_list = cursor.fetchall()

        return render_template("tasks.html", tasks=task_list)

    finally:
        conn.close()

@app.route("/records")
def records():
    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    r.record_id,
                    u.username,
                    c.type_name,
                    t.task_name,
                    r.checkin_date,
                    r.checkin_time,
                    r.checkin_status,
                    r.remark
                FROM t_checkin_record r
                JOIN t_checkin_task t ON r.task_id = t.task_id
                JOIN t_user u ON t.user_id = u.user_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                ORDER BY r.record_id;
            """
            cursor.execute(sql)
            record_list = cursor.fetchall()

        return render_template("records.html", records=record_list)

    finally:
        conn.close()
@app.route("/statistics")
def statistics():
    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    t.task_id,
                    u.username,
                    c.type_name,
                    t.task_name,
                    COUNT(r.record_id) AS total_records,
                    SUM(CASE WHEN r.checkin_status = '已完成' THEN 1 ELSE 0 END) AS on_time_count,
                    SUM(CASE WHEN r.checkin_status = '超时完成' THEN 1 ELSE 0 END) AS late_count,
                    SUM(CASE WHEN r.checkin_status = '未完成' THEN 1 ELSE 0 END) AS miss_count,
                    ROUND(
                        SUM(CASE WHEN r.checkin_status IN ('已完成', '超时完成') THEN 1 ELSE 0 END)
                        / COUNT(r.record_id) * 100,
                        2
                    ) AS completion_rate
                FROM t_checkin_task t
                JOIN t_user u ON t.user_id = u.user_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                LEFT JOIN t_checkin_record r ON t.task_id = r.task_id
                GROUP BY
                    t.task_id,
                    u.username,
                    c.type_name,
                    t.task_name
                ORDER BY t.task_id;
            """
            cursor.execute(sql)
            statistics_list = cursor.fetchall()

        return render_template("statistics.html", statistics=statistics_list)

    finally:
        conn.close()
@app.route("/alerts")
def alerts():
    if "user_id" not in session:
        return redirect("/login")

    if session.get("role") != "管理员":
        return "无权限访问管理员页面"

    message = request.args.get("message")

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    a.alert_id,
                    u.username,
                    c.type_name,
                    t.task_name,
                    a.alert_type,
                    a.alert_date,
                    a.alert_content,
                    a.handle_status,
                    n.notify_id,
                    e.contact_name,
                    e.relationship,
                    e.email,
                    n.notify_method,
                    n.notify_status,
                    n.notify_time
                FROM t_alert_record a
                JOIN t_checkin_task t ON a.task_id = t.task_id
                JOIN t_user u ON t.user_id = u.user_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                LEFT JOIN t_alert_notify_record n ON a.alert_id = n.alert_id
                LEFT JOIN t_emergency_contact e ON n.contact_id = e.contact_id
                ORDER BY a.alert_id, n.notify_id;
            """
            cursor.execute(sql)
            alert_list = cursor.fetchall()

        return render_template(
            "alerts.html",
            alerts=alert_list,
            message=message
        )

    finally:
        conn.close()
@app.route("/login", methods=["GET", "POST"])
def login():
    error = None

    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        conn = get_db_connection()

        try:
            with conn.cursor() as cursor:
                sql = """
                    SELECT user_id, username, role, status
                    FROM t_user
                    WHERE username = %s
                      AND user_password = %s
                      AND status = '正常';
                """
                cursor.execute(sql, (username, password))
                user = cursor.fetchone()

            if user:
                session["user_id"] = user["user_id"]
                session["username"] = user["username"]
                session["role"] = user["role"]

                if user["role"] == "管理员":
                    return redirect("/admin/home")
                else:
                    return redirect("/user/home")
            else:
             error = "用户名或密码错误，或账号已被禁用"

        finally:
            conn.close()

    return render_template("login.html", error=error)

@app.route("/register", methods=["GET", "POST"])
def register():
    error = None
    success = None

    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        phone = request.form.get("phone")
        gender = request.form.get("gender")
        age = request.form.get("age")

        conn = get_db_connection()

        try:
            with conn.cursor() as cursor:
                # 检查用户名是否已经存在
                cursor.execute(
                    "SELECT user_id FROM t_user WHERE username = %s;",
                    (username,)
                )
                existing_user = cursor.fetchone()

                if existing_user:
                    error = "用户名已存在，请更换用户名"
                else:
                    cursor.execute("""
                        INSERT INTO t_user
                        (username, user_password, phone, gender, age, role, status)
                        VALUES
                        (%s, %s, %s, %s, %s, '用户', '正常');
                    """, (
                        username,
                        password,
                        phone,
                        gender,
                        age if age else None
                    ))

                    conn.commit()
                    success = "注册成功，请返回登录页面登录"

        finally:
            conn.close()

    return render_template(
        "register.html",
        error=error,
        success=success
    )

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/login")

@app.route("/user/home")
def user_home():
    if "user_id" not in session:
        return redirect("/login")

    return render_template(
        "user_home.html",
        username=session.get("username"),
        user_id=session.get("user_id"),
        role=session.get("role")
    )
@app.route("/user/tasks")
def user_tasks():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    message = request.args.get("message")

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    t.task_id,
                    c.type_name,
                    t.task_name,
                    t.target_time,
                    t.start_date,
                    t.end_date,
                    t.frequency,
                    t.elder_mode,
                    t.task_status
                FROM t_checkin_task t
                JOIN t_checkin_type c ON t.type_id = c.type_id
                WHERE t.user_id = %s
                ORDER BY t.task_id;
            """
            cursor.execute(sql, (user_id,))
            task_list = cursor.fetchall()

        return render_template(
            "user_tasks.html",
            tasks=task_list,
            username=session.get("username"),
            message=message
        )

    finally:
        conn.close()


@app.route("/user/checkin/<int:task_id>", methods=["POST"])
def user_checkin(task_id):
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            # 先确认这个任务确实属于当前登录用户，防止用户打卡别人的任务
            check_sql = """
                SELECT task_id
                FROM t_checkin_task
                WHERE task_id = %s
                  AND user_id = %s
                  AND task_status = '进行中';
            """
            cursor.execute(check_sql, (task_id, user_id))
            task = cursor.fetchone()

            if not task:
                return redirect("/user/tasks?message=任务不存在或不属于当前用户")

            # 如果今天已经有记录，就更新为已完成；如果今天没有记录，就插入一条新记录
            sql = """
                INSERT INTO t_checkin_record
                (task_id, checkin_date, checkin_time, checkin_status, remark)
                VALUES
                (%s, CURDATE(), NOW(), '已完成', '用户通过系统完成今日打卡')
                ON DUPLICATE KEY UPDATE
                    checkin_time = NOW(),
                    checkin_status = '已完成',
                    remark = '用户通过系统更新今日打卡';
            """
            cursor.execute(sql, (task_id,))
            conn.commit()

        return redirect("/user/tasks?message=今日打卡成功")

    finally:
        conn.close()
@app.route("/user/records")
def user_records():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    r.record_id,
                    c.type_name,
                    t.task_name,
                    r.checkin_date,
                    r.checkin_time,
                    r.checkin_status,
                    r.remark
                FROM t_checkin_record r
                JOIN t_checkin_task t ON r.task_id = t.task_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                WHERE t.user_id = %s
                  AND r.checkin_date <= CURDATE()
                ORDER BY r.record_id ASC;
            """
            cursor.execute(sql, (user_id,))
            record_list = cursor.fetchall()

        return render_template(
            "user_records.html",
            records=record_list,
            username=session.get("username")
        )

    finally:
        conn.close()
@app.route("/user/create_task", methods=["GET", "POST"])
def user_create_task():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    message = None

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            # 查询所有启用的打卡类型，供下拉框选择
            cursor.execute("""
                SELECT
                    type_id,
                    type_name,
                    default_miss_days,
                    default_notify_contact
                FROM t_checkin_type
                WHERE status = '启用'
                ORDER BY type_id;
            """)
            type_list = cursor.fetchall()

            if request.method == "POST":
                type_id = request.form.get("type_id")
                task_name = request.form.get("task_name")
                target_time = request.form.get("target_time")
                frequency = request.form.get("frequency")
                start_date = request.form.get("start_date")
                end_date = request.form.get("end_date")
                elder_mode = int(request.form.get("elder_mode", 0))

                # 查询所选类型的默认提醒规则
                cursor.execute("""
                    SELECT type_name, default_miss_days, default_notify_contact
                    FROM t_checkin_type
                    WHERE type_id = %s;
                """, (type_id,))
                type_info = cursor.fetchone()

                if not type_info:
                    message = "打卡类型不存在，创建失败"
                elif end_date < start_date:
                    message = "结束日期不能早于开始日期"
                else:
                    # 插入打卡任务
                    cursor.execute("""
                        INSERT INTO t_checkin_task
                        (user_id, type_id, task_name, target_time, start_date, end_date,
                         frequency, elder_mode, task_status)
                        VALUES
                        (%s, %s, %s, %s, %s, %s, %s, %s, '进行中');
                    """, (
                        user_id,
                        type_id,
                        task_name,
                        target_time,
                        start_date,
                        end_date,
                        frequency,
                        elder_mode
                    ))

                    new_task_id = cursor.lastrowid

                    # 生成实际提醒规则
                    miss_days_threshold = type_info["default_miss_days"]
                    notify_contact = type_info["default_notify_contact"]

                    # 吃药任务开启老人模式后，也通知紧急联系人
                    if type_info["type_name"] == "吃药" and elder_mode == 1:
                        notify_contact = 1

                    rule_desc = (
                        f"{type_info['type_name']}任务：连续"
                        f"{miss_days_threshold}天未打卡生成异常"
                    )

                    if notify_contact == 1:
                        rule_desc += "，并通知紧急联系人"

                    cursor.execute("""
                        INSERT INTO t_reminder_rule
                        (task_id, remind_time, miss_days_threshold,
                         notify_contact, is_enabled, rule_desc)
                        VALUES
                        (%s, %s, %s, %s, 1, %s);
                    """, (
                        new_task_id,
                        target_time,
                        miss_days_threshold,
                        notify_contact,
                        rule_desc
                    ))

                    conn.commit()
                    return redirect("/user/tasks?message=新打卡任务创建成功")

        return render_template(
            "user_create_task.html",
            types=type_list,
            username=session.get("username"),
            message=message
        )

    finally:
        conn.close()
@app.route("/user/contacts", methods=["GET", "POST"])
def user_contacts():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]
    message = None

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            if request.method == "POST":
                contact_name = request.form.get("contact_name")
                relationship = request.form.get("relationship")
                phone = request.form.get("phone")
                email = request.form.get("email")

                cursor.execute("""
                    INSERT INTO t_emergency_contact
                    (user_id, contact_name, relationship, phone, email, status)
                    VALUES
                    (%s, %s, %s, %s, %s, '启用');
                """, (
                    user_id,
                    contact_name,
                    relationship,
                    phone,
                    email
                ))

                conn.commit()
                message = "紧急联系人添加成功"

            cursor.execute("""
                SELECT
                    contact_id,
                    contact_name,
                    relationship,
                    phone,
                    email,
                    status
                FROM t_emergency_contact
                WHERE user_id = %s
                ORDER BY contact_id;
            """, (user_id,))

            contact_list = cursor.fetchall()

        return render_template(
            "user_contacts.html",
            contacts=contact_list,
            username=session.get("username"),
            message=message
        )

    finally:
        conn.close()
@app.route("/user/statistics")
def user_statistics():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    t.task_id,
                    c.type_name,
                    t.task_name,
                    COUNT(r.record_id) AS total_records,
                    SUM(CASE WHEN r.checkin_status = '已完成' THEN 1 ELSE 0 END) AS on_time_count,
                    SUM(CASE WHEN r.checkin_status = '超时完成' THEN 1 ELSE 0 END) AS late_count,
                    SUM(CASE WHEN r.checkin_status = '未完成' THEN 1 ELSE 0 END) AS miss_count,
                    ROUND(
                        CASE 
                            WHEN COUNT(r.record_id) = 0 THEN 0
                            ELSE SUM(CASE WHEN r.checkin_status IN ('已完成', '超时完成') THEN 1 ELSE 0 END)
                                 / COUNT(r.record_id) * 100
                        END,
                        2
                    ) AS completion_rate
                FROM t_checkin_task t
                JOIN t_checkin_type c ON t.type_id = c.type_id
                LEFT JOIN t_checkin_record r 
                    ON t.task_id = r.task_id
                   AND r.checkin_date <= CURDATE()
                WHERE t.user_id = %s
                GROUP BY
                    t.task_id,
                    c.type_name,
                    t.task_name
                ORDER BY t.task_id;
            """
            cursor.execute(sql, (user_id,))
            statistics_list = cursor.fetchall()

        return render_template(
            "user_statistics.html",
            statistics=statistics_list,
            username=session.get("username")
        )

    finally:
        conn.close()
@app.route("/user/alerts")
def user_alerts():
    if "user_id" not in session:
        return redirect("/login")

    user_id = session["user_id"]

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    a.alert_id,
                    c.type_name,
                    t.task_name,
                    a.alert_type,
                    a.alert_date,
                    a.alert_content,
                    a.handle_status,
                    e.contact_name,
                    e.relationship,
                    n.notify_status
                FROM t_alert_record a
                JOIN t_checkin_task t ON a.task_id = t.task_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                LEFT JOIN t_alert_notify_record n ON a.alert_id = n.alert_id
                LEFT JOIN t_emergency_contact e ON n.contact_id = e.contact_id
                WHERE t.user_id = %s
                  AND a.alert_date <= CURDATE()
                ORDER BY a.alert_date DESC, a.alert_id DESC;
            """
            cursor.execute(sql, (user_id,))
            alert_list = cursor.fetchall()

        return render_template(
            "user_alerts.html",
            alerts=alert_list,
            username=session.get("username")
        )

    finally:
        conn.close()
@app.route("/admin/home")
def admin_home():
    if "user_id" not in session:
        return redirect("/login")

    if session.get("role") != "管理员":
        return "无权限访问管理员页面"

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            user_count = get_count(cursor, "t_user")
            type_count = get_count(cursor, "t_checkin_type")
            task_count = get_count(cursor, "t_checkin_task")
            record_count = get_count(cursor, "t_checkin_record")
            alert_count = get_count(cursor, "t_alert_record")
            notify_count = get_count(cursor, "t_alert_notify_record")

        return render_template(
            "index.html",
            user_count=user_count,
            type_count=type_count,
            task_count=task_count,
            record_count=record_count,
            alert_count=alert_count,
            notify_count=notify_count
        )

    finally:
        conn.close()
@app.route("/admin/users")
def admin_users():
    if "user_id" not in session:
        return redirect("/login")

    if session.get("role") != "管理员":
        return "无权限访问管理员页面"

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    user_id,
                    username,
                    phone,
                    gender,
                    age,
                    role,
                    status,
                    register_time
                FROM t_user
                ORDER BY user_id;
            """
            cursor.execute(sql)
            user_list = cursor.fetchall()

        return render_template("admin_users.html", users=user_list)

    finally:
        conn.close()
@app.route("/admin/send_email/<int:notify_id>", methods=["POST"])
def admin_send_email(notify_id):
    if "user_id" not in session:
        return redirect("/login")

    if session.get("role") != "管理员":
        return "无权限访问管理员页面"

    conn = get_db_connection()

    try:
        with conn.cursor() as cursor:
            sql = """
                SELECT
                    n.notify_id,
                    n.notify_content,
                    e.contact_name,
                    e.email,
                    u.username,
                    c.type_name,
                    t.task_name
                FROM t_alert_notify_record n
                JOIN t_alert_record a ON n.alert_id = a.alert_id
                JOIN t_checkin_task t ON a.task_id = t.task_id
                JOIN t_user u ON t.user_id = u.user_id
                JOIN t_checkin_type c ON t.type_id = c.type_id
                JOIN t_emergency_contact e ON n.contact_id = e.contact_id
                WHERE n.notify_id = %s;
            """
            cursor.execute(sql, (notify_id,))
            notify = cursor.fetchone()

            if not notify:
                return redirect(url_for("alerts", message="通知记录不存在"))

            if not notify["email"]:
                return redirect(url_for("alerts", message="该紧急联系人未填写邮箱，无法发送邮件"))

            subject = f"健康打卡异常提醒：{notify['task_name']}"

            content = f"""您好，{notify['contact_name']}：

系统检测到用户 {notify['username']} 的打卡任务出现异常。

打卡类型：{notify['type_name']}
任务名称：{notify['task_name']}

异常提醒内容：
{notify['notify_content']}

请及时联系用户确认情况。

—— 多场景个性化健康生活打卡管理系统
"""

            try:
                send_email(
                    notify["email"],
                    subject,
                    content
                )

                cursor.execute("""
                    UPDATE t_alert_notify_record
                    SET notify_method = '邮件提醒',
                        notify_status = '已发送',
                        notify_time = NOW()
                    WHERE notify_id = %s;
                """, (notify_id,))
                conn.commit()

                return redirect(url_for("alerts", message="邮件提醒发送成功"))

            except Exception as e:
                cursor.execute("""
                    UPDATE t_alert_notify_record
                    SET notify_method = '邮件提醒',
                        notify_status = '发送失败'
                    WHERE notify_id = %s;
                """, (notify_id,))
                conn.commit()

                return redirect(url_for("alerts", message=f"邮件发送失败：{e}"))

    finally:
        conn.close()
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)