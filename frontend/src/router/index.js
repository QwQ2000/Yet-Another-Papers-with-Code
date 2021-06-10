import Vue from 'vue';
import Router from 'vue-router';
import Paper from '@/components/Paper';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Paper',
      component: Paper,
    },
  ],
});
