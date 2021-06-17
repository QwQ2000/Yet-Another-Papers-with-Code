<template>
  <div>
    <br/>
    <el-row class="row-nav">
      <h1>Methods</h1>
    </el-row>
    <div style="padding-left: 180px; padding-right: 180px">
      <el-row>
        <h2 align="left">Computer Vision</h2>
      </el-row>
      <el-row :gutter="25" type="flex" class="row-bg" justify="left">
        <el-col :span="5" v-for="(it,index) in data" :key="index" style="height: 150px;">
          <MethodBox class="grid-content bg-purple"
                     v-bind:methodName="it.methodName"
                     v-bind:methodDesc="it.methodDesc"
                     v-bind:paperCnt="it.paperCnt"
          />
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import MethodBox from "@/components/MethodBox";

export default {
  name: 'Method',
  components: {
    MethodBox,
  },
  data() {
    return {
      data: []
    };
  },
  methods: {
    getMessage() {
      const path = '/api/methods';
      axios.get(path)
        .then((response) => {
          this.data = response.data;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
  },
  created() {
    this.getMessage();
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  font-size: 50px;
  color: white;
  margin-top: 50px;
}

.el-row {
  margin-bottom: 20px;

&
:last-child {
  margin-bottom: 0;
}

}
.el-col {
  border-radius: 4px;
  margin-left: 0px;
}

.bg-purple-dark {
  background: #ffffff;
}

.row-nav {
  background: linear-gradient(90deg, rgb(219, 8, 8) 0%, rgb(224, 142, 26) 100%) !important;
  height: 150px;
}

.bg-purple {
  background: #ffffff;
}

.bg-purple-light {
  background: #ffffff;
}

.grid-content {
  border-radius: 20px;
  flex: 1;
  height: 100%;
}

.row-bg {
  padding: 10px 0;
  height: 170px;
  background-color: #ffffff;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: flex-start;
}
</style>
