import { createClient } from '@supabase/supabase-js'

// Supabase配置
const supabaseUrl = 'https://vzfctheujcssdazwqliu.supabase.co'
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'your-supabase-anon-key'

// 创建Supabase客户端
export const supabase = createClient(supabaseUrl, supabaseKey)

// 教师评教数据API
export const teacherApi = {
  // 获取所有教师数据
  async getAll() {
    const { data, error } = await supabase
      .from('teacher_performance')
      .select('*')
      .order('college_rank', { ascending: true })
    
    if (error) {
      console.error('获取教师数据失败:', error)
      throw error
    }
    return data
  },

  // 添加教师数据
  async create(teacher) {
    const { data, error } = await supabase
      .from('teacher_performance')
      .insert([teacher])
      .select()
    
    if (error) {
      console.error('添加教师数据失败:', error)
      throw error
    }
    return data
  },

  // 更新教师数据
  async update(id, teacher) {
    const { data, error } = await supabase
      .from('teacher_performance')
      .update(teacher)
      .eq('id', id)
      .select()
    
    if (error) {
      console.error('更新教师数据失败:', error)
      throw error
    }
    return data
  },

  // 删除教师数据
  async delete(id) {
    const { error } = await supabase
      .from('teacher_performance')
      .delete()
      .eq('id', id)
    
    if (error) {
      console.error('删除教师数据失败:', error)
      throw error
    }
    return true
  }
}

// 学生项目数据API
export const projectApi = {
  // 获取所有项目数据
  async getAll() {
    const { data, error } = await supabase
      .from('student_projects')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (error) {
      console.error('获取项目数据失败:', error)
      throw error
    }
    return data
  },

  // 添加项目数据
  async create(project) {
    const { data, error } = await supabase
      .from('student_projects')
      .insert([project])
      .select()
    
    if (error) {
      console.error('添加项目数据失败:', error)
      throw error
    }
    return data
  },

  // 更新项目数据
  async update(id, project) {
    const { data, error } = await supabase
      .from('student_projects')
      .update(project)
      .eq('id', id)
      .select()
    
    if (error) {
      console.error('更新项目数据失败:', error)
      throw error
    }
    return data
  },

  // 删除项目数据
  async delete(id) {
    const { error } = await supabase
      .from('student_projects')
      .delete()
      .eq('id', id)
    
    if (error) {
      console.error('删除项目数据失败:', error)
      throw error
    }
    return true
  }
}