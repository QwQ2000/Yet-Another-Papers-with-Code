<template>
  <a v-on:click="search">
    <div class="border">
      <br>
      <el-row>
        <el-col align="left">
          <div style="font:15px large;height: 20px">
            {{ datasetName }}
          </div>
        </el-col>
      </el-row>
      <br>
    </div>
  </a>
</template>

<script>
export default {
  name: 'DatasetsBox',
  data() {
    return {};
  },
  props: {
    datasetName: 'CoCo',
    datasetLink: '',
    datasetId: 0
  },
  methods: {
    search() {
      this.$router.push({
        path: "/dataset", query: {
          id: this.datasetId,
        }
      })
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
a {
  color: #000;
  cursor: pointer;
}

.border {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border-radius: 14px;
}

.el-row {
  margin-left: 10px;
}
</style>
