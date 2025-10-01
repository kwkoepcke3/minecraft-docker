#!/usr/bin/env python3

import smtplib
from email.mime.text import MIMEText

from datetime import datetime
import glob
import os

from dotenv import load_dotenv

load_dotenv()

TO = os.getenv("EMAIL")
FROM = os.getenv("EMAIL")
FROM_ALIAS = "minecraft@mc.meiyou.io"

def main():
    crash_time = datetime.now()

    is_crash = True
    latest_crash_report = None

    if os.path.isdir("/opt/minecraft/run/minecraft/crash-reports"):
        latest_crash_report = max(glob.glob("/opt/minecraft/run/minecraft/crash-reports/*"), key=os.path.getctime)

    if latest_crash_report is None:
        is_crash = False
        latest_crash_report = "/opt/minecraft/run/minecraft/logs/latest.log"

    with open(latest_crash_report, 'r') as f:
        report_text = f.read()

    if is_crash:
        email_text = f"For some reason server stopped at ${crash_time}. Here is the latest crash report!\nCheck to see if the crash report matches the subject line! Otherwise it shut down gracefully.\n\n${report_text}"
    else:
        email_text = f"The server turned off at ${crash_time}. It does not seem to be a crash.\n\n${report_text}"

    msg = MIMEText(email_text)

    msg['Subject'] = f"SERVER CRASH ${os.getenv("IPV4")} ${crash_time}"
    msg['From'] = FROM
    msg['To'] = TO

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp_server:
        smtp_server.login(FROM, os.getenv("PASSWORD"))
        smtp_server.sendmail(FROM_ALIAS, TO, msg.as_string())
 
main()
