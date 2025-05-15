
import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="upsidedown",
    database="formation_numcity"
)

cursor = conn.cursor()
cursor.execute("select * from equipement;")
rows = cursor.fetchall()

for row in rows:
    print(row)

cursor.close()
conn.close()
