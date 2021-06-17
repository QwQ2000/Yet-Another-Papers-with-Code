<template>
 <div id="paper">
    <br><br>
    <el-row margin-top="40px" type="flex" align="middle">
      <el-col span="1"/>

      <el-col span="4">
        <h2>Trending Research</h2>
      </el-col>

      <el-col span="11"/>

      <el-col span="1">
        <router-link :to="{name:'Paper',query:{order:'date',title:title}}" exact class="rl">
          Latest
        </router-link>
      </el-col>

      <el-col span="1"/>

      <el-col span="1">
        <router-link :to="{name:'Paper',query:{order:'star',title:title}}" exact class="rl">
          Greatest
        </router-link>
      </el-col>
    </el-row>
    <br>
    <el-row margin-top="15px" type="flex" align="middle">
      <el-col span="3"/>
      <el-col span="16">
        <span v-for="(it,index) in data" :key="index">
          <PaperBox v-bind:title="it.title" 
                    v-bind:author="it.author + ' et al.'" 
                    v-bind:date="it.publishDate" 
                    v-bind:abs="it.abs" 
                    v-bind:pdf="it.paperLink" 
                    v-bind:star="it.star" 
                    v-bind:link="it.id"
          />
          <br>
        </span>
      </el-col>
      <el-col span="4"/>
    </el-row>
  </div>
</template>

<script>
import PaperBox from '@/components/PaperBox';
import axios from "axios";

export default {
  name: 'Paper',
  components: {
    PaperBox,
  },
  data() {
    return {
      data: [],
      order: 'date',
      title: ''
    };
  },
  methods: {
    search () {
      this.order = 'date';
      this.title = '';
      if (typeof(this.$route.query.order) != "undefined") 
        this.order = this.$route.query.order;
      if (typeof(this.$route.query.title) != "undefined") 
        this.title = this.$route.query.title;
      axios.get('/api/paper?order=' + this.order + '&title=' + this.title).then((response) => {
        this.data = response.data;
      })
    },
  },
  mounted() {
    this.search();
  },
  watch: {
    '$route'(to,from) {
      this.search()
    }
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.rl {
  color: gray;
  text-decoration: none;
}
.router-link-active {
  color: black;
  text-decoration: none;
}
</style>
