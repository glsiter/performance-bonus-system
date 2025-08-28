import { createClient } from '@supabase/supabase-js'

// Supabase配置
const supabaseUrl = 'https://vzfctheujcssdazwqliu.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6ZmN0aGV1amNzc2RhendxbGl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNDc3OTgsImV4cCI6MjA3MTkyMzc5OH0.XKm2enTM14LDwHU_Yz7IT5FOvr3eCGClINZTvdSDgds'

// 创建Supabase客户端
const supabase = createClient(supabaseUrl, supabaseKey)

export default supabase

// 数据库表结构定义
export const TABLES = {
    student_evaluation: '学生评教',
    management_evaluation: '管理人员服务对象打分', 
    class_adjustment: '调停课',
    student_projects: '指导学生项目统计',
    school_projects: '校级项目统计',
    awards: '获奖统计',
    student_awards: '学生获奖',
    teacher_attendance: '教师参会扣分情况',
    publications: '发表论文',
    lectures: '讲座'
}

// 数据库操作函数
export class SupabaseService {
    
    // 获取表数据
    async getTableData(tableName) {
        try {
            const { data, error } = await supabase
                .from(tableName)
                .select('*')
                .order('created_at', { ascending: false })
            
            if (error) throw error
            return data || []
        } catch (error) {
            console.error(`获取${tableName}数据失败:`, error)
            return []
        }
    }

    // 添加数据
    async addData(tableName, data) {
        try {
            const newData = {
                ...data,
                id: this.generateId(),
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
            }
            
            const { data: result, error } = await supabase
                .from(tableName)
                .insert([newData])
                .select()
            
            if (error) throw error
            return result[0]
        } catch (error) {
            console.error(`添加${tableName}数据失败:`, error)
            throw error
        }
    }

    // 更新数据
    async updateData(tableName, id, data) {
        try {
            const updateData = {
                ...data,
                updated_at: new Date().toISOString()
            }
            
            const { data: result, error } = await supabase
                .from(tableName)
                .update(updateData)
                .eq('id', id)
                .select()
            
            if (error) throw error
            return result[0]
        } catch (error) {
            console.error(`更新${tableName}数据失败:`, error)
            throw error
        }
    }

    // 删除数据
    async deleteData(tableName, id) {
        try {
            const { error } = await supabase
                .from(tableName)
                .delete()
                .eq('id', id)
            
            if (error) throw error
            return true
        } catch (error) {
            console.error(`删除${tableName}数据失败:`, error)
            throw error
        }
    }

    // 批量删除数据
    async batchDelete(tableName, ids) {
        try {
            const { error } = await supabase
                .from(tableName)
                .delete()
                .in('id', ids)
            
            if (error) throw error
            return true
        } catch (error) {
            console.error(`批量删除${tableName}数据失败:`, error)
            throw error
        }
    }

    // 生成唯一ID
    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2)
    }

    // 搜索数据
    async searchData(tableName, searchTerm, columns = ['*']) {
        try {
            // 构建搜索查询
            let query = supabase.from(tableName).select(columns.join(','))
            
            // 如果有搜索词，添加搜索条件
            if (searchTerm && searchTerm.trim()) {
                // 这里需要根据具体的列名进行搜索，暂时先返回所有数据再在前端过滤
                query = query.order('created_at', { ascending: false })
            } else {
                query = query.order('created_at', { ascending: false })
            }
            
            const { data, error } = await query
            if (error) throw error
            
            // 前端过滤搜索结果
            if (searchTerm && searchTerm.trim()) {
                const term = searchTerm.toLowerCase()
                return data.filter(item => 
                    Object.values(item).some(value => 
                        value && value.toString().toLowerCase().includes(term)
                    )
                )
            }
            
            return data || []
        } catch (error) {
            console.error(`搜索${tableName}数据失败:`, error)
            return []
        }
    }

    // 导出数据为CSV格式
    async exportToCSV(tableName) {
        try {
            const data = await this.getTableData(tableName)
            if (!data.length) return ''
            
            // 获取所有列名
            const headers = Object.keys(data[0])
            
            // 构建CSV内容
            const csvContent = [
                headers.join(','), // 表头
                ...data.map(row => 
                    headers.map(header => {
                        const value = row[header]
                        // 处理包含逗号或换行的值
                        if (value && (value.includes(',') || value.includes('\n'))) {
                            return `"${value.replace(/"/g, '""')}"`
                        }
                        return value || ''
                    }).join(',')
                )
            ].join('\n')
            
            return csvContent
        } catch (error) {
            console.error(`导出${tableName}数据失败:`, error)
            return ''
        }
    }

    // 从CSV导入数据
    async importFromCSV(tableName, csvContent) {
        try {
            const lines = csvContent.trim().split('\n')
            if (lines.length < 2) throw new Error('CSV文件格式不正确')
            
            const headers = lines[0].split(',').map(h => h.trim())
            const rows = lines.slice(1).map(line => {
                const values = line.split(',').map(v => v.trim())
                const obj = {}
                headers.forEach((header, index) => {
                    obj[header] = values[index] || ''
                })
                return obj
            })
            
            // 批量插入数据
            const newRows = rows.map(row => ({
                ...row,
                id: this.generateId(),
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
            }))
            
            const { data, error } = await supabase
                .from(tableName)
                .insert(newRows)
                .select()
            
            if (error) throw error
            return data
        } catch (error) {
            console.error(`导入${tableName}数据失败:`, error)
            throw error
        }
    }
}

// 创建数据库服务实例
export const dbService = new SupabaseService()