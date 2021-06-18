from flask import Flask, Response, request
import pymysql as sql
import json
from flask_cors import CORS

app = Flask(__name__)
CORS(app, supports_credentials=True)
app.config.from_json('config.json')

db = sql.connect(host=app.config["DB_HOST"],
                 user=app.config["DB_USER"],
                 password=app.config["DB_PASSWORD"],
                 db=app.config["DB_NAME"])


# 论文查询接口,参数title论文标题，order排序方式
@app.route('/paper', methods=['GET', 'POST'])
def paper():
    cur = db.cursor()
    order = "ORDER BY publishDate DESC"
    if request.args.get('order') == "star":
        order = "ORDER BY star DESC"
    cur.execute("SELECT * FROM v_paperstar WHERE title LIKE %s {}".format(order),
                ('%' + request.args.get('title') + '%')
                )
    results = cur.fetchall()
    lst = []
    for row in results:
        with db.cursor() as cur2:
            cur2.execute("SELECT authorName FROM v_author_of_paper WHERE paperId=%s AND ORD=1", (row[0]))
            lst.append({
                "id": row[0],
                "title": row[1],
                "paperLink": row[2],
                "abs": row[3],
                "publishDate": row[4].strftime('%Y-%m-%d'),
                "star": int(row[5]),
                "author": cur2.fetchone()[0]
            })
    cur.close()
    return Response(json.dumps(lst), mimetype='application/json')


# 数据集信息查询接口，参数id数据集id
@app.route('/ds_info', methods=['GET', 'POST'])
def ds_info():
    d = None
    with db.cursor() as cur:
        cur.execute("SELECT * FROM dataset WHERE datasetId=%s", (request.args.get('id')))
        row = cur.fetchone()
        d = {
            'desc': row[1],
            'link': row[2],
            'createDate': row[3].strftime('%Y-%m-%d'),
            'name': row[4]
        }
    return Response(json.dumps(d), mimetype='application/json')


# 根据数据集查找相关任务，参数id数据集id
@app.route('/ds_task', methods=['GET', 'POST'])
def ds_task():
    lst = []
    with db.cursor() as cur:
        cur.execute("SELECT taskID,taskName FROM v_benchmark_details WHERE datasetId=%s", (request.args.get('id')))
        for row in cur.fetchall():
            lst.append({
                'taskId': row[0],
                'taskName': row[1]
            })
    return Response(json.dumps(lst), mimetype='application/json')


# 根据数据集查找相关基准，会列出所有基准的最佳论文，参数id数据集id
@app.route('/ds_bench', methods=['GET', 'POST'])
def ds_bench():
    lst = []
    with db.cursor() as cur:
        cur.execute("""SELECT b1.taskID,b1.taskName,b1.datasetId,b1.datasetName,b2.modelDesc,b2.paperId,b2.score,b1.benchId 
            FROM v_benchmark_details b1,v_bench_best b2
            WHERE b1.benchId=b2.benchId and b1.datasetId=%s""",
                    (request.args.get('id'))
                    )
        for row in cur.fetchall():
            lst.append({
                'taskId': row[0],
                'taskName': row[1],
                'datasetId': row[2],
                'datasetName': row[3],
                'modelDesc': row[4],
                'paperId': row[5],
                'score': float(row[6]),
                'benchId': row[7]
            })
    return Response(json.dumps(lst), mimetype='application/json')


# 根据数据集列出相关论文，需要支持查找功能，参数id数据集id，参数title论文标题
@app.route('/ds_paper', methods=['GET', 'POST'])
def ds_paper():
    lst = []
    with db.cursor() as cur:
        cur.execute("""SELECT paperId,title,publishDate FROM paper
        WHERE paperId in (SELECT paperId FROM v_bench_of_paper b WHERE b.datasetId=%s) AND title LIKE %s""",
                    (request.args.get('id'), '%' + request.args.get('title') + '%'))
        for row in cur.fetchall():
            lst.append({
                'paperId': row[0],
                'title': row[1],
                'publishDate': row[2].strftime('%Y-%m-%d'),
            })
    return Response(json.dumps(lst), mimetype='application/json')


# 根据任务列出相关数据集，参数id任务id
@app.route('/task_ds', methods=['GET', 'POST'])
def task_ds():
    lst = []
    with db.cursor() as cur:
        cur.execute("SELECT datasetID,datasetName FROM v_benchmark_details WHERE taskId=%s", (request.args.get('id')))
        for row in cur.fetchall():
            lst.append({
                'datasetId': row[0],
                'dadasetName': row[1]
            })
    return Response(json.dumps(lst), mimetype='application/json')


# 根据任务集查找相关基准，会列出所有基准的最佳论文，参数id数据集id
@app.route('/task_bench', methods=['GET', 'POST'])
def task_bench():
    lst = []
    with db.cursor() as cur:
        cur.execute("""SELECT b1.taskID,b1.taskName,b1.datasetId,b1.datasetName,b2.modelDesc,b2.paperId,b2.score,b1.benchId 
            FROM v_benchmark_details b1,v_bench_best b2
            WHERE b1.benchId=b2.benchId and b1.taskId=%s""",
                    (request.args.get('id'))
                    )
        for row in cur.fetchall():
            lst.append({
                'taskId': row[0],
                'taskName': row[1],
                'datasetId': row[2],
                'datasetName': row[3],
                'modelDesc': row[4],
                'paperId': row[5],
                'score': float(row[6]),
                'benchId': row[7]
            })
    return Response(json.dumps(lst), mimetype='application/json')


# 根据评测基准列出论文排行榜单，根据分数从高到低排好序，参数id为基准id
@app.route('/bench_board', methods=['GET', 'POST'])
def bench_board():
    lst = []
    with db.cursor() as cur:
        cur.execute("""SELECT b.modelDesc,b.score,p.paperId,p.title,p.publishDate
            FROM paperbench b INNER JOIN paper p ON p.paperId=b.paperId
            WHERE b.benchId=%s
            ORDER BY b.score DESC""",
                    (request.args.get('id'))
                    )
        for row in cur.fetchall():
            lst.append({
                'modelDesc': row[0],
                'score': float(row[1]),
                'paperId': row[2],
                'title': row[3],
                'publishDate': row[4].strftime('%Y-%m-%d'),
            })
    return Response(json.dumps(lst), mimetype='application/json')


# 评测基准信息，参数id为基准id
@app.route('/bench', methods=['GET', 'POST'])
def bench():
    d = None
    with db.cursor() as cur:
        cur.execute("""SELECT * FROM v_benchmark_details WHERE benchId=%s""",
                    (request.args.get('id'))
                    )
        row = cur.fetchone()
        d = {
            'taskId': row[1],
            'datasetId': row[2],
            'metric': row[3],
            'taskName': row[4],
            'datasetName': row[5]
        }
    return Response(json.dumps(d), mimetype='application/json')


# 根据作者id列出其姓名、机构、论文、研究领域，参数id为作者id
@app.route('/author', methods=['GET', 'POST'])
def author():
    d = {
        'name': '',
        'inst': '',
        'paperList': [],
        'taskList': []
    }
    with db.cursor() as cur:
        cur.execute("SELECT * FROM author WHERE authorId=%s", (request.args.get('id')))
        row = cur.fetchone()
        d['name'] = row[1]
        d['inst'] = row[2]

        cur.execute("""SELECT p.paperId,p.title,p.publishDate,a.ord
            FROM v_author_of_paper a INNER JOIN paper p ON a.paperId=p.paperId
            WHERE a.authorId=%s
            ORDER BY p.publishDate DESC"""
                    , (request.args.get('id')))
        for row in cur.fetchall():
            d['paperList'].append({
                'paperId': row[0],
                'title': row[1],
                'publishDate': row[2].strftime('%Y-%m-%d'),
                'ord': row[3],
            })

        cur.execute("""SELECT b.taskId,b.taskName
            FROM v_author_of_paper a INNER JOIN v_bench_of_paper b ON a.paperId=b.paperId
            WHERE a.authorId=%s"""
                    , (request.args.get('id')))
        for row in cur.fetchall():
            d['taskList'].append({
                'taskId': row[0],
                'taskName': row[1],
            })
    return Response(json.dumps(d), mimetype='application/json')


'''
dataset查询接口
根据名称模糊查找数据集
查询应用到某个任务的数据集
对上述查询结果按相关论文数或者发布时间排序
dataName: 数据集标题
taskName: 任务标题
order: 排序方式
'''


@app.route('/dataset', methods=['GET', 'POST'])
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


@app.route('/sota', methods=['GET', 'POST'])
def sota():
    cur = db.cursor()
    cur.execute("SELECT * FROM v_task_papercount JOIN v_task_benchcount USING(taskId) ORDER BY paperCnt DESC;")
    results = cur.fetchall()
    lst = []
    for row in results:
        lst.append({
            "taskId": row[0],
            "taskName": row[1],
            "taskDesc": row[2],
            "paperCnt": row[3],
            "benchCnt": row[4]
        })
    cur.close()
    return Response(json.dumps(lst), mimetype='application/json')


'''
methods查询接口
根据方法对应的论文数量对方法排序
筛选某一方法的所有论文。在该筛选结果中按论文名模糊查找
methodName: 方法名称
title: 论文名称
taskName
'''


@app.route('/methods', methods=['GET', 'POST'])
def method():
    cur = db.cursor()
    methodName = request.args.get('methodName')
    title = request.args.get('title')
    secsql = ''
    if methodName is not None:
        secsql = 'WHERE methodName = "' + methodName + '"'
    if title is not None and len(title.strip()) > 0:
        if methodName is not None:
            secsql += 'AND title LIKE "%' + title + '%"'
        else:
            secsql = 'WHERE title LIKE "%' + title + '%"'
    if len(secsql.strip()) == 0:
        cur.execute("SELECT * FROM v_method_papercount ORDER BY paperCnt DESC")
    else:
        cur.execute("""SELECT DISTINCT * 
        FROM v_method_of_paper JOIN paper USING(paperId) JOIN method m USING(methodId, methodName) JOIN v_fircode_paper USING(paperId) 
        {}""".format(secsql))
    results = cur.fetchall()
    lst = []
    if methodName is None and title is None:
        for row in results:
            lst.append({
                "methodName": row[0],
                "methodDesc": row[1],
                "paperCnt": row[3]
            })
    else:
        for row in results:
            lst.append({
                "methodName": row[1],
                "methodDesc": row[7],
                "title": row[3],
                "paperLink": row[4],
                "publishDate": row[6].strftime('%Y-%m-%d'),
                "codeLink": row[8]
            })
    cur.close()
    return Response(json.dumps(lst), mimetype='application/json')


'''
task查询接口
根据任务查询所有相关的评价指标，以及参与该评价指标中得分最高的论文
根据任务查询所有相关的数据集
taskName: 任务名称
'''


@app.route('/task', methods=['GET', 'POST'])
def task():
    cur = db.cursor()
    taskName = request.args.get('taskName')
    cur.execute('SELECT * FROM v_bestbench_of_task WHERE taskName = %s', (taskName))
    results = cur.fetchall()
    lst = []
    for row in results:
        lst.append({
            "title": row[0],
            "benchId": row[1],
            "paperLink": row[2],
            "metric": row[3],
            "datasetName": row[4],
            "datasetId": row[5],
            "taskName": row[6],
            "taskDesc": row[7],
            "codeLink": row[8]
        })
    cur.close()
    return Response(json.dumps(lst), mimetype='application/json')


"""
response = {
    title: str, paperLink: str, abs: str, publishDate: str,
    codes: [{data of code1}, {data of code2}, ...],
    authors: [{data of author1}, {data of author2}, ...],   // author list is sort by ord
    methods: [{data of method1}, {data of method2}, ...],
    benchmarks: [{data of benchmark1}, {data of benchmark2}, ...],
}
data of code = {codeId, codeLink, stars, framework}
data of author = {authorId, authorName, ord}
data of method = {methodId, methodName}
data of benchmark = {benchId, taskId, datasetId, metric, taskName, datasetName}
"""


@app.route('/paperDetails', methods=['GET', 'POST'])
def paperDetails():
    rst = {}
    paperId = int(request.args.get('pid'))

    with db.cursor() as cur:
        cur.execute("SELECT * FROM paper WHERE paperId = %s", (paperId,))
        result = cur.fetchone()
        rst["title"] = result[1]
        rst["paperLink"] = result[2]
        rst["abs"] = result[3]
        rst["publishDate"] = result[4].strftime('%Y-%m-%d')

    with db.cursor() as cur:
        cur.execute("SELECT * FROM v_code_of_paper WHERE paperId = %s", (paperId,))
        results = cur.fetchall()
        data = []
        for row in results:
            data.append({
                "codeId": row[0],
                "codeLink": row[2],
                "stars": row[3],
                "framework": row[4]
            })
        rst["codes"] = data

    with db.cursor() as cur:
        cur.execute("SELECT * FROM v_author_of_paper WHERE paperId = %s ORDER BY ord", (paperId,))
        results = cur.fetchall()
        data = []
        for row in results:
            data.append({
                "authorId": row[1],
                "authorName": row[2],
                "ord": row[3],
            })
        rst["authors"] = data

    with db.cursor() as cur:
        cur.execute("SELECT * FROM v_method_of_paper WHERE paperId = %s", (paperId,))
        results = cur.fetchall()
        data = []
        for row in results:
            data.append({
                "methodId": row[1],
                "methodName": row[2],
            })
        rst["methods"] = data

    with db.cursor() as cur:
        cur.execute("SELECT * FROM v_bench_of_paper WHERE paperId = %s", (paperId,))
        results = cur.fetchall()
        data = []
        for row in results:
            data.append({
                "benchId": row[1],
                "taskId": row[2],
                "datasetId": row[3],
                "metric": row[4],
                "taskName": row[5],
                "datasetName": row[6],
            })
        rst["benchmarks"] = data

    return Response(json.dumps(rst), mimetype='application/json')


if __name__ == '__main__':
    app.run(debug=True)
