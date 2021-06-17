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
      <el-row :gutter="40" type="flex" class="row-bg" justify="left">
        <el-col :span="4" v-for="(it,index) in data" :key="index">
          <SOTABox class="grid-content bg-purple"
                   v-bind:taskName="it.methodName"
                   v-bind:taskDesc="it.methodDesc"
                   v-bind:paperCnt="it.methodCnt"
                   v-bind:benchCnt="it.methodCnt"
          />
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import SOTABox from "@/components/SOTABox";

export default {
  name: 'SOTA',
  components: {
    SOTABox,
  },
  data() {
    return {
      data: []
    };
  },
  methods: {
    getMessage() {
      const path = '/api/sota';
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
h1{
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
  background: linear-gradient(90deg, rgb(59, 191, 180) 0%, rgb(26,87,180) 100%) !important;
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
  height: 100%;
}

.row-bg {
  padding: 10px 0;
  height: 170px;
  background-color: #ffffff;
}
</style>
