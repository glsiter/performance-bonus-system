-- 年终考核管理系统数据库表结构
-- 需要在 Supabase SQL Editor 中执行以下SQL语句

-- 1. 学生评教表
CREATE TABLE student_evaluation (
    id TEXT PRIMARY KEY,
    teacher_name TEXT NOT NULL,
    semester1_score DECIMAL(4,1),
    semester2_score DECIMAL(4,1),
    school_rank INTEGER,
    college_rank INTEGER,
    bonus_points DECIMAL(4,1) DEFAULT 30,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 管理人员服务对象打分表
CREATE TABLE management_evaluation (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    total_score DECIMAL(5,2),
    evaluation_count INTEGER DEFAULT 38,
    average_score DECIMAL(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 调停课表
CREATE TABLE class_adjustment (
    id TEXT PRIMARY KEY,
    teacher_name TEXT NOT NULL,
    major_course_count INTEGER DEFAULT 0,
    english_course_count INTEGER DEFAULT 0,
    total_count INTEGER,
    deduction DECIMAL(3,1),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 指导学生项目统计表
CREATE TABLE student_projects (
    id TEXT PRIMARY KEY,
    project_type TEXT NOT NULL CHECK (project_type IN ('学科竞赛', '大创')),
    project_name TEXT NOT NULL,
    project_leader TEXT,
    supervisor TEXT NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 校级项目统计表
CREATE TABLE school_projects (
    id TEXT PRIMARY KEY,
    project_type TEXT NOT NULL CHECK (project_type IN ('思政示范课程项目', '教改项目一般类', '教改项目重点类', '科研项目')),
    project_name TEXT NOT NULL,
    host TEXT NOT NULL,
    members TEXT,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 获奖统计表
CREATE TABLE awards (
    id TEXT PRIMARY KEY,
    award_name TEXT NOT NULL,
    level TEXT NOT NULL CHECK (level IN ('校级', '市级', '省级', '国家级')),
    winner TEXT NOT NULL,
    award_date DATE,
    bonus_points INTEGER,
    remarks TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. 学生获奖表
CREATE TABLE student_awards (
    id TEXT PRIMARY KEY,
    competition_name TEXT NOT NULL,
    level TEXT NOT NULL CHECK (level IN ('校级', '市级', '省级', '国家级')),
    award TEXT NOT NULL CHECK (award IN ('一等奖', '二等奖', '三等奖', '优秀奖')),
    major TEXT,
    winners TEXT NOT NULL,
    organizer TEXT,
    participants INTEGER,
    instructor TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. 教师参会扣分情况表
CREATE TABLE teacher_attendance (
    id TEXT PRIMARY KEY,
    teacher_name TEXT NOT NULL,
    major TEXT,
    deduction DECIMAL(3,1),
    remarks TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. 发表论文表
CREATE TABLE publications (
    id TEXT PRIMARY KEY,
    author_name TEXT NOT NULL,
    title TEXT NOT NULL,
    author_rank TEXT NOT NULL CHECK (author_rank IN ('第一', '第二', '第三', '独撰')),
    publish_date TEXT, -- 使用TEXT存储年月格式 YYYY-MM
    journal TEXT NOT NULL,
    publisher TEXT,
    is_core TEXT CHECK (is_core IN ('是', '否')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 10. 讲座表
CREATE TABLE lectures (
    id TEXT PRIMARY KEY,
    date DATE NOT NULL,
    content TEXT NOT NULL,
    participants TEXT NOT NULL,
    location TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 为每个表添加RLS (Row Level Security) 策略
ALTER TABLE student_evaluation ENABLE ROW LEVEL SECURITY;
ALTER TABLE management_evaluation ENABLE ROW LEVEL SECURITY;
ALTER TABLE class_adjustment ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE school_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE awards ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_awards ENABLE ROW LEVEL SECURITY;
ALTER TABLE teacher_attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE publications ENABLE ROW LEVEL SECURITY;
ALTER TABLE lectures ENABLE ROW LEVEL SECURITY;

-- 创建允许所有操作的策略（可根据需要调整权限）
CREATE POLICY "Allow all operations" ON student_evaluation FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON management_evaluation FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON class_adjustment FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON student_projects FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON school_projects FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON awards FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON student_awards FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON teacher_attendance FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON publications FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON lectures FOR ALL USING (true);

-- 创建触发器函数来自动更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language plpgsql;

-- 为每个表创建更新触发器
CREATE TRIGGER update_student_evaluation_updated_at BEFORE UPDATE ON student_evaluation FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_management_evaluation_updated_at BEFORE UPDATE ON management_evaluation FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_class_adjustment_updated_at BEFORE UPDATE ON class_adjustment FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_student_projects_updated_at BEFORE UPDATE ON student_projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_school_projects_updated_at BEFORE UPDATE ON school_projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_awards_updated_at BEFORE UPDATE ON awards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_student_awards_updated_at BEFORE UPDATE ON student_awards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_teacher_attendance_updated_at BEFORE UPDATE ON teacher_attendance FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_publications_updated_at BEFORE UPDATE ON publications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lectures_updated_at BEFORE UPDATE ON lectures FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 创建索引以提高查询性能
CREATE INDEX idx_student_evaluation_teacher ON student_evaluation(teacher_name);
CREATE INDEX idx_management_evaluation_name ON management_evaluation(name);
CREATE INDEX idx_class_adjustment_teacher ON class_adjustment(teacher_name);
CREATE INDEX idx_student_projects_supervisor ON student_projects(supervisor);
CREATE INDEX idx_school_projects_host ON school_projects(host);
CREATE INDEX idx_awards_winner ON awards(winner);
CREATE INDEX idx_student_awards_instructor ON student_awards(instructor);
CREATE INDEX idx_teacher_attendance_teacher ON teacher_attendance(teacher_name);
CREATE INDEX idx_publications_author ON publications(author_name);
CREATE INDEX idx_lectures_date ON lectures(date);

-- 创建时间戳索引
CREATE INDEX idx_student_evaluation_created ON student_evaluation(created_at DESC);
CREATE INDEX idx_management_evaluation_created ON management_evaluation(created_at DESC);
CREATE INDEX idx_class_adjustment_created ON class_adjustment(created_at DESC);
CREATE INDEX idx_student_projects_created ON student_projects(created_at DESC);
CREATE INDEX idx_school_projects_created ON school_projects(created_at DESC);
CREATE INDEX idx_awards_created ON awards(created_at DESC);
CREATE INDEX idx_student_awards_created ON student_awards(created_at DESC);
CREATE INDEX idx_teacher_attendance_created ON teacher_attendance(created_at DESC);
CREATE INDEX idx_publications_created ON publications(created_at DESC);
CREATE INDEX idx_lectures_created ON lectures(created_at DESC);