# Supabase数据库部署指南

## 📊 数据库表结构总览

本系统包含 **13个数据表**，支持外国语学院年终考核各项加分情况的完整管理。

### 数据表清单

| 序号 | 中文表名 | 英文表名 | 记录数 | 主要字段 | 用途 |
|------|----------|----------|--------|----------|------|
| 1 | 学生评教 | `teacher_evaluations` | 107 | 教师姓名、评教分数、排名、加分 | 教师评教数据管理 |
| 2 | 调停课 | `class_adjustments` | ~33 | 教师姓名、调课次数、扣分 | 调停课扣分统计 |
| 3 | 指导学生项目统计 | `student_projects` | ~10 | 指导教师、项目名称、加分 | 学生项目指导记录 |
| 4 | 管理人员服务对象打分 | `manager_evaluations` | ~7 | 管理人员、服务对象、评分 | 管理人员评价 |
| 5 | 校级项目统计 | `school_projects` | ~8 | 项目名称、负责人、项目状态 | 校级项目管理 |
| 6 | 获奖统计 | `awards` | ~1 | 获奖名称、等级、人员 | 获奖情况记录 |
| 7 | 学生获奖 | `student_awards` | ~1 | 学生姓名、获奖名称、指导教师 | 学生获奖管理 |
| 8 | 省级纵向教研 | `provincial_research` | ~1 | 项目名称、负责人、项目级别 | 省级教研项目 |
| 9 | 党建&学工课题 | `party_work_topics` | ~1 | 课题名称、负责人、课题类型 | 党建学工管理 |
| 10 | 横向项目统计 | `horizontal_projects` | ~1 | 项目名称、合作单位、金额 | 横向合作项目 |
| 11 | 教师参会扣分情况 | `teacher_attendance` | ~134 | 教师姓名、出勤情况、扣分 | 会议出勤管理 |
| 12 | 发表论文 | `published_papers` | ~28 | 论文标题、作者、期刊级别 | 论文发表统计 |
| 13 | 讲座 | `lectures` | ~52 | 讲座主题、主讲人、参加人数 | 学术讲座记录 |

**总记录数**: 约 **381条** 真实数据记录

## 🚀 快速部署步骤

### 步骤1: 创建Supabase项目

1. 访问 [Supabase控制台](https://supabase.com/dashboard)
2. 点击 "New project"
3. 选择组织并输入项目信息：
   - **项目名称**: `performance-bonus-system`
   - **数据库密码**: 设置安全密码
   - **地区**: 选择最近的地区

### 步骤2: 执行数据库脚本

1. 在Supabase控制台进入 **SQL Editor**
2. 复制并执行 `complete_schema.sql` 脚本：

```bash
# 执行完整建表脚本
cat database/complete_schema.sql
```

脚本将创建：
- ✅ 13个数据表及其索引
- ✅ 自动更新时间戳的触发器
- ✅ 行级安全策略（RLS）
- ✅ 基础示例数据

### 步骤3: 导入完整数据

使用Python脚本导入所有数据：

```bash
# 安装依赖
pip install supabase pandas

# 执行数据导入
python database/import_complete_data.py
```

### 步骤4: 配置前端连接

更新前端配置文件中的Supabase连接信息：

```javascript
// 在 database/supabase_api.js 中更新
const SUPABASE_URL = 'YOUR_PROJECT_URL';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';
```

## 📋 详细表结构说明

### 1. teacher_evaluations (学生评教)
```sql
CREATE TABLE teacher_evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    teacher_name VARCHAR(100) NOT NULL,
    semester1_score DECIMAL(4,1) CHECK (semester1_score >= 0 AND semester1_score <= 100),
    semester2_score DECIMAL(4,1) CHECK (semester2_score >= 0 AND semester2_score <= 100),
    school_rank INTEGER CHECK (school_rank > 0),
    college_rank INTEGER CHECK (college_rank > 0),
    bonus_points DECIMAL(5,1) DEFAULT 30,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**字段说明**:
- `teacher_name`: 教师姓名（必填）
- `semester1_score`: 21学年第2学期评教分数（0-100）
- `semester2_score`: 22学年第1学期评教分数（可选）
- `school_rank`: 学校排名（正整数）
- `college_rank`: 学院排名（正整数）
- `bonus_points`: 加分（默认30分）

### 2. class_adjustments (调停课)
```sql
CREATE TABLE class_adjustments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    teacher_name VARCHAR(100) NOT NULL,
    major_course_count INTEGER DEFAULT 0 CHECK (major_course_count >= 0),
    english_course_count INTEGER DEFAULT 0 CHECK (english_course_count >= 0),
    total_count INTEGER DEFAULT 0 CHECK (total_count >= 0),
    deduction DECIMAL(5,1) DEFAULT 0,
    reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**字段说明**:
- `major_course_count`: 专业课调停课次数
- `english_course_count`: 英语课调停课次数
- `total_count`: 总调停课次数（自动计算）
- `deduction`: 扣分（每2次扣0.5分）
- `reason`: 调停课原因

### 3. student_projects (指导学生项目统计)
```sql
CREATE TABLE student_projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    teacher_name VARCHAR(100) NOT NULL,
    project_name VARCHAR(200) NOT NULL,
    project_type VARCHAR(50) NOT NULL,
    student_count INTEGER CHECK (student_count > 0),
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**字段说明**:
- `teacher_name`: 指导教师姓名
- `project_name`: 项目名称
- `project_type`: 项目类型（创新创业/学科竞赛/毕业设计）
- `student_count`: 参与学生人数
- `bonus_points`: 获得加分

### 4-13. 其他表结构

每个表都包含以下标准字段：
- `id`: UUID主键（自动生成）
- `created_at`: 创建时间（自动）
- `updated_at`: 更新时间（自动）

## 🔧 API使用指南

### JavaScript API调用示例

```javascript
// 获取所有教师评教数据
const teacherData = await dbAPI.getAll('学生评教');

// 创建新的调停课记录
const newRecord = await dbAPI.create('调停课', {
    '教师姓名': '张教师',
    '专业课调停课次数': 2,
    '英语课调停课次数': 1,
    '备注': '临时调课'
});

// 更新学生项目记录
await dbAPI.update('指导学生项目统计', recordId, {
    '项目名称': '更新的项目名称',
    '学生人数': 5
});

// 删除记录
await dbAPI.delete('获奖统计', recordId);

// 搜索功能
const results = await dbAPI.search('发表论文', '作者姓名', '张教授');
```

### 字段映射系统

系统自动处理中英文字段名映射：

```javascript
// 中文字段名 → 英文数据库字段
'教师姓名' → 'teacher_name'
'21学年第2学期评教分数' → 'semester1_score'
'学校排名' → 'school_rank'
```

## 🔐 安全配置

### 行级安全策略 (RLS)

所有表都启用了RLS，当前配置允许匿名访问（适合演示）：

```sql
-- 示例策略（生产环境需要更严格的权限控制）
CREATE POLICY "Allow anonymous access" ON teacher_evaluations FOR ALL USING (true);
```

### 生产环境安全建议

1. **启用用户认证**：配置Email/密码或第三方认证
2. **细化访问权限**：根据用户角色设置不同的RLS策略
3. **API密钥管理**：使用服务角色密钥进行服务端操作
4. **数据备份**：启用自动备份和时间点恢复

## 📊 数据导入验证

导入完成后，验证数据：

```sql
-- 检查各表记录数
SELECT 
    schemaname,
    tablename,
    n_tup_ins as "插入记录数"
FROM pg_stat_user_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- 验证教师评教数据
SELECT COUNT(*) as "教师评教记录数" FROM teacher_evaluations;

-- 验证调停课数据
SELECT COUNT(*) as "调停课记录数" FROM class_adjustments;
```

## 🚨 故障排除

### 常见问题

1. **连接失败**：检查URL和API密钥是否正确
2. **权限错误**：确认RLS策略已正确配置
3. **字段映射错误**：检查中英文字段名对应关系
4. **数据类型错误**：确认输入数据符合表结构约束

### 日志查看

在Supabase控制台的 **Logs** 面板查看：
- API调用日志
- 数据库查询日志
- 错误信息详情

## 🎯 性能优化

### 索引优化
- 教师姓名字段建立索引（频繁查询）
- 排名字段建立复合索引
- 时间字段建立索引（用于排序）

### 查询优化
- 使用分页查询大量数据
- 避免SELECT *，只选择需要的字段
- 使用连接查询代替多次单表查询

---

## 📞 技术支持

如遇问题，请参考：
- [Supabase官方文档](https://supabase.com/docs)
- [SQL参考手册](https://supabase.com/docs/guides/database)
- [JavaScript客户端文档](https://supabase.com/docs/reference/javascript)

**系统版本**: v1.0  
**数据库版本**: PostgreSQL 15  
**最后更新**: 2025-08-28