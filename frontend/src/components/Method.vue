<template>
  <div style="padding-left: 180px; padding-right: 180px">
    <el-row>
      <h1 align="left">{{ this.methodName }}</h1>
    </el-row>
    <br>
    <el-row>
      <p align="left">
        {{ this.methodDesc }}
      </p>
    </el-row>
    <br><br>
    <el-row>
      <h2 align="left">Papers</h2>
    </el-row>
    <el-row>
      <el-col span="4">
        <el-input v-model="input" placeholder="Search for a paper">
          <el-button style="padding-right:5px" slot="suffix" type="text" v-on:click="search">
            <i class="el-icon-search"/>
          </el-button>
        </el-input>
      </el-col>
    </el-row>
    <br><br>
    <el-table
      :data="tableData"
      style="width: 100%">
      <el-table-column
        prop="PaperTitle"
        label="Paper"
        width="650">
      </el-table-column>
      <el-table-column
        prop="codeLink"
        label="Code"
        width="100">
        <template slot-scope="scope">
          <a :href="scope.row.codeLink">
            <i class="fa fa-github" aria-hidden="true"></i>
          </a>
        </template>
      </el-table-column>
      <el-table-column
        prop="paperLink"
        label="Results"
        width="130">
        <template slot-scope="scope">
          <a :href="scope.row.paperLink">
            <i class="fa fa-file" aria-hidden="true"></i>
          </a>
        </template>
      </el-table-column>
      <el-table-column
        prop="publishDate"
        label="Date"
        width="250">
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Method",
  data() {
    return {
      tableData: [],
      methodName: 'cccc',
      methodDesc: '',
      input: ''
    };
  },
  methods: {
    getMessage() {
      if (typeof (this.$route.query.methodName) != "undefined")
        this.methodName = this.$route.query.methodName;
      axios.get('/api/methods?methodName=' + this.methodName).then((response) => {
        this.methodDesc = response.data[0]["methodDesc"];
        for (var i = 0; i < response.data.length; i++) {
          var e = response.data[i];
          this.tableData.push({
            PaperTitle: e["title"],
            paperLink: e["paperLink"],
            codeLink: e["codeLink"],
            publishDate: e["publishDate"]
          })
        }
      })
    },
    search() {
      axios.get('/api/methods?methodName=' + this.methodName + '&title=' + this.input).then((response) => {
        this.tableData = []
        for (var i = 0; i < response.data.length; i++) {
          var e = response.data[i];
          this.tableData.push({
            PaperTitle: e["title"],
            paperLink: e["paperLink"],
            codeLink: e["codeLink"],
            publishDate: e["publishDate"]
          })
        }
      })
    }
  },
  created() {
    this.getMessage();
  }
}
</script>

<style scoped>

</style>
