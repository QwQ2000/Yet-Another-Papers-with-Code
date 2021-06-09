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
    cur.execute("SELECT * FROM v_paperstar WHERE title LIKE %s {}".format(order),
        ('%' + request.args.get('title') + '%')
    )
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

'''
dataset查询接口
根据名称模糊查找数据集
查询应用到某个任务的数据集
对上述查询结果按相关论文数或者发布时间排序
dataName: 数据集标题
taskName: 任务标题
order: 排序方式
'''
@app.route('/dataset',methods= ['GET', 'POST'])
def dataset():
    with db.cursor() as cur:
        order = "ORDER BY createDate"
        if request.args.get('order') == "paperCnt":
            order = "ORDER BY paperCnt DESC"
        dataName = ''
        taskName = ''
        if request.args.get('dataName') is not None:
            dataName = 'WHERE datasetName LIKE "%' + request.args.get('dataName') + '%"'
        if request.args.get('taskName') is not None:
            taskName = 'WHERE taskName LIKE "%' + request.args.get('taskName') + '%"'
        cur.execute("SELECT * FROM v_dataset_papercount {} {} {}".format(dataName, taskName, order)
        )
        results = cur.fetchall()
        lst = []
        for row in results:
            lst.append({
                "datasetName": row[3],
                "datasetLink": row[1],
                "datasetDesc": row[0],
                "createDate": row[2].strftime('%Y-%m-%d'),
                "taskName": row[4]
            })
    return Response(json.dumps(lst), mimetype='application/json')

'''
SOTA查询接口
根据任务对应的论文数量对任务排序
'''
@app.route('/sota',methods= ['GET', 'POST'])
def sota():
    cur = db.cursor()
    cur.execute("SELECT * FROM v_task_of_paper ORDER BY paperCnt DESC")
    results = cur.fetchall()
    lst = []
    for row in results:
        lst.append({
            "taskName": row[0],
            "taskDesc": row[1]
        })
    cur.close()
    return Response(json.dumps(lst), mimetype='application/json')

'''
method查询接口
根据方法对应的论文数量对方法排序
筛选某一方法的所有论文。在该筛选结果中按论文名模糊查找
methodName: 方法名称
title: 论文名称
'''
@app.route('/method',methods= ['GET', 'POST'])
def method():
    cur = db.cursor()
    cur.execute("SELECT * FROM v_method_papercount ORDER BY paperCnt DESC")
    results = cur.fetchall()
    lst = []
    for row in results:
        lst.append({
            "methodName": row[0],
            "methodDesc": row[1]
        })
    cur.close()
    return Response(json.dumps(lst), mimetype='application/json')


if __name__ == '__main__':
    app.run(debug = True)