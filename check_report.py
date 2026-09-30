from datetime import date
from openpyxl import load_workbook

REPORT = "/home/grant/Reports/licensing_report_" + str(date.today()) + ".xlsx"
print(REPORT)

wb = load_workbook(REPORT)

for ws in wb:
    print(ws.title, ws.max_row)
