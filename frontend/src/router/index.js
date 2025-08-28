import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Teachers from '../views/Teachers.vue'
import Projects from '../views/Projects.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: { title: '首页' }
  },
  {
    path: '/teachers',
    name: 'Teachers',
    component: Teachers,
    meta: { title: '教师评教管理' }
  },
  {
    path: '/projects',
    name: 'Projects',
    component: Projects,
    meta: { title: '学生项目管理' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫 - 设置页面标题
router.beforeEach((to, from, next) => {
  if (to.meta.title) {
    document.title = `${to.meta.title} - 年终考核加分管理系统`
  }
  next()
})

export default router