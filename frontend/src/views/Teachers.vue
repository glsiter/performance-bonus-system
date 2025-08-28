<template>
  <div class="teachers">
    <!-- 页面标题和操作 -->
    <div class="page-header">
      <div class="header-left">
        <h2>教师评教管理</h2>
        <p>2022年度外国语学院专职教师评教分数统计</p>
      </div>
      <div class="header-right">
        <el-button type="primary" @click="handleAdd">
          <el-icon><plus /></el-icon>
          添加教师
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
        <el-col :span="8">
          <el-input
            v-model="searchText"
            placeholder="搜索教师姓名"
            @input="handleSearch"
            clearable
          >
            <template #prefix>
              <el-icon><search /></el-icon>
            </template>
          </el-input>
        </el-col>
        <el-col :span="6">
          <el-select v-model="rankFilter" placeholder="筛选排名" @change="handleFilter" clearable>
            <el-option label="前10名" value="top10" />
            <el-option label="前20名" value="top20" />
            <el-option label="前50名" value="top50" />
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-select v-model="scoreFilter" placeholder="筛选分数" @change="handleFilter" clearable>
            <el-option label="95分" value="95" />
            <el-option label="90-94分" value="90-94" />
            <el-option label="90分以下" value="under90" />
          </el-select>
        </el-col>
      </el-row>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card">
      <el-table
        v-loading="loading"
        :data="filteredData"
        stripe
        border
        style="width: 100%"
        @sort-change="handleSort"
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        
        <el-table-column prop="teacher_name" label="教师姓名" width="150" align="center" />
        
        <el-table-column
          prop="semester1_score"
          label="21学年第2学期评教分数"
          width="180"
          align="center"
          sortable="custom"
        >
          <template #default="{ row }">
            <el-tag v-if="row.semester1_score >= 95" type="success">{{ row.semester1_score }}</el-tag>
            <el-tag v-else-if="row.semester1_score >= 90" type="warning">{{ row.semester1_score }}</el-tag>
            <el-tag v-else type="danger">{{ row.semester1_score }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column
          prop="semester2_score"
          label="22学年第1学期评教分数"
          width="180"
          align="center"
        >
          <template #default="{ row }">
            <span v-if="row.semester2_score">{{ row.semester2_score }}</span>
            <span v-else style="color: #909399;">-</span>
          </template>
        </el-table-column>

        <el-table-column
          prop="school_rank"
          label="学校排名"
          width="100"
          align="center"
          sortable="custom"
        >
          <template #default="{ row }">
            <el-tag v-if="row.school_rank <= 10" type="success" effect="dark">
              {{ row.school_rank }}
            </el-tag>
            <el-tag v-else-if="row.school_rank <= 50" type="warning">
              {{ row.school_rank }}
            </el-tag>
            <el-tag v-else>{{ row.school_rank }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column
          prop="college_rank"
          label="学院排名"
          width="100"
          align="center"
          sortable="custom"
        >
          <template #default="{ row }">
            <el-tag v-if="row.college_rank <= 5" type="success" effect="dark">
              {{ row.college_rank }}
            </el-tag>
            <el-tag v-else-if="row.college_rank <= 15" type="warning">
              {{ row.college_rank }}
            </el-tag>
            <el-tag v-else>{{ row.college_rank }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="bonus_points" label="加分" width="80" align="center">
          <template #default="{ row }">
            <el-tag type="success">{{ row.bonus_points }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">
              <el-icon><edit /></el-icon>
              编辑
            </el-button>
            <el-popconfirm
              title="确定删除这条记录吗？"
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
      :title="isEdit ? '编辑教师信息' : '添加教师信息'"
      width="600px"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="140px"
      >
        <el-form-item label="教师姓名" prop="teacher_name">
          <el-input v-model="formData.teacher_name" placeholder="请输入教师姓名" />
        </el-form-item>

        <el-form-item label="21学年第2学期评教分数" prop="semester1_score">
          <el-input-number
            v-model="formData.semester1_score"
            :min="0"
            :max="100"
            :step="0.1"
            :precision="1"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="22学年第1学期评教分数">
          <el-input-number
            v-model="formData.semester2_score"
            :min="0"
            :max="100"
            :step="0.1"
            :precision="1"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="学校排名" prop="school_rank">
          <el-input-number
            v-model="formData.school_rank"
            :min="1"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="学院排名" prop="college_rank">
          <el-input-number
            v-model="formData.college_rank"
            :min="1"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="加分" prop="bonus_points">
          <el-input-number
            v-model="formData.bonus_points"
            :min="0"
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
import { Plus, Refresh, Search, Edit, Delete } from '@element-plus/icons-vue'
import { teacherApi } from '../api/supabase'

// 响应式数据
const loading = ref(false)
const dialogVisible = ref(false)
const submitLoading = ref(false)
const isEdit = ref(false)
const searchText = ref('')
const rankFilter = ref('')
const scoreFilter = ref('')

// 表格数据
const tableData = ref([])
const currentRow = ref(null)

// 表单数据
const formRef = ref(null)
const formData = reactive({
  teacher_name: '',
  semester1_score: null,
  semester2_score: null,
  school_rank: null,
  college_rank: null,
  bonus_points: 30
})

// 表单验证规则
const formRules = {
  teacher_name: [
    { required: true, message: '请输入教师姓名', trigger: 'blur' }
  ],
  semester1_score: [
    { required: true, message: '请输入评教分数', trigger: 'blur' }
  ],
  school_rank: [
    { required: true, message: '请输入学校排名', trigger: 'blur' }
  ],
  college_rank: [
    { required: true, message: '请输入学院排名', trigger: 'blur' }
  ],
  bonus_points: [
    { required: true, message: '请输入加分', trigger: 'blur' }
  ]
}

// 计算属性 - 过滤后的数据
const filteredData = computed(() => {
  let data = [...tableData.value]

  // 搜索过滤
  if (searchText.value) {
    data = data.filter(item =>
      item.teacher_name.includes(searchText.value)
    )
  }

  // 排名过滤
  if (rankFilter.value) {
    switch (rankFilter.value) {
      case 'top10':
        data = data.filter(item => item.college_rank <= 10)
        break
      case 'top20':
        data = data.filter(item => item.college_rank <= 20)
        break
      case 'top50':
        data = data.filter(item => item.college_rank <= 50)
        break
    }
  }

  // 分数过滤
  if (scoreFilter.value) {
    switch (scoreFilter.value) {
      case '95':
        data = data.filter(item => item.semester1_score >= 95)
        break
      case '90-94':
        data = data.filter(item => item.semester1_score >= 90 && item.semester1_score < 95)
        break
      case 'under90':
        data = data.filter(item => item.semester1_score < 90)
        break
    }
  }

  return data
})

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const data = await teacherApi.getAll()
    tableData.value = data
    ElMessage.success(`成功加载 ${data.length} 条教师数据`)
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

// 排序处理
const handleSort = ({ prop, order }) => {
  if (!order) return
  
  tableData.value.sort((a, b) => {
    const aVal = a[prop] || 0
    const bVal = b[prop] || 0
    
    if (order === 'ascending') {
      return aVal - bVal
    } else {
      return bVal - aVal
    }
  })
}

// 重置表单
const resetForm = () => {
  formData.teacher_name = ''
  formData.semester1_score = null
  formData.semester2_score = null
  formData.school_rank = null
  formData.college_rank = null
  formData.bonus_points = 30
  
  if (formRef.value) {
    formRef.value.resetFields()
  }
}

// 添加教师
const handleAdd = () => {
  isEdit.value = false
  resetForm()
  dialogVisible.value = true
}

// 编辑教师
const handleEdit = (row) => {
  isEdit.value = true
  currentRow.value = row
  
  // 填充表单数据
  Object.keys(formData).forEach(key => {
    formData[key] = row[key]
  })
  
  dialogVisible.value = true
}

// 删除教师
const handleDelete = async (row) => {
  try {
    await teacherApi.delete(row.id)
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
    
    if (isEdit.value) {
      // 更新
      await teacherApi.update(currentRow.value.id, formData)
      ElMessage.success('更新成功')
    } else {
      // 添加
      await teacherApi.create(formData)
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
.teachers {
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
</style>