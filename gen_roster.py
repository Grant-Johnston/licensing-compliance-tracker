import pymysql
import random
from datetime import date, timedelta
from db_config import DB

random.seed(42)

FIRST = ["Maria","James","Priya","Curtis","Danielle","Robert","Sandra","Marcus",
         "Lena","Thomas","Aisha","Gregory","Nina","Wesley","Brenda","Hector",
         "Joy","Derek","Tanya","Owen","Carla","Victor","Renee","Malik",
         "Sofia","Dennis","Kara","Elias","Yvonne","Bruce"]

LAST  = ["Delgado","Whitfield","Raman","Boone","Okafor","Yan","Kiel","Threadgill",
         "Vasquez","Pell","Bright","Stout","Coleridge","Tran","Alcott","Salinas",
         "Fairbanks","Nowak","Ruiz","Marchetti","Hobbs","Nakamura","Ferrell","Quist",
         "Abernathy","Lindqvist","Osei","Vance","Duarte","Whitaker"]

COUNT = 120
npns = random.sample(range(10000000, 99999999), COUNT)

all_names = []
for first in FIRST:
    for last in LAST:
        all_names.append(first + " " + last)

names = random.sample(all_names, COUNT)

today = date.today()

producers = []

for i in range(COUNT):
    name = names[i]
    hire = today - timedelta(days=random.randint(60, 2900))

    roll = random.random()
    if roll < 0.88:
        status = "active"
    elif roll < 0.95:
        status = "inactive"
    else:
        status = "terminated"

    producers.append((name, str(npns[i]), hire, status))

print(len(producers), "producers generated")
for row in producers[:5]:
    print(" ", row)

sql = """
INSERT INTO producer (full_name, npn, hire_date, status)
VALUES (%s, %s, %s, %s)
ON DUPLICATE KEY UPDATE
  full_name = VALUE(full_name),
  hire_date = VALUE(hire_date),
  status    = VALUE(status)
"""

with pymysql.connect(**DB) as conn:
    with conn.cursor() as cur:
        cur.executemany(sql, producers)
    conn.commit()

print("written")
