import pymysql
import random
from datetime import date, timedelta
from db_config import DB

random.seed(99)

LINES_OF_AUTHORITY = ["Property & Casualty", "All Lines", "Adjuster"]

today = date.today()

# Connecting to the database 
producer_ids = []
states = []

with pymysql.connect(**DB) as conn:
    with conn.cursor() as cur:
        
        cur.execute("SELECT id FROM producer ORDER BY id")
        
        for row in cur.fetchall():
            producer_ids.append(row[0])


        cur.execute("""
            SELECT state_code FROM jurisdiction
            WHERE requires_license = 1
              AND state_code IN ('AL','AR','AZ','CA','FL','GA','IA',
                                 'IN','KY','LA','MN','MS','NC','NM',
                                 'NY','OK','SC','TX','UT','WV')
            ORDER BY state_code
        """)
        for row in cur.fetchall():
            states.append(row[0])

print(len(producer_ids), "producers to license,", len(states), "states in the footprint")

# Creating licenses
licenses = []

for producer_id in producer_ids:

    how_many = random.choices([0, 1, 2, 3, 4], weights=[5, 45, 30, 15, 5])[0]
 
    if how_many == 0:
        continue
   
    chosen_states = random.sample(states, how_many)

    for state in chosen_states:

        line_of_authority = random.choice(LINES_OF_AUTHORITY)

        roll = random.random()

        if roll < 0.08:
            expiration = today - timedelta(days=random.randint(1, 200))
            status = "active"

        elif roll < 0.12:
            expiration = today - timedelta(days=random.randint(1, 400))
            status = "expired"

        else:
            expiration = today + timedelta(days=random.randint(5, 540))
            status = "active"
       
        effective = expiration - timedelta(days=730)

        license_number = state + "-" + str(random.randint(1000000, 9999999))

        licenses.append((
            producer_id,
            state,
            license_number,
            line_of_authority,
            effective,
            expiration,
            status
        ))

# Print the summary
exceptions = 0
closed_out = 0

for lic in licenses:
    expiration = lic[5]
    status = lic[6]

    if expiration < today and status == "active":
        exceptions = exceptions + 1

    if status == "expired":
        closed_out = closed_out + 1

print(len(licenses), "licenses generated")
print(" ", exceptions, "expired but still marked active  <- the exception report")
print(" ", closed_out, "expired and correctly closed out <- the control")

for lic in licenses[:3]:
    print(" ", lic)

# Write licenses to database
sql = """
INSERT INTO license
  (producer_id, state_code, license_number, line_of_authority,
   effective_date, expiration_date, status)
VALUES (%s, %s, %s, %s, %s, %s, %s)
ON DUPLICATE KEY UPDATE
  license_number  = VALUE(license_number),
  effective_date  = VALUE(effective_date),
  expiration_date = VALUE(expiration_date),
  status          = VALUE(status)
"""

with pymysql.connect(**DB) as conn:
    with conn.cursor() as cur:
        cur.executemany(sql, licenses)
    conn.commit()

print("written")





























