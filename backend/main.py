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
    order = "ORDER BY publishDate"
    if request.args.get('order') == "star":
        order = "ORDER BY star DESC"
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

#数据集信息查询接口，参数id数据集id
@app.route('/ds_info',methods = ['GET','POST'])
def ds_info():
    d = None
    with db.cursor() as cur:
        cur.execute("SELECT * FROM dataset WHERE datasetId=%s",(request.args.get('id')))
        row = cur.fetchone()
        d = {
            'desc':row[1],
            'link':row[2],
            'createDate':row[3].strftime('%Y-%m-%d'),
            'name':row[4]
        }
    return Response(json.dumps(d),mimetype = 'application/json')

#根据数据集查找相关任务，参数id数据集id
@app.route('/ds_task',methods = ['GET','POST'])
def ds_task():
    lst = []
    with db.cursor() as cur:
        cur.execute("SELECT taskID,taskName FROM v_benchmark_details WHERE datasetId=%s",(request.args.get('id')))
        for row in cur.fetchall():
            lst.append({
                'taskId':row[0],
                'taskName':row[1]
            })
    return Response(json.dumps(lst),mimetype = 'application/json')

#根据数据集查找相关基准，会列出所有基准的最佳论文，参数id数据集id
@app.route('/ds_bench',methods = ['GET','POST'])
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
                'taskId':row[0],
                'taskName':row[1],
                'datasetId':row[2],
                'datasetName':row[3],
                'modelDesc':row[4],
                'paperId':row[5],
                'score':float(row[6]),
                'benchId':row[7]
            })
    return Response(json.dumps(lst),mimetype = 'application/json')

#根据数据集列出相关论文，需要支持查找功能，参数id数据集id，参数title论文标题
@app.route('/ds_paper',methods = ['GET','POST'])
def ds_paper():
    lst = []
    with db.cursor() as cur:
        cur.execute("""SELECT paperId,title,publishDate FROM paper
        WHERE paperId in (SELECT paperId FROM v_bench_of_paper b WHERE b.datasetId=%s) AND title LIKE %s""",
        (request.args.get('id'),'%' + request.args.get('title') + '%'))
        for row in cur.fetchall():
            lst.append({
                'paperId':row[0],
                'title':row[1],
                'publishDate':row[2].strftime('%Y-%m-%d'),
            })
    return Response(json.dumps(lst),mimetype = 'application/json')

#根据任务列出相关数据集，参数id任务id
@app.route('/task_ds',methods = ['GET','POST'])
def task_ds():
    lst = []
    with db.cursor() as cur:
        cur.execute("SELECT datasetID,datasetName FROM v_benchmark_details WHERE taskId=%s",(request.args.get('id')))
        for row in cur.fetchall():
            lst.append({
                'datasetId':row[0],
                'dadasetName':row[1]
            })
    return Response(json.dumps(lst),mimetype = 'application/json')

#根据任务集查找相关基准，会列出所有基准的最佳论文，参数id数据集id
@app.route('/task_bench',methods = ['GET','POST'])
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
                'taskId':row[0],
                'taskName':row[1],
                'datasetId':row[2],
                'datasetName':row[3],
                'modelDesc':row[4],
                'paperId':row[5],
                'score':float(row[6]),
                'benchId':row[7]
            })
    return Response(json.dumps(lst),mimetype = 'application/json')

#根据评测基准列出论文排行榜单，根据分数从高到低排好序，参数id为基准id
@app.route('/bench_board',methods = ['GET','POST'])
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
                'modelDesc':row[0],
                'score':float(row[1]),
                'paperId':row[2],
                'title':row[3],
                'publishDate':row[4].strftime('%Y-%m-%d'),
            })
    return Response(json.dumps(lst),mimetype = 'application/json')

#根据作者id列出其姓名、机构、论文、研究领域，参数id为作者id
@app.route('/author',methods = ['GET','POST'])
def author():
    d = {
        'name':'',
        'inst':'',
        'paperList':[],
        'taskList':[]
    }
    with db.cursor() as cur:
        cur.execute("SELECT * FROM author WHERE authorId=%s",(request.args.get('id')))
        row = cur.fetchone()
        d['name'] = row[1]
        d['inst'] = row[2]

        cur.execute("""SELECT p.paperId,p.title,p.publishDate,a.ord
            FROM v_author_of_paper a INNER JOIN paper p ON a.paperId=p.paperId
            WHERE a.authorId=%s
            ORDER BY p.publishDate DESC"""
            ,(request.args.get('id')))
        for row in cur.fetchall():
            d['paperList'].append({
                'paperId':row[0],
                'title':row[1],
                'publishDate':row[2].strftime('%Y-%m-%d'),
                'ord':row[3],
            })
        
        cur.execute("""SELECT b.taskId,b.taskName
            FROM v_author_of_paper a INNER JOIN v_bench_of_paper b ON a.paperId=b.paperId
            WHERE a.authorId=%s"""
            ,(request.args.get('id')))
        for row in cur.fetchall():
            d['taskList'].append({
                'taskId':row[0],
                'taskName':row[1],
            })
    return Response(json.dumps(d),mimetype = 'application/json')

if __name__ == '__main__':
    app.run(debug = True)