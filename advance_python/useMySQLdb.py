
import MySQLdb

# connect to db

conn = MySQLdb.connect("192.168.144.237", "data", "PIN239!@#$%^&8")

# create cursor
cur = conn.cursor()

# sql
sql = "select * from monitor.checklist_master"

# excute
cur.excute(sql)

result = cur.fetchall()


for row in result:
    print(row[0])
    print(row[1])


conn.close()
