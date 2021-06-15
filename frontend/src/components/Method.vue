<template>
  <div>
    <h2>Methods</h2>
    {{ msg }}
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: "Method",
  data(){
    return{
      msg: 'Hello World!',
    };
  },
  methods: {
    getMessage() {
      const path = '/api/method';
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

</style>