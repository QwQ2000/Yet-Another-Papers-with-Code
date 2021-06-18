<template>
  <div>
    <br/>
    <el-row class="row-nav">
      <h1>Datasets</h1>
    </el-row>
    <el-row>
      <el-col>

      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Datasets",
  data() {
    return {
      msg: 'Hello World!',
    };
  },
  methods: {
    getMessage() {
      const path = '/api/dataset';
      axios.get(path)
        .then((res) => {
          this.msg = res.data;
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

<style scoped>
h1 {
  font-size: 50px;
  color: white;
  margin-top: 50px;
  font-weight: 10;
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
  background: linear-gradient(90deg, rgb(26, 87, 180) 0%, rgb(59, 191, 180) 100%) !important;
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
