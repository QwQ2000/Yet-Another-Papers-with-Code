<template>
  <el-row margin-top="15px" type="flex" align="middle">
      <el-col :span="3">
        <font color="#000000" size="4" font-family="Helvetica"><b>Papers with Code</b></font>
      </el-col>

      <el-col :span="3">
        <el-input v-model="input" placeholder="搜索">
          <el-button style="padding-right:5px" slot="suffix" type="text">
            <i class="el-icon-search"/>
          </el-button>
        </el-input>
      </el-col>

      <el-col :span="3">
        <font color="#000000" size="3">Browse State-of-the-Art</font>
      </el-col>

      <el-col :span="3">
        <font color="#000000" size="3">Datasets</font>
      </el-col>

      <el-col :span="2">
        <font color="#000000" size="3">Methods</font>
      </el-col>
  </el-row>
</template>

<script>
export default {
  name: 'Header',
  data() {
    return {
      input: '',
    };
  },
  methods: {
    search() {
      console.log('NMSL');
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
