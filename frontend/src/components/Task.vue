<template>
  <div>
    <div style="padding-left: 180px; padding-right: 180px">
      <el-row>
        <h1 align="left">{{ this.taskName }}</h1>
      </el-row>
      <br>
      <el-row>
        <p align="left">
          {{ this.taskDesc }}
        </p>
      </el-row>
      <br><br>
      <el-row>
        <h2 align="left">Benchmarks</h2>
      </el-row>
      <br><br>
      <el-table
        :data="tableData"
        style="width: 100% " :row-class-name="tableRowClassName" @row-click="onRowClick">
        <el-table-column
          prop="Dataset"
          label="Dataset"
          width="200">
        </el-table-column>
        <el-table-column
          prop="PaperTitle"
          label="Paper Title"
          width="600">
        </el-table-column>
        <el-table-column
          prop="paperLink"
          label="Paper"
          width="180">
          <template slot-scope="scope">
            <a :href="scope.row.paperLink" @click.stop="deleteVisible = true">
              <i class="fa fa-file" aria-hidden="true" ></i>
            </a>
          </template>
        </el-table-column>
        <el-table-column
          prop="codeLink"
          label="Code"
          width="180">
          <template slot-scope="scope">
            <a :href="scope.row.codeLink" @click.stop="deleteVisible = true">
              <i class="fa fa-github" aria-hidden="true" style="font-size: 18px"></i>
            </a>
          </template>
        </el-table-column>
      </el-table>
      <el-row>
        <h2 align="left">Datasets</h2>
      </el-row>
      <el-row :gutter="40" type="flex" class="row-bg" justify="left">
        <el-col :span="3" v-for="(it,index) in datasets" :key="index">
          <DatasetsBox class="grid-content bg-purple"
                       v-bind:datasetName="it.datasetName"
                       v-bind:dataset-id="it.datasetId"
          />
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import DatasetsBox from "@/components/DatasetsBox";

export default {
  name: "Task",
  components: {
    DatasetsBox,
  },
  data() {
    return {
      tableData: [],
      benchmarks: [],
      taskName: 'aaaa',
      taskDesc: 'bbbbbb',
      datasets: []
    };
  },
  methods: {
    search() {
      this.taskName = '';
      if (typeof (this.$route.query.taskName) != "undefined")
        this.taskName = this.$route.query.taskName;
      axios.get('/api/task?taskName=' + this.taskName).then((response) => {
        this.benchmarks = response.data;
        this.taskDesc = this.benchmarks[0]["taskDesc"]
        for (var j = 0; j < this.benchmarks.length; j++) {
          var e = this.benchmarks[j]
          this.tableData.push({
            Dataset: e["datasetName"],
            PaperTitle: e["title"],
            paperLink: e["paperLink"],
            codeLink: e["codeLink"]
          })
          this.datasets.push({
            "datasetId": e["datasetId"],
            "datasetName": e["datasetName"]
          })
        }
      })
    },
    tableRowClassName({row, rowIndex}) {
      //把每一行的索引放进row
      row.index = rowIndex;
    },
    onRowClick(row, event, column) {
      //点击获取索引
      const id = row.index;
      console.log()
      this.$router.push({
        path: "/bench", query: {
          id: this.benchmarks[id]["benchId"]
        }
      })
    },
  },
  created() {
    this.search();
  },
};
</script>

<style scoped>

.el-table >>> .el-table__body tr:hover>td {
  cursor: pointer;
}
</style>
