<template>
  <div>
    <h2>Tasks</h2>
    {{ msg }}
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Task",
  data() {
    return {
      msg: 'Hello World!',
    };
  },
  methods: {
    getMessage() {
      const path = '/api/task';
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