<template>
  <el-row margin-top="15px" type="flex" align="middle">
    <el-col :span="3">
      <router-link to="/">
        <font color="#000000" size="4" font-family="Helvetica"><b>Papers with Code</b></font>
      </router-link>
    </el-col>

    <el-col :span="3">
      <el-input v-model="input" placeholder="搜索">
        <el-button style="padding-right:5px" slot="suffix" type="text" v-on:click="search">
          <i class="el-icon-search"/>
        </el-button>
      </el-input>
    </el-col>

    <el-col :span="3">
      <router-link to="/sota">
        <font color="#000000" size="3">Browse State-of-the-Art</font>
      </router-link>
    </el-col>

    <el-col :span="3">
      <router-link to="/datasets">
      <font color="#000000" size="3">Datasets</font>
      </router-link>
    </el-col>

    <el-col :span="2">
      <router-link to="/methods">
        <font color="#000000" size="3">Methods</font>
      </router-link>
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
      this.$router.push({
        path: "/", query: {
          title: this.input,
        }
      })
    },
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
a {
  text-decoration: none;
}

.router-link-active {
  text-decoration: none;
}
</style>
