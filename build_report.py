import pymysql
import sys
from datetime import datetime, date
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment
from db_config import DB

OUTPUT = "/home/grant/Reports/licensing_report_" + str(date.today()) + ".xlsx"

HEADER_FONT = Font(name="Calibri", size=11, bold=True, color="FFFFFF")
HEADER_FILL = PatternFill(fill_type="solid", start_color="1F4E79")


def stamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def get_rows(sql):
    try:
        with pymysql.connect(**DB) as conn:
           with conn.cursor() as cur:
               cur.execute(sql)
               rows = cur.fetchall()
    except pymysql.MySQLError as error:
        print(stamp(), "FAILED: could not read the database:", error)
        sys.exit(1)

    return rows

def style_sheet(sheet, widths):

    for letter, width in widths.items():
        sheet.column_dimensions[letter].width = width

    for cell in sheet[1]:
        cell.font = HEADER_FONT
        cell.fill = HEADER_FILL

    sheet.freeze_panes = "A2"
    sheet.auto_filter.ref = sheet.dimensions

    for row in sheet.iter_rows(min_row=2):
        for cell in row:
            if cell.is_date:
                cell.number_format = "mm/dd/yyyy"

print(stamp(), "started")

roster_rows = get_rows("""
    SELECT p.full_name, p.npn, l.state_code, l.license_number,
           l.line_of_authority, l.expiration_date, l.status
    FROM license l
    JOIN producer p ON l.producer_id = p.id
    ORDER BY p.full_name, p.npn, l.state_code
""")

print(len(roster_rows), "licenses on the Full Roster")

wb = Workbook()

dashboard = wb.active
dashboard.title = "Dashboard"

expiring = wb.create_sheet("Expiring Soon")
exceptions = wb.create_sheet("Exceptions")
roster = wb.create_sheet("Full Roster")

roster.append(["Producer", "NPN", "State", "License #",
               "Line of Authority", "Expires", "License Status"])

for row in roster_rows:
    roster.append(row)

style_sheet(roster, {
    "A": 22,    # Producer
    "B": 11,    # NPN
    "C": 8,     # State
    "D": 14,    # License #
    "E": 22,    # Line of Authority
    "F": 12,    # Expires
    "G": 16,    # License Status
})

lapsed_rows = get_rows("""
    SELECT 'Expired, still marked active',
           p.full_name, p.npn, p.status, l.state_code, l.license_number,
           l.expiration_date,
           DATEDIFF(CURDATE(), l.expiration_date)
    FROM license l
    JOIN producer p ON l.producer_id = p.id
    WHERE l.status = 'active'
      AND l.expiration_date < CURDATE()
    ORDER BY l.expiration_date, p.full_name
""")

missing_rows = get_rows("""
    SELECT 'No license on file',
           p.full_name, p.npn, p.status, NULL, NULL, NULL, NULL
    FROM producer p
    LEFT JOIN license l ON l.producer_id = p.id
    WHERE p.status = 'active'
      AND l.id IS NULL
   ORDER BY p.full_name
""")

print(len(lapsed_rows), "expired but still marked active")
print(len(missing_rows), "active producers with no license")

exceptions.append(["Issue", "Producer", "NPN", "Producer Status",
                   "State", "License #", "Expired", "Days Lapsed"])

for row in lapsed_rows:
    exceptions.append(row)

for row in missing_rows:
    exceptions.append(row)

style_sheet(exceptions, {
    "A": 30, # Issue
    "B": 22, # Producer
    "C": 11, # NPN
    "D": 18, # Producer Status
    "E": 8,  # State
    "F": 14, # License #
    "G": 12, # Expired
    "H": 14, # Days Lapsed
})

RED_FILL = PatternFill(fill_type="solid", start_color="FFC7CE")
RED_FONT = Font(name="Calibri", size=11, color="9C0006")
YELLOW_FILL = PatternFill(fill_type="solid", start_color="FFEB9C")
YELLOW_FONT = Font(name="Calibri", size=11, color="9C6500")
GREEN_FILL = PatternFill(fill_type="solid", start_color="C6EFCE")
GREEN_FONT = Font(name="Calibri", size=11, color="006100")

CENTER = Alignment(horizontal="center") 

expiring_rows = get_rows("""
    SELECT p.full_name, p.npn, l.state_code, l.license_number,
           l.line_of_authority, l.expiration_date,
           DATEDIFF(l.expiration_date, CURDATE()),
           CASE
               WHEN DATEDIFF(l.expiration_date, CURDATE()) <= 30 THEN '0-30 days'
               WHEN DATEDIFF(l.expiration_date, CURDATE()) <= 60 THEN '31-60 days'
               ELSE '61-90 days'
          END
    FROM license l
    JOIN producer p ON l.producer_id = p.id
    WHERE l.status = 'active'
      AND p.status = 'active'
      AND l.expiration_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 90 DAY
    ORDER BY l.expiration_date, p.full_name
""")

print(len(expiring_rows), "expiring in the next 90 days")

expiring.append(["Producer", "NPN", "State", "License #",
                 "Line of Authority", "Expires", "Days Left", "Window"])

for row in expiring_rows:
    expiring.append(row)

style_sheet(expiring, {
    "A": 22, # Producer
    "B": 11, # NPN
    "C": 8,  # State
    "D": 14, # License #
    "E": 22, # Line of Authority
    "F": 12, # Expires
    "G": 12, # Days Left
    "H": 13, # Windows
})

for row in expiring.iter_rows(min_row=2):
    days_left = row[6].value

    if days_left <= 30:
        fill = RED_FILL
        font = RED_FONT
    elif days_left <= 60:
        fill = YELLOW_FILL
        font = YELLOW_FONT
    else:
        fill = GREEN_FILL
        font = GREEN_FONT

    for cell in row[6:]:
        cell.fill = fill
        cell.font = font
        cell.alignment = CENTER

due_30 = 0
due_60 = 0
due_90 = 0
for row in expiring_rows:
    days_left = row[6]

    if days_left <= 30:
        due_30 = due_30 + 1
    elif days_left <= 60:
        due_60 = due_60 + 1
    else:
        due_90 = due_90 + 1

count_rows = get_rows("SELECT COUNT(*) FROM producer WHERE status = 'active'")
active_producers = count_rows[0][0]

dashboard.append(["Producer Licensing Compliance Report"])
dashboard.append(["Generated", datetime.now()])
dashboard.append([])
dashboard.append(["Measure", "Count"])
dashboard.append(["Active producers", active_producers])
dashboard.append(["Licenses on file", len(roster_rows)])
dashboard.append(["Expiring in 0-30 days", due_30])
dashboard.append(["Expiring in 31-60 days", due_60])
dashboard.append(["Expiring in 61-90 days", due_90])
dashboard.append(["Expired, still marked active", len(lapsed_rows)])
dashboard.append(["Active producers with no license", len(missing_rows)])

dashboard.column_dimensions["A"].width = 34
dashboard.column_dimensions["B"].width = 20

dashboard["A1"].font = Font(name="Calibri", size=14, bold=True)

dashboard["B2"].number_format = "mm/dd/yyyy h:mm AM/PM"

for cell in dashboard[4]:
    cell.font = HEADER_FONT
    cell.fill = HEADER_FILL

dashboard["B7"].fill = RED_FILL
dashboard["B7"].font = RED_FONT
dashboard["B8"].fill = YELLOW_FILL
dashboard["B8"].font = YELLOW_FONT
dashboard["B9"].fill = GREEN_FILL
dashboard["B9"].font = GREEN_FONT

if len(lapsed_rows) > 0:
    dashboard["B10"].fill = RED_FILL
    dashboard["B10"].font = RED_FONT
if len(missing_rows) > 0:
    dashboard["B11"].fill = RED_FILL
    dashboard["B11"].font = RED_FONT

wb.save(OUTPUT)
print(stamp(), "saved", OUTPUT)


