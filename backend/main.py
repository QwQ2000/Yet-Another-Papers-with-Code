from flask import Flask, Response, request
import pymysql as sql
import json

app = Flask(__name__)
app.config.from_json('config.json')

db = sql.connect(host=app.config["DB_HOST"],
                 user=app.config["DB_USER"],
                 password=app.config["DB_PASSWORD"],
                 db=app.config["DB_NAME"])


# 论文查询接口,参数title论文标题，order排序方式
@app.route('/paper', methods=['GET', 'POST'])
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
            "title": row[0],
            "paperLink": row[1],
            "abs": row[2],
            "publishDate": row[3].strftime('%Y-%m-%d'),
            "star": int(row[4])
        })
    return Response(json.dumps(lst), mimetype='application/json')


# 论文查询接口
@app.route('/author', methods=['GET', 'POST'])
def author():
    # cur = db.cursor()
    pass


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
