<template>
    <div id="bench">
        <br><br>
        <el-row margin-top="15px" type="flex" align="middle">
        <el-col span="3"/>
        <el-col span="16">
            <h1>{{d.taskName}} on {{d.datasetName}}</h1>
            <h3>
                <br>
                <i class="el-icon-medal"/> Leaderborad of {{d.metric}}
                <br>
            </h3>
            <el-table
            :data="tableData"
            style="width: 100%">
                <el-table-column
                    prop="modelDesc"
                    label="Model"
                    width="180">
                </el-table-column>
                <el-table-column
                    prop="score"
                    label="Score"
                    width="180">
                </el-table-column>
                <el-table-column
                    prop="title"
                    label="Paper"
                    width="240">
                </el-table-column>
                <el-table-column
                    prop="publishDate"
                    label="Date"
                    width="180">
                </el-table-column>
                <el-table-column
                align="right">
                <template slot-scope="scope">
                    <el-button @click="handleClick(scope.row)" type="primary" plain icon="el-icon-document">Paper</el-button>
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
  name: 'Bench',
  components: {
  },
  data() {
    return {
        d: {},
        tableData:[]
    };
  },
  mounted() {
    axios.get('/api/bench?id=' + this.$route.query.id).then((response) => {
        this.d = response.data;
        axios.get('/api/bench_board?id=' + this.$route.query.id).then((response2) => {
            this.tableData = response2.data;
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
