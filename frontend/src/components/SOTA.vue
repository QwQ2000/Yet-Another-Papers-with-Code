<template>
  <div>
    <h2>Browse State-of-the-Art</h2>
    {{ msg }}
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'SOTA',
  data() {
    return {
      msg: 'Hello World!',
    };
  },
  methods: {
    getMessage() {
      const path = '/api/sota';
      axios.get(path)
        .then((res) => {
          this.msg = res.data;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
      console.log(this.msg);
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
