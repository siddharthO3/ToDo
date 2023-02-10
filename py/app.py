from flask import Flask, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

name = "root"
host = "localhost"
user = "root"
password = "12345678"

# Initialize DB
@app.route("/", methods = ['GET'])
def index():
    global host, user, password

    conn = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database="todo",
    )
    cursor = conn.cursor()
    try:
        here = os.path.dirname(os.path.abspath(__file__))

        filename = os.path.join(here, 'db.sql')
        with open(filename, 'r') as sql_file:
            result_iterator = cursor.execute(sql_file.read(), multi=True)
            print(cursor)
            print(cursor.fetchall())
            for res in result_iterator:
                print("Running query: ", res)  # Will print out a short representation of the query
                print(f"Affected {res.rowcount} rows" )
            conn.commit() 
            print("init done!")

    except Exception as ex:
        template = "An exception of type {0} occurred. Arguments:\n{1!r}"
        message = template.format(type(ex).__name__, ex.args)
        print (message)
        return jsonify({"db_initialized":False})
    finally:
        cursor.close()
        conn.close()
    return jsonify({"db_initialized":True})

#Login Screen: Create user if not exists else verify credentials
@app.route("/connect",  methods=["GET"])
def login():
    global name
    name = request.args["name"]
    pwd = request.args["password"]

    global host, user, password

    conn = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database="todo",
    )
    
    cursor = conn.cursor()
    cursor.execute(f"select * from person where name = \"{name}\"")
    res = cursor.fetchall()
    if not res:
        cursor.execute(f"INSERT INTO person (name, password) VALUES (\"{name}\", \"{password}\")")
        conn.commit()
        cursor.execute(f"select * from person where name = \"{name}\"")
        res = cursor.fetchall()
    elif res[0][2] != pwd:
        return jsonify({"status":False})
    person_id = res[0][0]

    cursor.execute("SELECT * FROM person natural join tasks ORDER BY tasks.task_id")
    res = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({"status":True, "id": person_id, "name":name, "tasks": res})

# Add tasks
@app.route("/add", methods = ['GET'])
def add_task():

    person_id = request.args['id']
    task = request.args['task']
    global host, user, password

    conn = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database="todo",
    )

    cursor = conn.cursor()
    cursor.execute(f"INSERT into tasks (person_id, task) values ({person_id}, \"{task}\")")
    conn.commit()
    cursor.execute("SELECT * FROM person natural join tasks ORDER BY tasks.task_id")
    res = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({"tasks": res, "name":name,})

#Delete tasks
@app.route("/delete", methods = ['GET'])
def delete_task():

    task_id = request.args['id']
    global host, user, password

    conn = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database="todo",
    )

    cursor = conn.cursor()
    cursor.execute(f"DELETE FROM tasks where task_id = {task_id}")
    conn.commit()
    cursor.execute("SELECT * FROM person natural join tasks ORDER BY tasks.task_id")
    res = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify({"tasks": res, "name":name,})

if __name__ == "__main__":
    app.run()
