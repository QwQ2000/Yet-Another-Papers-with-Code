<template>
    <div id="dataset">
        <br><br>
        <el-row margin-top="15px" type="flex" align="middle">
        <el-col span="3"/>
        <el-col span="16">
            <div class="border">
                <br>
                <el-row type="flex" align="left">
                    <span v-for="(it,index) in taskList" :key="index">
                        <el-tag type="warning">{{it.taskName}}</el-tag> &nbsp
                    </span>
                </el-row>
                <h1>{{d.name}}</h1>
                <a style="font:15px Small;color: gray">Created in {{d.createDate}}</a>
                <p>
                    {{d.desc}}
                </p>
                <a :href="d.link">
                    <el-button type="primary" plain icon="el-icon-download">
                        Download
                    </el-button>
                </a>
                <br><br>
            </div>
            <br><br>
            <h3>Benchmarks</h3>
            <el-table
            :data="tableData"
            style="width: 100%">
                <el-table-column
                    prop="taskName"
                    label="Task"
                    width="180">
                </el-table-column>
                <el-table-column
                    prop="datasetName"
                    label="Dataset"
                    width="180">
                </el-table-column>
                <el-table-column
                    prop="modelDesc"
                    label="Best Model"
                    width="240">
                </el-table-column>
                <el-table-column
                align="right">
                <template slot-scope="scope">
                    <el-button @click="handleClick(scope.row)" type="primary" plain icon="el-icon-document">Paper</el-button>
                </template>
                </el-table-column>
            </el-table>
            <br><br>
            <h3>Papers</h3>
            <el-table
            :data="tableData2"
            style="width: 100%">
                <el-table-column
                    prop="title"
                    label="Title"
                    width="650">
                </el-table-column>
                <el-table-column
                    prop="publishDate"
                    label="Date"
                    width="180">
                </el-table-column>
                <el-table-column
                align="right">
                <template slot-scope="scope">
                    <el-button @click="handleClick(scope.row)" type="primary" plain icon="el-icon-document">View</el-button>
                </template>
                </el-table-column>
            </el-table>
        </el-col>
        <el-col span="4"/>
        </el-row>
    </div>
</template>

<script>
import axios from "axios";

export default {
  name: 'Dataset',
  components: {
  },
  data() {
    return {
        d: {},
        tableData:[],
        tableData2:[],
        taskList:[]
    };
  },
  mounted() {
    axios.get('/api/ds_info?id=' + this.$route.query.id).then((response) => {
        this.d = response.data;
        axios.get('/api/ds_bench?id=' + this.$route.query.id).then((response2) => {
            this.tableData = response2.data;
            axios.get('/api/ds_paper?id=' + this.$route.query.id + '&title=').then((response3) => {
                this.tableData2 = response3.data;
                axios.get('/api/ds_task?id=' + this.$route.query.id).then((response4) => {
                    this.taskList = response4.data;
                });
            });
        });
    });
  },
  methods: {
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.border {
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    border-radius: 4px
}
.el-row {
    margin-left: 40px;
}
</style>
