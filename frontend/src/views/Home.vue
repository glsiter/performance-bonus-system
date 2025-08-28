<template>
  <div class="home">
    <!-- 欢迎标题 -->
    <el-card class="welcome-card">
      <template #header>
        <div class="card-header">
          <el-icon><trophy /></el-icon>
          <span>2022年度年终考核加分管理系统</span>
        </div>
      </template>
      
      <div class="welcome-content">
        <p>欢迎使用外国语学院年终考核加分管理系统</p>
        <p>本系统用于管理教师评教数据和学生项目指导情况</p>
      </div>

      <div class="quick-actions">
        <el-button type="primary" @click="$router.push('/teachers')">
          <el-icon><user /></el-icon>
          管理教师评教
        </el-button>
        <el-button type="success" @click="$router.push('/projects')">
          <el-icon><document /></el-icon>
          管理学生项目
        </el-button>
      </div>
    </el-card>

    <!-- 数据统计卡片 -->
    <div class="stats-row">
      <el-row :gutter="20">
        <el-col :span="8">
          <el-card class="stat-card">
            <div class="stat-item">
              <div class="stat-icon teacher">
                <el-icon><user /></el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-number">{{ teacherCount }}</div>
                <div class="stat-label">教师总数</div>
              </div>
            </div>
          </el-card>
        </el-col>

        <el-col :span="8">
          <el-card class="stat-card">
            <div class="stat-item">
              <div class="stat-icon project">
                <el-icon><document /></el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-number">{{ projectCount }}</div>
                <div class="stat-label">项目总数</div>
              </div>
            </div>
          </el-card>
        </el-col>

        <el-col :span="8">
          <el-card class="stat-card">
            <div class="stat-item">
              <div class="stat-icon bonus">
                <el-icon><trophy /></el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-number">{{ avgScore }}</div>
                <div class="stat-label">平均评教分</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 系统功能介绍 -->
    <el-row :gutter="20" class="features-row">
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <el-icon><user /></el-icon>
              <span>教师评教管理</span>
            </div>
          </template>
          
          <div class="feature-content">
            <ul>
              <li>查看107位教师的评教分数</li>
              <li>管理学校和学院排名</li>
              <li>编辑加分情况</li>
              <li>数据实时同步到云端</li>
            </ul>
          </div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <el-icon><document /></el-icon>
              <span>学生项目管理</span>
            </div>
          </template>
          
          <div class="feature-content">
            <ul>
              <li>管理学科竞赛项目</li>
              <li>管理大创项目</li>
              <li>记录项目指导老师</li>
              <li>跟踪项目进展情况</li>
            </ul>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Trophy, User, Document } from '@element-plus/icons-vue'
import { teacherApi, projectApi } from '../api/supabase'

// 响应式数据
const teacherCount = ref(0)
const projectCount = ref(0)
const avgScore = ref(0)

// 加载统计数据
const loadStats = async () => {
  try {
    // 获取教师统计
    const teachers = await teacherApi.getAll()
    teacherCount.value = teachers.length
    
    // 计算平均分
    const validScores = teachers.filter(t => t.semester1_score).map(t => parseFloat(t.semester1_score))
    if (validScores.length > 0) {
      avgScore.value = (validScores.reduce((sum, score) => sum + score, 0) / validScores.length).toFixed(1)
    }
    
    // 获取项目统计
    const projects = await projectApi.getAll()
    projectCount.value = projects.length
    
  } catch (error) {
    console.error('加载统计数据失败:', error)
    // 使用模拟数据
    teacherCount.value = 107
    projectCount.value = 9
    avgScore.value = '94.8'
  }
}

onMounted(() => {
  loadStats()
})
</script>

<style scoped>
.home {
  max-width: 1200px;
  margin: 0 auto;
}

.welcome-card {
  margin-bottom: 30px;
}

.card-header {
  display: flex;
  align-items: center;
  font-size: 18px;
  font-weight: bold;
}

.card-header .el-icon {
  margin-right: 10px;
  color: #409EFF;
}

.welcome-content {
  text-align: center;
  margin: 20px 0;
}

.welcome-content p {
  margin: 10px 0;
  font-size: 16px;
  color: #606266;
}

.quick-actions {
  text-align: center;
  margin-top: 30px;
}

.quick-actions .el-button {
  margin: 0 10px;
  padding: 15px 30px;
  font-size: 16px;
}

.stats-row {
  margin-bottom: 30px;
}

.stat-card {
  border: none;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.stat-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
}

.stat-icon.teacher {
  background-color: rgba(64, 158, 255, 0.1);
  color: #409EFF;
}

.stat-icon.project {
  background-color: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

.stat-icon.bonus {
  background-color: rgba(230, 162, 60, 0.1);
  color: #E6A23C;
}

.stat-icon .el-icon {
  font-size: 24px;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 32px;
  font-weight: bold;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 5px;
}

.features-row {
  margin-top: 20px;
}

.feature-content ul {
  margin: 0;
  padding-left: 20px;
}

.feature-content li {
  margin: 8px 0;
  color: #606266;
}
</style>