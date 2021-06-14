import Vue from 'vue';
import Router from 'vue-router';
import Paper from '@/components/Paper';
import SOTA from '@/components/SOTA';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Paper',
      component: Paper,
    },
    {
      path: '/sota',
      name: 'SOTA',
      component: SOTA,
    },
  ],
  mode: 'history',
});
