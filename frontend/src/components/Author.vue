<template>
    <div id="author">
        <br><br>
        <el-row margin-top="15px" type="flex" align="middle">
        <el-col span="3"/>
        <el-col span="16">
            <div class="border">
                <br>
                <h2>{{name}}</h2>
                <a style="font:15px Small">
                    <i class="el-icon-school"/>&nbsp {{inst}}
                    <br>
                    <i class="el-icon-document"/> &nbsp {{paperCnt}} Papers with code
                    &nbsp &nbsp
                    <i class="el-icon-search"/>  &nbsp {{taskCnt}} Research fields
                </a>
                <br><br>
                <el-row>
                    <span v-for="(it,index) in taskList" :key="index">
                        <router-link :to="{name:'Tasks',query:{taskName:it.taskName}}">
                        <el-tag>{{it.taskName}}</el-tag>
                        </router-link>&nbsp &nbsp
                    </span>
                </el-row>
                <br><br>
            </div>
            <br><br>
            <el-table
            :data="tableData"
            style="width: 100%">
                <el-table-column
                    prop="title"
                    label="Title"
                    width="180">
                </el-table-column>
                <el-table-column
                    prop="publishDate"
                    label="Publish Date"
                    width="180">
                </el-table-column>
                <el-table-column
                    prop="ord"
                    label="Order"
                    >
                </el-table-column>
                <el-table-column
                label=""
                width="130">
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
import PaperBox from '@/components/PaperBox';
import axios from "axios";

export default {
  name: 'Author',
  components: {
      PaperBox,
  },
  data() {
    return {
        name: 'Vaswani',
        inst: 'NMSL',
        paperCnt: 0,
        taskCnt: 0,
        tableData:[{
          title:'NM$L1',
          publishDate:'114-5-14',
          ord:'1'
        },{
          title:'NM$L2',
          publishDate:'114-5-14',
          ord:'2'
        }],
        taskList:[{
            taskName:'??'
        },{
            taskName:'!!'
        }]
    };
  },
  mounted() {
    axios.get('/api/author?id=' + this.$route.query.id).then((response) => {
        let d = response.data;
        this.name = d.name;
        this.inst = d.inst;
        this.paperCnt = d.paperList.length;
        this.taskCnt = d.taskList.length;
        this.tableData = d.paperList;
        this.taskList = d.taskList;
    });
  },
  methods: {
      handleClick(row) {
          this.$router.push({name:'PaperInfo',query:{id:row.paperId}})
      }
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
