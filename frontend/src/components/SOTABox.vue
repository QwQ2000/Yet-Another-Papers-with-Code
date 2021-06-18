<template>
  <a v-on:click="search">
    <div class="border">
      <br>
      <el-row>
        <el-col align="left">
          <div style="font:15px large;height: 40px">
            {{ taskName }}
          </div>
          <br>
          <a style="font:13px Small;color: #969696">
            <i class="el-icon-data-line"/>&nbsp {{ benchCnt }}&nbsp benchmarks<br>
            <i class="el-icon-reading"/>&nbsp {{ paperCnt }}&nbsp papers with code
          </a>
        </el-col>
      </el-row>
      <br>
    </div>
  </a>
</template>

<script>
export default {
  name: 'SOTABox',
  data() {
    return {};
  },
  props: {
    taskName: 'Attention is All You Need',
    taskDesc: 'aaaaa.',
    paperCnt: '0',
    benchCnt: '0'
  },
  methods: {
    search() {
      this.$router.push({
        path: "/tasks", query: {
          taskName: this.taskName,
        }
      })
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
