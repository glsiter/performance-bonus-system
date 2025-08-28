-- =========================================
-- 外国语学院年终考核加分管理系统 - 完整数据库结构
-- 包含13个数据表的完整定义
-- =========================================

-- 1. 学生评教表
CREATE TABLE IF NOT EXISTS teacher_evaluations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL,
    semester1_score DECIMAL(4,1) CHECK (semester1_score >= 0 AND semester1_score <= 100),
    semester2_score DECIMAL(4,1) CHECK (semester2_score >= 0 AND semester2_score <= 100),
    school_rank INTEGER CHECK (school_rank > 0),
    college_rank INTEGER CHECK (college_rank > 0),
    bonus_points DECIMAL(5,1) DEFAULT 30,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_teacher_evaluations_name ON teacher_evaluations(teacher_name);
CREATE INDEX IF NOT EXISTS idx_teacher_evaluations_ranks ON teacher_evaluations(school_rank, college_rank);

-- 2. 调停课表
CREATE TABLE IF NOT EXISTS class_adjustments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL,
    major_course_count INTEGER DEFAULT 0 CHECK (major_course_count >= 0),
    english_course_count INTEGER DEFAULT 0 CHECK (english_course_count >= 0),
    total_count INTEGER DEFAULT 0 CHECK (total_count >= 0),
    deduction DECIMAL(5,1) DEFAULT 0,
    reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_class_adjustments_teacher ON class_adjustments(teacher_name);

-- 3. 指导学生项目统计表
CREATE TABLE IF NOT EXISTS student_projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL,
    project_name VARCHAR(200) NOT NULL,
    project_type VARCHAR(50) NOT NULL,
    student_count INTEGER CHECK (student_count > 0),
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_student_projects_teacher ON student_projects(teacher_name);
CREATE INDEX IF NOT EXISTS idx_student_projects_type ON student_projects(project_type);

-- 4. 管理人员服务对象打分表
CREATE TABLE IF NOT EXISTS manager_evaluations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    manager_name VARCHAR(100) NOT NULL,
    service_target VARCHAR(100) NOT NULL,
    total_score DECIMAL(6,1) DEFAULT 0,
    evaluation_count INTEGER CHECK (evaluation_count > 0),
    average_score DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_manager_evaluations_manager ON manager_evaluations(manager_name);

-- 5. 校级项目统计表
CREATE TABLE IF NOT EXISTS school_projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_name VARCHAR(200) NOT NULL,
    leader_name VARCHAR(100) NOT NULL,
    project_type VARCHAR(50) NOT NULL,
    start_time DATE,
    project_status VARCHAR(20) DEFAULT '在研',
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_school_projects_leader ON school_projects(leader_name);
CREATE INDEX IF NOT EXISTS idx_school_projects_status ON school_projects(project_status);

-- 6. 获奖统计表
CREATE TABLE IF NOT EXISTS awards (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    award_name VARCHAR(200) NOT NULL,
    award_level VARCHAR(20) NOT NULL,
    award_person VARCHAR(100) NOT NULL,
    award_time DATE,
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_awards_person ON awards(award_person);
CREATE INDEX IF NOT EXISTS idx_awards_level ON awards(award_level);

-- 7. 学生获奖表
CREATE TABLE IF NOT EXISTS student_awards (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    award_name VARCHAR(200) NOT NULL,
    award_level VARCHAR(20) NOT NULL,
    teacher_name VARCHAR(100) NOT NULL,
    award_time DATE,
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_student_awards_teacher ON student_awards(teacher_name);
CREATE INDEX IF NOT EXISTS idx_student_awards_student ON student_awards(student_name);

-- 8. 省级纵向教研表
CREATE TABLE IF NOT EXISTS provincial_research (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_name VARCHAR(200) NOT NULL,
    leader_name VARCHAR(100) NOT NULL,
    start_time DATE,
    project_level VARCHAR(20) NOT NULL,
    project_status VARCHAR(20) DEFAULT '在研',
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_provincial_research_leader ON provincial_research(leader_name);

-- 9. 党建&学工课题表
CREATE TABLE IF NOT EXISTS party_work_topics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    topic_name VARCHAR(200) NOT NULL,
    leader_name VARCHAR(100) NOT NULL,
    topic_type VARCHAR(20) NOT NULL,
    start_time DATE,
    completion_status VARCHAR(20) DEFAULT '进行中',
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_party_work_topics_leader ON party_work_topics(leader_name);

-- 10. 横向项目统计表
CREATE TABLE IF NOT EXISTS horizontal_projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_name VARCHAR(200) NOT NULL,
    leader_name VARCHAR(100) NOT NULL,
    partner_unit VARCHAR(200),
    project_amount VARCHAR(50),
    start_time DATE,
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_horizontal_projects_leader ON horizontal_projects(leader_name);

-- 11. 教师参会扣分情况表
CREATE TABLE IF NOT EXISTS teacher_attendance (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL,
    meeting_name VARCHAR(200) NOT NULL,
    required_attendance INTEGER CHECK (required_attendance >= 0),
    actual_attendance INTEGER CHECK (actual_attendance >= 0),
    absence_count INTEGER CHECK (absence_count >= 0),
    deduction DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_teacher_attendance_teacher ON teacher_attendance(teacher_name);

-- 12. 发表论文表
CREATE TABLE IF NOT EXISTS published_papers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    paper_title VARCHAR(300) NOT NULL,
    author_name VARCHAR(100) NOT NULL,
    journal_name VARCHAR(200) NOT NULL,
    publish_time DATE,
    journal_level VARCHAR(20) NOT NULL,
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_published_papers_author ON published_papers(author_name);
CREATE INDEX IF NOT EXISTS idx_published_papers_level ON published_papers(journal_level);

-- 13. 讲座表
CREATE TABLE IF NOT EXISTS lectures (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    lecture_topic VARCHAR(300) NOT NULL,
    lecturer_name VARCHAR(100) NOT NULL,
    lecture_type VARCHAR(50) NOT NULL,
    lecture_time DATE,
    attendance_count INTEGER CHECK (attendance_count >= 0),
    bonus_points DECIMAL(5,1) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_lectures_lecturer ON lectures(lecturer_name);

-- =========================================
-- 创建自动更新时间戳的触发器
-- =========================================

-- 创建更新时间戳的函数
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有表创建触发器
CREATE TRIGGER update_teacher_evaluations_modtime BEFORE UPDATE ON teacher_evaluations FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_class_adjustments_modtime BEFORE UPDATE ON class_adjustments FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_student_projects_modtime BEFORE UPDATE ON student_projects FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_manager_evaluations_modtime BEFORE UPDATE ON manager_evaluations FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_school_projects_modtime BEFORE UPDATE ON school_projects FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_awards_modtime BEFORE UPDATE ON awards FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_student_awards_modtime BEFORE UPDATE ON student_awards FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_provincial_research_modtime BEFORE UPDATE ON provincial_research FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_party_work_topics_modtime BEFORE UPDATE ON party_work_topics FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_horizontal_projects_modtime BEFORE UPDATE ON horizontal_projects FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_teacher_attendance_modtime BEFORE UPDATE ON teacher_attendance FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_published_papers_modtime BEFORE UPDATE ON published_papers FOR EACH ROW EXECUTE FUNCTION update_modified_column();
CREATE TRIGGER update_lectures_modtime BEFORE UPDATE ON lectures FOR EACH ROW EXECUTE FUNCTION update_modified_column();

-- =========================================
-- 启用行级安全策略 (RLS)
-- =========================================

-- 启用所有表的行级安全
ALTER TABLE teacher_evaluations ENABLE ROW LEVEL SECURITY;
ALTER TABLE class_adjustments ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE manager_evaluations ENABLE ROW LEVEL SECURITY;
ALTER TABLE school_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE awards ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_awards ENABLE ROW LEVEL SECURITY;
ALTER TABLE provincial_research ENABLE ROW LEVEL SECURITY;
ALTER TABLE party_work_topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE horizontal_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE teacher_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE published_papers ENABLE ROW LEVEL SECURITY;
ALTER TABLE lectures ENABLE ROW LEVEL SECURITY;

-- 创建允许匿名用户读写的策略（适合演示环境）
-- 注意：生产环境中应该配置更严格的安全策略

-- 教师评教表策略
CREATE POLICY "Allow anonymous access" ON teacher_evaluations FOR ALL USING (true);

-- 调停课表策略
CREATE POLICY "Allow anonymous access" ON class_adjustments FOR ALL USING (true);

-- 学生项目表策略
CREATE POLICY "Allow anonymous access" ON student_projects FOR ALL USING (true);

-- 管理人员评价表策略
CREATE POLICY "Allow anonymous access" ON manager_evaluations FOR ALL USING (true);

-- 校级项目表策略
CREATE POLICY "Allow anonymous access" ON school_projects FOR ALL USING (true);

-- 获奖统计表策略
CREATE POLICY "Allow anonymous access" ON awards FOR ALL USING (true);

-- 学生获奖表策略
CREATE POLICY "Allow anonymous access" ON student_awards FOR ALL USING (true);

-- 省级教研表策略
CREATE POLICY "Allow anonymous access" ON provincial_research FOR ALL USING (true);

-- 党建学工表策略
CREATE POLICY "Allow anonymous access" ON party_work_topics FOR ALL USING (true);

-- 横向项目表策略
CREATE POLICY "Allow anonymous access" ON horizontal_projects FOR ALL USING (true);

-- 教师出勤表策略
CREATE POLICY "Allow anonymous access" ON teacher_attendance FOR ALL USING (true);

-- 论文发表表策略
CREATE POLICY "Allow anonymous access" ON published_papers FOR ALL USING (true);

-- 讲座表策略
CREATE POLICY "Allow anonymous access" ON lectures FOR ALL USING (true);

-- =========================================
-- 插入示例数据
-- =========================================

-- 1. 教师评教示例数据
INSERT INTO teacher_evaluations (teacher_name, semester1_score, semester2_score, school_rank, college_rank, bonus_points) VALUES
('刘明', 95.0, 92.5, 1, 1, 30),
('许婷芳', 95.0, null, 2, 2, 30),
('李群英', 95.0, null, 3, 3, 30),
('RUBEN CASTILLA SANCHEZ', 95.0, null, 4, 4, 30),
('谢杭航', 95.0, null, 5, 5, 30);

-- 2. 调停课示例数据
INSERT INTO class_adjustments (teacher_name, major_course_count, english_course_count, total_count, deduction, reason) VALUES
('张教师', 4, 2, 6, 3.0, '临时调课'),
('李教师', 2, 3, 5, 2.5, '病假调课'),
('王教师', 3, 1, 4, 2.0, '会议调课');

-- 3. 学生项目示例数据
INSERT INTO student_projects (teacher_name, project_name, project_type, student_count, bonus_points) VALUES
('张指导', '创新创业项目A', '创新创业', 3, 15),
('李指导', '学科竞赛项目B', '学科竞赛', 2, 10),
('王指导', '毕业设计项目C', '毕业设计', 5, 5);

-- 4. 管理人员评价示例数据
INSERT INTO manager_evaluations (manager_name, service_target, total_score, evaluation_count, average_score) VALUES
('管理员A', '教师群体', 450.0, 5, 90.00),
('管理员B', '学生群体', 480.0, 6, 80.00);

-- 5. 校级项目示例数据
INSERT INTO school_projects (project_name, leader_name, project_type, start_time, project_status, bonus_points) VALUES
('教学改革项目A', '项目负责人A', '教研项目', '2022-03-01', '在研', 15),
('科研创新项目B', '项目负责人B', '科研项目', '2022-05-01', '结题', 20);

-- 显示表创建完成信息
SELECT 'Database schema created successfully. All 13 tables are ready for use.' AS status;