/**
 * 外国语学院年终考核加分管理系统 - Supabase API 客户端
 * 统一管理所有13个数据表的CRUD操作
 */

// Supabase配置
const SUPABASE_URL = 'https://vzfctheujcssdazwqliu.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6ZmN0aGV1amNzc2RhendxbGl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ4MjI1MjcsImV4cCI6MjA0MDM5ODUyN30.WEMYh8ut2vF1lFcx1zGa8zEKQdgJW35e1tKzpIqSrMM';

// 初始化Supabase客户端
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// 表名映射：中文名 -> 英文表名
const TABLE_MAPPING = {
    '学生评教': 'teacher_evaluations',
    '调停课': 'class_adjustments',
    '指导学生项目统计': 'student_projects',
    '管理人员服务对象打分': 'manager_evaluations',
    '校级项目统计': 'school_projects',
    '获奖统计': 'awards',
    '学生获奖': 'student_awards',
    '省级纵向教研': 'provincial_research',
    '党建&学工课题': 'party_work_topics',
    '横向项目统计': 'horizontal_projects',
    '教师参会扣分情况': 'teacher_attendance',
    '发表论文': 'published_papers',
    '讲座': 'lectures'
};

// 字段映射：每个表的字段对应关系
const FIELD_MAPPING = {
    'teacher_evaluations': {
        '教师姓名': 'teacher_name',
        '21学年第2学期评教分数': 'semester1_score',
        '22学年第1学期评教分数': 'semester2_score',
        '学校排名': 'school_rank',
        '学院排名': 'college_rank',
        '加分': 'bonus_points'
    },
    'class_adjustments': {
        '教师姓名': 'teacher_name',
        '专业课调停课次数': 'major_course_count',
        '英语课调停课次数': 'english_course_count',
        '总次数': 'total_count',
        '扣分': 'deduction',
        '备注': 'reason'
    },
    'student_projects': {
        '指导教师': 'teacher_name',
        '项目名称': 'project_name',
        '项目类型': 'project_type',
        '学生人数': 'student_count',
        '加分': 'bonus_points'
    },
    'manager_evaluations': {
        '管理人员': 'manager_name',
        '服务对象': 'service_target',
        '评分总分': 'total_score',
        '评价人数': 'evaluation_count',
        '平均分': 'average_score'
    },
    'school_projects': {
        '项目名称': 'project_name',
        '负责人': 'leader_name',
        '项目类型': 'project_type',
        '立项时间': 'start_time',
        '项目状态': 'project_status',
        '加分': 'bonus_points'
    },
    'awards': {
        '获奖名称': 'award_name',
        '获奖等级': 'award_level',
        '获奖人员': 'award_person',
        '获奖时间': 'award_time',
        '加分': 'bonus_points'
    },
    'student_awards': {
        '学生姓名': 'student_name',
        '获奖名称': 'award_name',
        '获奖等级': 'award_level',
        '指导教师': 'teacher_name',
        '获奖时间': 'award_time',
        '加分': 'bonus_points'
    },
    'provincial_research': {
        '项目名称': 'project_name',
        '项目负责人': 'leader_name',
        '立项时间': 'start_time',
        '项目级别': 'project_level',
        '项目状态': 'project_status',
        '加分': 'bonus_points'
    },
    'party_work_topics': {
        '课题名称': 'topic_name',
        '课题负责人': 'leader_name',
        '课题类型': 'topic_type',
        '立项时间': 'start_time',
        '完成状态': 'completion_status',
        '加分': 'bonus_points'
    },
    'horizontal_projects': {
        '项目名称': 'project_name',
        '项目负责人': 'leader_name',
        '合作单位': 'partner_unit',
        '项目金额': 'project_amount',
        '立项时间': 'start_time',
        '加分': 'bonus_points'
    },
    'teacher_attendance': {
        '教师姓名': 'teacher_name',
        '会议名称': 'meeting_name',
        '应参加次数': 'required_attendance',
        '实际参加次数': 'actual_attendance',
        '缺席次数': 'absence_count',
        '扣分': 'deduction'
    },
    'published_papers': {
        '论文标题': 'paper_title',
        '作者姓名': 'author_name',
        '发表期刊': 'journal_name',
        '发表时间': 'publish_time',
        '期刊级别': 'journal_level',
        '加分': 'bonus_points'
    },
    'lectures': {
        '讲座主题': 'lecture_topic',
        '主讲人': 'lecturer_name',
        '讲座类型': 'lecture_type',
        '举办时间': 'lecture_time',
        '参加人数': 'attendance_count',
        '加分': 'bonus_points'
    }
};

/**
 * 统一的数据库操作类
 */
class DatabaseAPI {
    /**
     * 获取表的英文名
     */
    getTableName(chineseName) {
        return TABLE_MAPPING[chineseName] || chineseName;
    }

    /**
     * 获取字段映射
     */
    getFieldMapping(tableName) {
        return FIELD_MAPPING[tableName] || {};
    }

    /**
     * 转换字段名：中文 -> 英文
     */
    transformFieldsToEnglish(tableName, data) {
        const fieldMap = this.getFieldMapping(tableName);
        const transformed = {};
        
        for (const [chineseKey, value] of Object.entries(data)) {
            const englishKey = fieldMap[chineseKey] || chineseKey;
            transformed[englishKey] = value;
        }
        
        return transformed;
    }

    /**
     * 转换字段名：英文 -> 中文
     */
    transformFieldsToChinese(tableName, data) {
        const fieldMap = this.getFieldMapping(tableName);
        const reverseMap = {};
        
        // 创建反向映射
        for (const [chinese, english] of Object.entries(fieldMap)) {
            reverseMap[english] = chinese;
        }
        
        const transformed = {};
        for (const [englishKey, value] of Object.entries(data)) {
            const chineseKey = reverseMap[englishKey] || englishKey;
            transformed[chineseKey] = value;
        }
        
        return transformed;
    }

    /**
     * 查询所有数据
     */
    async getAll(chineseName) {
        try {
            const tableName = this.getTableName(chineseName);
            const { data, error } = await supabase
                .from(tableName)
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;

            // 转换字段名为中文
            return data.map(item => this.transformFieldsToChinese(tableName, item));
        } catch (error) {
            console.error(`获取 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 根据ID查询单条数据
     */
    async getById(chineseName, id) {
        try {
            const tableName = this.getTableName(chineseName);
            const { data, error } = await supabase
                .from(tableName)
                .select('*')
                .eq('id', id)
                .single();

            if (error) throw error;

            // 转换字段名为中文
            return this.transformFieldsToChinese(tableName, data);
        } catch (error) {
            console.error(`获取 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 创建新数据
     */
    async create(chineseName, data) {
        try {
            const tableName = this.getTableName(chineseName);
            
            // 转换字段名为英文
            const transformedData = this.transformFieldsToEnglish(tableName, data);
            
            const { data: result, error } = await supabase
                .from(tableName)
                .insert([transformedData])
                .select()
                .single();

            if (error) throw error;

            // 转换字段名为中文
            return this.transformFieldsToChinese(tableName, result);
        } catch (error) {
            console.error(`创建 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 更新数据
     */
    async update(chineseName, id, data) {
        try {
            const tableName = this.getTableName(chineseName);
            
            // 转换字段名为英文
            const transformedData = this.transformFieldsToEnglish(tableName, data);
            
            const { data: result, error } = await supabase
                .from(tableName)
                .update(transformedData)
                .eq('id', id)
                .select()
                .single();

            if (error) throw error;

            // 转换字段名为中文
            return this.transformFieldsToChinese(tableName, result);
        } catch (error) {
            console.error(`更新 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 删除数据
     */
    async delete(chineseName, id) {
        try {
            const tableName = this.getTableName(chineseName);
            
            const { error } = await supabase
                .from(tableName)
                .delete()
                .eq('id', id);

            if (error) throw error;

            return { success: true };
        } catch (error) {
            console.error(`删除 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 批量创建数据
     */
    async createBatch(chineseName, dataArray) {
        try {
            const tableName = this.getTableName(chineseName);
            
            // 转换所有数据的字段名为英文
            const transformedDataArray = dataArray.map(item => 
                this.transformFieldsToEnglish(tableName, item)
            );
            
            const { data: result, error } = await supabase
                .from(tableName)
                .insert(transformedDataArray)
                .select();

            if (error) throw error;

            // 转换字段名为中文
            return result.map(item => this.transformFieldsToChinese(tableName, item));
        } catch (error) {
            console.error(`批量创建 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 搜索数据
     */
    async search(chineseName, searchField, searchValue) {
        try {
            const tableName = this.getTableName(chineseName);
            const fieldMap = this.getFieldMapping(tableName);
            const englishField = fieldMap[searchField] || searchField;
            
            const { data, error } = await supabase
                .from(tableName)
                .select('*')
                .ilike(englishField, `%${searchValue}%`)
                .order('created_at', { ascending: false });

            if (error) throw error;

            // 转换字段名为中文
            return data.map(item => this.transformFieldsToChinese(tableName, item));
        } catch (error) {
            console.error(`搜索 ${chineseName} 数据失败:`, error);
            throw error;
        }
    }

    /**
     * 获取数据统计
     */
    async getStats(chineseName) {
        try {
            const tableName = this.getTableName(chineseName);
            
            const { count, error } = await supabase
                .from(tableName)
                .select('*', { count: 'exact', head: true });

            if (error) throw error;

            return { count };
        } catch (error) {
            console.error(`获取 ${chineseName} 统计失败:`, error);
            throw error;
        }
    }

    /**
     * 测试数据库连接
     */
    async testConnection() {
        try {
            const { data, error } = await supabase
                .from('teacher_evaluations')
                .select('id')
                .limit(1);

            if (error) throw error;

            return { success: true, message: '数据库连接成功' };
        } catch (error) {
            console.error('数据库连接失败:', error);
            return { success: false, message: error.message };
        }
    }
}

// 创建全局API实例
const dbAPI = new DatabaseAPI();

// 导出API实例和相关配置
window.DatabaseAPI = DatabaseAPI;
window.dbAPI = dbAPI;
window.TABLE_MAPPING = TABLE_MAPPING;
window.FIELD_MAPPING = FIELD_MAPPING;

// 控制台输出初始化信息
console.log('🚀 Supabase API 客户端已初始化');
console.log('📊 支持的数据表:', Object.keys(TABLE_MAPPING));
console.log('🔗 数据库URL:', SUPABASE_URL);

// 自动测试连接
dbAPI.testConnection().then(result => {
    if (result.success) {
        console.log('✅ 数据库连接测试成功');
    } else {
        console.error('❌ 数据库连接测试失败:', result.message);
    }
});