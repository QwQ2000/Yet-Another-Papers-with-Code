<template>
  <div>
    <br/>
    <el-row class="row-nav">
      <h1>Browse State-of-the-Art</h1>
    </el-row>
    <div style="padding-left: 180px; padding-right: 180px">
      <el-row>
        <h2 align="left">Computer Vision</h2>
      </el-row>
      <el-row :gutter="40" type="flex" class="row-bg" justify="left">
        <el-col :span="4" v-for="(it,index) in data" :key="index">
          <SOTABox class="grid-content bg-purple"
                   v-bind:taskName="it.taskName"
                   v-bind:taskDesc="it.taskDesc"
                   v-bind:paperCnt="it.paperCnt"
                   v-bind:benchCnt="it.benchCnt"
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

</style>
