<template>
  <div id="app">
    <el-container>
      <!-- 顶部导航栏 -->
      <el-header class="header">
        <div class="header-content">
          <div class="logo">
            <el-icon><trophy /></el-icon>
            <span>年终考核加分管理系统</span>
          </div>
          <el-menu
            mode="horizontal"
            :default-active="$route.path"
            class="nav-menu"
            router
          >
            <el-menu-item index="/">
              <el-icon><home /></el-icon>
              <span>首页</span>
            </el-menu-item>
            <el-menu-item index="/teachers">
              <el-icon><user /></el-icon>
              <span>教师评教</span>
            </el-menu-item>
            <el-menu-item index="/projects">
              <el-icon><document /></el-icon>
              <span>学生项目</span>
            </el-menu-item>
          </el-menu>
        </div>
      </el-header>

      <!-- 主体内容 -->
      <el-main class="main">
        <router-view />
      </el-main>

      <!-- 底部 -->
      <el-footer class="footer">
        <p>&copy; 2024 外国语学院 年终考核加分管理系统</p>
      </el-footer>
    </el-container>
  </div>
</template>

<script setup>
import { Trophy, Home, User, Document } from '@element-plus/icons-vue'
</script>

<style scoped>
.header {
  background-color: #545c64;
  color: white;
  padding: 0;
}

.header-content {
  display: flex;
  align-items: center;
  height: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.logo {
  display: flex;
  align-items: center;
  font-size: 20px;
  font-weight: bold;
  margin-right: 50px;
}

.logo .el-icon {
  margin-right: 10px;
  font-size: 24px;
}

.nav-menu {
  background-color: transparent;
  border: none;
  flex: 1;
}

.nav-menu .el-menu-item {
  color: white;
}

.nav-menu .el-menu-item:hover,
.nav-menu .el-menu-item.is-active {
  background-color: rgba(255, 255, 255, 0.1);
  color: #409EFF;
}

.main {
  min-height: calc(100vh - 120px);
  padding: 20px;
  background-color: #f5f7fa;
}

.footer {
  background-color: #303133;
  color: white;
  text-align: center;
  line-height: 40px;
  padding: 0;
}

.footer p {
  margin: 0;
}

#app {
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
}
</style>