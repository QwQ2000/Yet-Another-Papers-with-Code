<template>
    <div id="paperinfo">
        <br><br>
        <el-row margin-top="15px" type="flex" align="middle">
            <el-col span="3"/>
            <el-col span="16" >
                <div class="border">
                    <el-row>
                    <br>
                    <h2>{{title}}</h2>
                    <a style="font:13px Small">
                        <i class="el-icon-time"/>&nbsp {{date}} &nbsp &nbsp
                        <i class="el-icon-user"/>&nbsp
                        <span v-for="(it,index) in authors" :key="index">
                            <router-link :to="{name:'Author',query:{id:it.authorId}}" class="rl">
                                {{it.authorName}}&nbsp·&nbsp
                            </router-link>
                        </span>
                        <br>
                    </a>
                    <p>{{abs}}</p>
                    <a :href="pdf">
                            <el-button type="primary" plain icon="el-icon-download">
                                PDF 
                            </el-button>
                    </a>
                    <el-row type="flex" align="left">
                        <p style="line-height:40px;"> 
                            <span v-for="(it,index) in methods" :key="index">
                                <router-link :to="{name:'Method',query:{methodName:it.methodName}}">
                                <el-tag type="warning">{{it.methodName}}</el-tag>
                                </router-link>&nbsp &nbsp
                            </span>
                        </p>
                    </el-row>
                    <br><br>
                    </el-row>
                </div>
                <br><br>
                <el-col span="12">
                    <h3>Code</h3>
                    <el-table
                    :data="codes"
                    style="width: 100%">
                        <el-table-column
                            prop="codeLink"
                            label="Link"
                            width="240">
                            <template slot-scope="scope">
                                <a :href="scope.row.codeLink" style="font:13px Small;color:gray">{{scope.row.codeLink}}</a>
                            </template>
                        </el-table-column>
                        <el-table-column
                            prop="stars"
                            label="Stars"
                            width="100">
                        </el-table-column>
                        <el-table-column
                            prop="framework"
                            label="Framework"
                            width="100"
                            >
                        </el-table-column>
                    </el-table>
                </el-col>

                <el-col span="12">
                    <h3>Benchmark</h3>
                    <el-row type="flex" align="middle">
                        <el-table
                        :data="benchmarks"
                        style="width: 100%"
                        :row-class-name="tableRowClassName"
                        @row-click="onRowClick">
                            <el-table-column
                                prop="taskName"
                                label="Task"
                                width="180">
                            </el-table-column>
                            <el-table-column
                                prop="datasetName"
                                label="Dataset"
                                width="120">
                            </el-table-column>
                            <el-table-column
                                prop="metric"
                                label="Metric"
                                align="right"
                                >
                            </el-table-column>
                        </el-table>
                    </el-row>
                </el-col>
            </el-col>
            <el-col span="4"/>
        </el-row>
        <br><br>
        <el-row>

        </el-row>
    </div>
</template>

<script>
import axios from "axios";

export default {
  name: 'PaperInfo',
  components: {
  },
  data() {
    return {
        title: '',
        date: '',
        authors: [],
        abs: '',
        pdf: '',
        codes: [],
        benchmarks: []
    };
  },
  mounted() {
    axios.get('/api/paperDetails?pid=' + this.$route.query.id).then((response) => {
        let d = response.data;
        this.title = d.title;
        this.date = d.publishDate;
        this.authors = d.authors;
        this.abs = d.abs;
        this.pdf = d.paperLink;
        this.codes = d.codes;
        this.methods = d.methods;
        this.benchmarks = d.benchmarks;
    });
  },
  methods: {
    tableRowClassName({row, rowIndex}) {
      //把每一行的索引放进row
      row.index = rowIndex;
    },
    onRowClick(row, event, column) {
      //点击获取索引
      const id = row.index;
      this.$router.push({
        name: "Bench", query: {
          id: this.benchmarks[id]["benchId"]
        }
      })
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.border {
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    border-radius: 4px;
}
.el-row {
    margin-left: 20px;
    margin-left: 20px;
}
.router-link-active {
  color: black;
  text-decoration: none;
}
.rl {
  color: black;
  text-decoration: none;
  font:13px Small;
}
.el-table >>> .el-table__body tr:hover>td {
  cursor: pointer;
}
</style>
