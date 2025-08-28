-- 2022年度外国语学院年终考核加分情况统计表
-- 数据库Schema设计

CREATE TABLE IF NOT EXISTS teacher_performance (
    id SERIAL PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL COMMENT '教师姓名',
    semester1_score DECIMAL(5,2) COMMENT '21学年第2学期评教分数',
    semester2_score DECIMAL(5,2) COMMENT '22学年第1学期评教分数', 
    school_rank INTEGER COMMENT '学校排名',
    college_rank INTEGER COMMENT '学院排名',
    bonus_points INTEGER DEFAULT 0 COMMENT '加分',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引提高查询性能
CREATE INDEX idx_teacher_name ON teacher_performance(teacher_name);
CREATE INDEX idx_school_rank ON teacher_performance(school_rank);
CREATE INDEX idx_college_rank ON teacher_performance(college_rank);

-- 添加触发器自动更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_teacher_performance_updated_at 
    BEFORE UPDATE ON teacher_performance 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 学生项目管理表
CREATE TABLE IF NOT EXISTS student_projects (
    id SERIAL PRIMARY KEY,
    project_type VARCHAR(50) NOT NULL COMMENT '项目类型（学科竞赛/大创）',
    project_name VARCHAR(200) COMMENT '项目名',
    project_leader VARCHAR(100) COMMENT '项目负责人',
    supervisor VARCHAR(100) COMMENT '项目指导老师',
    start_date DATE COMMENT '立项时间',
    end_date DATE COMMENT '结项时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX idx_project_type ON student_projects(project_type);
CREATE INDEX idx_supervisor ON student_projects(supervisor);

-- 添加触发器
CREATE TRIGGER update_student_projects_updated_at 
    BEFORE UPDATE ON student_projects 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 插入说明注释
COMMENT ON TABLE teacher_performance IS '教师年终考核评教加分统计表';
COMMENT ON COLUMN teacher_performance.teacher_name IS '教师姓名';
COMMENT ON COLUMN teacher_performance.semester1_score IS '21学年第2学期评教分数';
COMMENT ON COLUMN teacher_performance.semester2_score IS '22学年第1学期评教分数';
COMMENT ON COLUMN teacher_performance.school_rank IS '学校排名';
COMMENT ON COLUMN teacher_performance.college_rank IS '学院排名';
COMMENT ON COLUMN teacher_performance.bonus_points IS '加分分数';

COMMENT ON TABLE student_projects IS '2022年度指导学生项目统计表';
COMMENT ON COLUMN student_projects.project_type IS '项目类型（学科竞赛/大创）';
COMMENT ON COLUMN student_projects.project_name IS '项目名称';
COMMENT ON COLUMN student_projects.project_leader IS '项目负责人';
COMMENT ON COLUMN student_projects.supervisor IS '项目指导老师';
COMMENT ON COLUMN student_projects.start_date IS '立项时间';
COMMENT ON COLUMN student_projects.end_date IS '结项时间';