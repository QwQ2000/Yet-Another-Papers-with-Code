from flask import Flask,Response
import pymysql as sql
import json

app = Flask(__name__)
app.config.from_json('config.json')

db = sql.connect(host = app.config["DB_HOST"],
    user = app.config["DB_USER"],
    password = app.config["DB_PASSWORD"],
    db = app.config["DB_NAME"])

@app.route('/',methods=['GET','POST'])
def test():
    cursor = db.cursor()
    cursor.execute("SELECT * FROM paper")
    results = cursor.fetchall()
    lst = []
    for row in results:
        lst.append({
            "title" : row[1],
            "paperLink" : row[2]
        })
    return Response(json.dumps(lst),mimetype = 'application/json')

if __name__ == '__main__':
    app.run(debug = True)