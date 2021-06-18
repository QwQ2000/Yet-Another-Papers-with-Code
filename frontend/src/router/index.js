import Vue from 'vue'
import Router from 'vue-router'
import Paper from '@/components/Paper'
import SOTA from '@/components/SOTA'
import Method from '@/components/Method'
import Task from '@/components/Task'
import Datasets from '@/components/Datasets'
import Author from '@/components/Author'
import Bench from '@/components/Bench'
import Dataset from '@/components/Dataset'
import Methods from "@/components/Methods";
import PaperInfo from "@/components/PaperInfo";

Vue.use(Router)

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
    {
      path: '/methods',
      name: 'Methods',
      component: Methods,
    },
    {
      path: '/method',
      name: 'Method',
      component: Method,
    },
    {
      path: '/tasks',
      name: 'Tasks',
      component: Task,
    },
    {
      path: '/datasets',
      name: 'Datasets',
      component: Datasets,
    },
    {
      path: '/author',
      name: 'Author',
      component: Author,
    },
    {
      path: '/bench',
      name: 'Bench',
      component: Bench,
    },
    {
      path: '/dataset',
      name: 'Dataset',
      component: Dataset,
    },
    {
      path: '/paper_info',
      name: 'PaperInfo',
      component: PaperInfo,
    },
  ],
  mode: 'history',
})
