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
FROM_ALIAS = f"minecraft@{os.getenv("IPV4")}"

def main():
    crash_time = datetime.now()

    latest_crash_report = max(glob.glob("/opt/minecraft/run/minecraft/crash-reports/*"), key=os.path.getctime)
    with open(latest_crash_report, 'r') as f:
        report_text = f.read()

    email_text = f"For some reason server stopped at ${crash_time}. Here is the latest crash report!\nCheck to see if the crash report matches the subject line! Otherwise it shut down gracefully.\n\n${report_text}"
    msg = MIMEText(email_text)

    msg['Subject'] = f"SERVER CRASH ${os.getenv("IPV4")} ${crash_time}"
    msg['From'] = FROM
    msg['To'] = TO

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp_server:
        smtp_server.login(FROM, os.getenv("PASSWORD"))
        smtp_server.sendmail(FROM_ALIAS, TO, msg.as_string())
 
main()
