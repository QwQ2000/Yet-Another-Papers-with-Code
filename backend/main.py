from flask import Flask,Response,request
import pymysql as sql
import json

app = Flask(__name__)
app.config.from_json('config.json')

db = sql.connect(host = app.config["DB_HOST"],
    user = app.config["DB_USER"],
    password = app.config["DB_PASSWORD"],
    db = app.config["DB_NAME"])

#论文查询接口,参数title论文标题，order排序方式
@app.route('/paper',methods = ['GET','POST'])
def paper():
    cur = db.cursor()
    order = "ORDER By publishDate"
    if request.args.get('order') == "star":
        order = "ORDER BY star"
    cur.execute("SELECT * FROM v_paperstar WHERE title LIKE '%{}%' {}".format(request.args.get('title'),order))
    results = cur.fetchall()
    lst = []
    for row in results:
        lst.append({
            "title" : row[0],
            "paperLink" : row[1],
            "abs" : row[2],
            "publishDate" : row[3].strftime('%Y-%m-%d'),
            "star" : int(row[4])
        })
    return Response(json.dumps(lst),mimetype = 'application/json')

#论文查询接口
@app.route('/author',methods = ['GET','POST'])
def author():
    #cur = db.cursor()
    pass

if __name__ == '__main__':
    app.run(debug = True)