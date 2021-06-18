<template>
    <div id="paperbox" class="border">
        <br>
        <el-row>
            <el-col span="18" align="left">
                <a style="font:18px large">
                    {{title}}
                </a>
                <br>
                <a style="font:13px Small">
                    <i class="el-icon-user"/>&nbsp {{author}} &nbsp &nbsp &nbsp
                    <i class="el-icon-time"/>&nbsp {{date}}
                </a>
                <p style="font:13px Small">
                    {{abs}}
                </p>
            </el-col>
            <el-col span="6" align="center">
                <el-row>
                    <i class="el-icon-star-off"/> {{star}}
                </el-row>
                <br>
                <el-row>
                    <el-button type="primary" plain icon="el-icon-document" @click="onClick">Info</el-button>
                </el-row>
                <br>
                <el-row>
                    <a :href="pdf">
                        <el-button type="primary" plain icon="el-icon-download">
                            PDF 
                        </el-button>
                    </a>
                </el-row>
            </el-col>
        </el-row>
        <br>
    </div>
</template>

<script>
export default {
  name: 'PaperBox',
  data() {
    return {
    };
  },
  props: {
    title: 'Attention is All You Need',
    author: 'NMSL et al.',
    date: '11 Jun 2021',
    abs: 'This adversarial loss guarantees ',
    link:'',
    pdf:'',
    star:233
  },
  methods: {
      onClick() {
          this.$router.push({name:'PaperInfo',query:{id:this.link}})
      }
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.border {
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    border-radius: 4px
}
.el-row {
    margin-left: 40px;
}
</style>
