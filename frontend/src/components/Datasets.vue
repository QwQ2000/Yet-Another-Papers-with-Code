<template>
  <div id="Datasets">
    <br>
    <el-row class="row-nav">
      <h1>Datasets</h1>
    </el-row>
    <el-row type="flex" align="top">
      <el-col span="6"/>
      <el-col span="8">
        <el-input v-model="seaDataName" placeholder="Search for datasets">
          <el-button style="padding-right:5px" slot="suffix" type="text" v-on:click="search">
            <i class="el-icon-search"/>
          </el-button>
        </el-input>
        <br><br>
        <el-input v-model="seaTaskName" placeholder="Filter by Task">
          <el-button style="padding-right:5px" slot="suffix" type="text" v-on:click="search">
            <i class="el-icon-search"/>
          </el-button>
        </el-input>
      </el-col>
      <el-col span="1"/>
      <el-col>
        <el-row>
          <el-col span="3">
            <router-link
              :to="{path:'/datasets',query:{order:'createDate', seaDataName:this.seaDataName, seaTaskName: this.seaTaskName}}"
              exact
              class="rl">
              Latest
            </router-link>
          </el-col>

          <el-col span="1"/>

          <el-col span="3">
            <router-link
              :to="{path:'/datasets',query:{order:'paperCnt', seaDataName:this.seaDataName, seaTaskName: this.seaTaskName}}"
              exact
              class="rl">
              Greatest
            </router-link>
          </el-col>
        </el-row>
        <el-row v-for="(it,index) in data" :key="index">
          <a @click="gotoDataset(it.datasetId)">
            <p align="left" style="font-weight: bolder; color: #0692c7; font-size: 20px">{{ it.datasetName }}</p>
            <p align="left">{{ it.datasetDesc }}</p>
            <p align="left" style="font:13px Small;color: #969696;font-weight: bolder">{{ it.createDate }} · {{ it.paperCnt }} PAPERS</p>
            <el-divider></el-divider>
          </a>
        </el-row>
      </el-col>
      <el-col span="8"/>
    </el-row>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Datasets",
  data() {
    return {
      data: [],
      order: '',
      seaDataName: '',
      seaTaskName: '',
    };
  },
  methods: {
    getMessage() {
      var path = 'http://127.0.0.1:5000/dataset?order=' + this.$route.query.order
      if (this.$route.query.seaDataName)
        path += '&dataName=' + this.$route.query.seaDataName
      if (this.$route.query.seaTaskName)
        path += '&taskName=' + this.$route.query.seaTaskName
      this.order = this.$route.query.order
      this.seaDataName = this.$route.query.seaDataName
      this.seaTaskName = this.$route.query.seaTaskName
      axios.get(path)
        .then((response) => {
          this.data = response.data;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
    gotoDataset(datasetId) {
      this.$router.push({
        path: "/dataset", query: {
          id: datasetId,
        }
      })
    },
    search() {
      this.$router.push({
        path: "/datasets", query: {
          order: this.order,
          seaDataName: this.seaDataName,
          seaTaskName: this.seaTaskName,
        }
      })
    }
  },
  created() {
    this.getMessage();
  },
  watch: {
    '$route'(to, from) {
      this.getMessage()
    }
  },
};
</script>

<style scoped>
.rl {
  color: gray;
  text-decoration: none;
}

.router-link-active {
  color: black;
  text-decoration: none;
}

a {
  color: #000;
  cursor: pointer;
}

h1 {
  font-size: 50px;
  color: white;
  margin-top: 50px;
  font-weight: lighter;
}

.el-row {
  margin-bottom: 20px;


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
