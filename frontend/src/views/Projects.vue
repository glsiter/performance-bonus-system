<template>
  <div class="projects">
    <!-- 页面标题和操作 -->
    <div class="page-header">
      <div class="header-left">
        <h2>学生项目管理</h2>
        <p>2022年度指导学生项目 - 学科竞赛/大创</p>
      </div>
      <div class="header-right">
        <el-button type="primary" @click="handleAdd">
          <el-icon><plus /></el-icon>
          添加项目
        </el-button>
        <el-button @click="loadData">
          <el-icon><refresh /></el-icon>
          刷新数据
        </el-button>
      </div>
    </div>

    <!-- 搜索和筛选 -->
    <el-card class="search-card">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-input
            v-model="searchText"
            placeholder="搜索项目名或指导老师"
            @input="handleSearch"
            clearable
          >
            <template #prefix>
              <el-icon><search /></el-icon>
            </template>
          </el-input>
        </el-col>
        <el-col :span="6">
          <el-select v-model="typeFilter" placeholder="项目类型" @change="handleFilter" clearable>
            <el-option label="学科竞赛" value="学科竞赛" />
            <el-option label="大创" value="大创" />
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-select v-model="statusFilter" placeholder="项目状态" @change="handleFilter" clearable>
            <el-option label="进行中" value="ongoing" />
            <el-option label="已结项" value="completed" />
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-button type="success" @click="handleExport">
            <el-icon><download /></el-icon>
            导出数据
          </el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 项目统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon competition">
              <el-icon><trophy /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-number">{{ competitionCount }}</div>
              <div class="stat-label">学科竞赛项目</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon innovation">
              <el-icon><lightbulb /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-number">{{ innovationCount }}</div>
              <div class="stat-label">大创项目</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-item">
            <div class="stat-icon total">
              <el-icon><data-analysis /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-number">{{ totalCount }}</div>
              <div class="stat-label">项目总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 数据表格 -->
    <el-card class="table-card">
      <el-table
        v-loading="loading"
        :data="filteredData"
        stripe
        border
        style="width: 100%"
        :row-class-name="getRowClassName"
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        
        <el-table-column prop="project_type" label="项目类型" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.project_type === '学科竞赛'" type="success">
              {{ row.project_type }}
            </el-tag>
            <el-tag v-else type="primary">{{ row.project_type }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column
          prop="project_name"
          label="项目名"
          min-width="200"
          show-overflow-tooltip
        >
          <template #default="{ row }">
            <span v-if="row.project_name" class="project-name">{{ row.project_name }}</span>
            <span v-else class="empty-text">-</span>
          </template>
        </el-table-column>

        <el-table-column prop="project_leader" label="项目负责人" width="120" align="center">
          <template #default="{ row }">
            <span v-if="row.project_leader" class="leader-name">{{ row.project_leader }}</span>
            <span v-else class="empty-text">-</span>
          </template>
        </el-table-column>

        <el-table-column prop="supervisor" label="项目指导老师" width="120" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.supervisor" type="warning" effect="plain">
              {{ row.supervisor }}
            </el-tag>
            <span v-else class="empty-text">-</span>
          </template>
        </el-table-column>

        <el-table-column prop="start_date" label="立项时间" width="120" align="center">
          <template #default="{ row }">
            <span v-if="row.start_date">{{ formatDate(row.start_date) }}</span>
            <span v-else class="empty-text">-</span>
          </template>
        </el-table-column>

        <el-table-column prop="end_date" label="结项时间" width="120" align="center">
          <template #default="{ row }">
            <span v-if="row.end_date" class="end-date">{{ formatDate(row.end_date) }}</span>
            <el-tag v-else type="info" size="small">进行中</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="项目状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.end_date" type="success" size="small">已结项</el-tag>
            <el-tag v-else type="warning" size="small">进行中</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">
              <el-icon><edit /></el-icon>
              编辑
            </el-button>
            <el-popconfirm
              title="确定删除这个项目吗？"
              @confirm="handleDelete(row)"
            >
              <template #reference>
                <el-button size="small" type="danger">
                  <el-icon><delete /></el-icon>
                  删除
                </el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑项目信息' : '添加项目信息'"
      width="700px"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="项目类型" prop="project_type">
          <el-select v-model="formData.project_type" placeholder="选择项目类型" style="width: 100%">
            <el-option label="学科竞赛" value="学科竞赛" />
            <el-option label="大创" value="大创" />
          </el-select>
        </el-form-item>

        <el-form-item label="项目名称" prop="project_name">
          <el-input
            v-model="formData.project_name"
            placeholder="请输入项目名称"
            type="textarea"
            :rows="2"
          />
        </el-form-item>

        <el-form-item label="项目负责人">
          <el-input v-model="formData.project_leader" placeholder="请输入项目负责人姓名" />
        </el-form-item>

        <el-form-item label="指导老师" prop="supervisor">
          <el-input v-model="formData.supervisor" placeholder="请输入指导老师姓名" />
        </el-form-item>

        <el-form-item label="立项时间">
          <el-date-picker
            v-model="formData.start_date"
            type="date"
            placeholder="选择立项时间"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="结项时间">
          <el-date-picker
            v-model="formData.end_date"
            type="date"
            placeholder="选择结项时间（可为空）"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">
          {{ isEdit ? '更新' : '添加' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus, Refresh, Search, Edit, Delete, Download,
  Trophy, Lightbulb, DataAnalysis
} from '@element-plus/icons-vue'
import { projectApi } from '../api/supabase'

// 响应式数据
const loading = ref(false)
const dialogVisible = ref(false)
const submitLoading = ref(false)
const isEdit = ref(false)
const searchText = ref('')
const typeFilter = ref('')
const statusFilter = ref('')

// 表格数据
const tableData = ref([])
const currentRow = ref(null)

// 表单数据
const formRef = ref(null)
const formData = reactive({
  project_type: '',
  project_name: '',
  project_leader: '',
  supervisor: '',
  start_date: null,
  end_date: null
})

// 表单验证规则
const formRules = {
  project_type: [
    { required: true, message: '请选择项目类型', trigger: 'change' }
  ],
  project_name: [
    { required: true, message: '请输入项目名称', trigger: 'blur' }
  ],
  supervisor: [
    { required: true, message: '请输入指导老师', trigger: 'blur' }
  ]
}

// 计算属性 - 统计数据
const competitionCount = computed(() => {
  return tableData.value.filter(item => item.project_type === '学科竞赛').length
})

const innovationCount = computed(() => {
  return tableData.value.filter(item => item.project_type === '大创').length
})

const totalCount = computed(() => {
  return tableData.value.length
})

// 计算属性 - 过滤后的数据
const filteredData = computed(() => {
  let data = [...tableData.value]

  // 搜索过滤
  if (searchText.value) {
    const search = searchText.value.toLowerCase()
    data = data.filter(item =>
      (item.project_name && item.project_name.toLowerCase().includes(search)) ||
      (item.supervisor && item.supervisor.toLowerCase().includes(search)) ||
      (item.project_leader && item.project_leader.toLowerCase().includes(search))
    )
  }

  // 类型过滤
  if (typeFilter.value) {
    data = data.filter(item => item.project_type === typeFilter.value)
  }

  // 状态过滤
  if (statusFilter.value) {
    if (statusFilter.value === 'ongoing') {
      data = data.filter(item => !item.end_date)
    } else if (statusFilter.value === 'completed') {
      data = data.filter(item => item.end_date)
    }
  }

  return data
})

// 格式化日期
const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('zh-CN')
}

// 获取行样式类名
const getRowClassName = ({ row }) => {
  if (row.end_date) {
    return 'completed-row'
  }
  return 'ongoing-row'
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const data = await projectApi.getAll()
    tableData.value = data
    ElMessage.success(`成功加载 ${data.length} 个项目`)
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败，请检查网络连接')
  } finally {
    loading.value = false
  }
}

// 搜索处理
const handleSearch = () => {
  // 实时搜索通过计算属性实现
}

// 筛选处理
const handleFilter = () => {
  // 筛选通过计算属性实现
}

// 导出数据
const handleExport = () => {
  const csvContent = generateCSV(filteredData.value)
  downloadCSV(csvContent, '学生项目数据.csv')
  ElMessage.success('数据导出成功')
}

// 生成CSV内容
const generateCSV = (data) => {
  const headers = ['项目类型', '项目名称', '项目负责人', '指导老师', '立项时间', '结项时间', '状态']
  const rows = data.map(item => [
    item.project_type || '',
    item.project_name || '',
    item.project_leader || '',
    item.supervisor || '',
    formatDate(item.start_date),
    formatDate(item.end_date),
    item.end_date ? '已结项' : '进行中'
  ])
  
  return [headers, ...rows]
    .map(row => row.map(cell => `"${cell}"`).join(','))
    .join('\n')
}

// 下载CSV文件
const downloadCSV = (content, filename) => {
  const blob = new Blob(['\ufeff' + content], { type: 'text/csv;charset=utf-8' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)
}

// 重置表单
const resetForm = () => {
  formData.project_type = ''
  formData.project_name = ''
  formData.project_leader = ''
  formData.supervisor = ''
  formData.start_date = null
  formData.end_date = null
  
  if (formRef.value) {
    formRef.value.resetFields()
  }
}

// 添加项目
const handleAdd = () => {
  isEdit.value = false
  resetForm()
  dialogVisible.value = true
}

// 编辑项目
const handleEdit = (row) => {
  isEdit.value = true
  currentRow.value = row
  
  // 填充表单数据
  Object.keys(formData).forEach(key => {
    if (key === 'start_date' || key === 'end_date') {
      formData[key] = row[key] ? new Date(row[key]) : null
    } else {
      formData[key] = row[key]
    }
  })
  
  dialogVisible.value = true
}

// 删除项目
const handleDelete = async (row) => {
  try {
    await projectApi.delete(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    console.error('删除失败:', error)
    ElMessage.error('删除失败')
  }
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    submitLoading.value = true
    
    // 处理日期格式
    const submitData = { ...formData }
    if (submitData.start_date) {
      submitData.start_date = submitData.start_date.toISOString().split('T')[0]
    }
    if (submitData.end_date) {
      submitData.end_date = submitData.end_date.toISOString().split('T')[0]
    }
    
    if (isEdit.value) {
      // 更新
      await projectApi.update(currentRow.value.id, submitData)
      ElMessage.success('更新成功')
    } else {
      // 添加
      await projectApi.create(submitData)
      ElMessage.success('添加成功')
    }
    
    dialogVisible.value = false
    loadData()
  } catch (error) {
    if (error.errors) {
      // 表单验证错误
      return
    }
    
    console.error('提交失败:', error)
    ElMessage.error('操作失败，请重试')
  } finally {
    submitLoading.value = false
  }
}

// 组件挂载时加载数据
onMounted(() => {
  loadData()
})
</script>

<style scoped>
.projects {
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 20px;
}

.header-left h2 {
  margin: 0;
  color: #303133;
}

.header-left p {
  margin: 5px 0 0 0;
  color: #606266;
  font-size: 14px;
}

.search-card {
  margin-bottom: 20px;
}

.stats-row {
  margin-bottom: 20px;
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
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
}

.stat-icon.competition {
  background-color: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

.stat-icon.innovation {
  background-color: rgba(64, 158, 255, 0.1);
  color: #409EFF;
}

.stat-icon.total {
  background-color: rgba(230, 162, 60, 0.1);
  color: #E6A23C;
}

.stat-icon .el-icon {
  font-size: 20px;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 28px;
  font-weight: bold;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 5px;
}

.table-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.el-table {
  font-size: 14px;
}

.el-table th {
  background-color: #fafafa;
  font-weight: bold;
}

.project-name {
  font-weight: 500;
  color: #303133;
}

.leader-name {
  color: #606266;
}

.end-date {
  color: #67C23A;
  font-weight: 500;
}

.empty-text {
  color: #C0C4CC;
  font-style: italic;
}

/* 行样式 */
:deep(.ongoing-row) {
  background-color: rgba(64, 158, 255, 0.02);
}

:deep(.completed-row) {
  background-color: rgba(103, 194, 58, 0.02);
}
</style>