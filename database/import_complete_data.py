#!/usr/bin/env python3
"""
外国语学院年终考核加分管理系统 - 完整数据导入脚本
导入所有13个数据表的数据到Supabase数据库
"""

import json
import os
from datetime import datetime, date
from supabase import create_client, Client
import pandas as pd

# Supabase配置
SUPABASE_URL = "https://vzfctheujcssdazwqliu.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6ZmN0aGV1amNzc2RhendxbGl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ4MjI1MjcsImV4cCI6MjA0MDM5ODUyN30.WEMYh8ut2vF1lFcx1zGa8zEKQdgJW35e1tKzpIqSrMM"

# 表名映射：中文名 -> 英文表名
TABLE_MAPPING = {
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
}

# 字段映射：每个表的字段对应关系
FIELD_MAPPING = {
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
}

def init_supabase():
    """初始化Supabase客户端"""
    return create_client(SUPABASE_URL, SUPABASE_KEY)

def generate_sample_data():
    """生成所有13个表的示例数据"""
    sample_data = {}
    
    # 1. 教师评教数据
    sample_data['teacher_evaluations'] = [
        {'teacher_name': '刘明', 'semester1_score': 95.0, 'semester2_score': 92.5, 'school_rank': 1, 'college_rank': 1, 'bonus_points': 30},
        {'teacher_name': '许婷芳', 'semester1_score': 95.0, 'semester2_score': None, 'school_rank': 2, 'college_rank': 2, 'bonus_points': 30},
        {'teacher_name': '李群英', 'semester1_score': 95.0, 'semester2_score': None, 'school_rank': 3, 'college_rank': 3, 'bonus_points': 30},
        {'teacher_name': 'RUBEN CASTILLA SANCHEZ', 'semester1_score': 95.0, 'semester2_score': None, 'school_rank': 4, 'college_rank': 4, 'bonus_points': 30},
        {'teacher_name': '谢杭航', 'semester1_score': 95.0, 'semester2_score': None, 'school_rank': 5, 'college_rank': 5, 'bonus_points': 30},
        {'teacher_name': '彭立家', 'semester1_score': 95.0, 'semester2_score': None, 'school_rank': 6, 'college_rank': 6, 'bonus_points': 30},
        {'teacher_name': '彭万欣', 'semester1_score': 95.0, 'semester2_score': None, 'school_rank': 7, 'college_rank': 7, 'bonus_points': 30},
        {'teacher_name': '李国玉', 'semester1_score': 94.98, 'semester2_score': None, 'school_rank': 108, 'college_rank': 8, 'bonus_points': 30}
    ]
    
    # 2. 调停课数据
    sample_data['class_adjustments'] = [
        {'teacher_name': '张教师', 'major_course_count': 4, 'english_course_count': 2, 'total_count': 6, 'deduction': 3.0, 'reason': '临时调课'},
        {'teacher_name': '李教师', 'major_course_count': 2, 'english_course_count': 3, 'total_count': 5, 'deduction': 2.5, 'reason': '病假调课'},
        {'teacher_name': '王教师', 'major_course_count': 3, 'english_course_count': 1, 'total_count': 4, 'deduction': 2.0, 'reason': '会议调课'}
    ]
    
    # 3. 学生项目数据
    sample_data['student_projects'] = [
        {'teacher_name': '张指导', 'project_name': '创新创业项目A', 'project_type': '创新创业', 'student_count': 3, 'bonus_points': 15},
        {'teacher_name': '李指导', 'project_name': '学科竞赛项目B', 'project_type': '学科竞赛', 'student_count': 2, 'bonus_points': 10},
        {'teacher_name': '王指导', 'project_name': '毕业设计项目C', 'project_type': '毕业设计', 'student_count': 5, 'bonus_points': 5}
    ]
    
    # 4. 管理人员评价数据
    sample_data['manager_evaluations'] = [
        {'manager_name': '管理员A', 'service_target': '教师群体', 'total_score': 450.0, 'evaluation_count': 5, 'average_score': 90.00},
        {'manager_name': '管理员B', 'service_target': '学生群体', 'total_score': 480.0, 'evaluation_count': 6, 'average_score': 80.00}
    ]
    
    # 5. 校级项目数据
    sample_data['school_projects'] = [
        {'project_name': '教学改革项目A', 'leader_name': '项目负责人A', 'project_type': '教研项目', 'start_time': '2022-03-01', 'project_status': '在研', 'bonus_points': 15},
        {'project_name': '科研创新项目B', 'leader_name': '项目负责人B', 'project_type': '科研项目', 'start_time': '2022-05-01', 'project_status': '结题', 'bonus_points': 20}
    ]
    
    # 6. 获奖统计数据
    sample_data['awards'] = [
        {'award_name': '优秀教师奖', 'award_level': '省级', 'award_person': '获奖教师A', 'award_time': '2022-06-01', 'bonus_points': 20}
    ]
    
    # 7. 学生获奖数据
    sample_data['student_awards'] = [
        {'student_name': '学生A', 'award_name': '全国英语竞赛', 'award_level': '国家级', 'teacher_name': '指导教师A', 'award_time': '2022-04-01', 'bonus_points': 30}
    ]
    
    # 8. 省级教研数据
    sample_data['provincial_research'] = [
        {'project_name': '外语教学改革研究', 'leader_name': '研究负责人A', 'start_time': '2022-01-01', 'project_level': '省级重点', 'project_status': '在研', 'bonus_points': 25}
    ]
    
    # 9. 党建学工数据
    sample_data['party_work_topics'] = [
        {'topic_name': '党建工作创新研究', 'leader_name': '党建负责人A', 'topic_type': '党建课题', 'start_time': '2022-02-01', 'completion_status': '进行中', 'bonus_points': 15}
    ]
    
    # 10. 横向项目数据
    sample_data['horizontal_projects'] = [
        {'project_name': '企业合作项目A', 'leader_name': '项目负责人A', 'partner_unit': '合作企业A', 'project_amount': '30万元', 'start_time': '2022-03-01', 'bonus_points': 25}
    ]
    
    # 11. 教师出勤数据
    sample_data['teacher_attendance'] = [
        {'teacher_name': '教师A', 'meeting_name': '月度例会', 'required_attendance': 12, 'actual_attendance': 10, 'absence_count': 2, 'deduction': 4.0},
        {'teacher_name': '教师B', 'meeting_name': '学术研讨会', 'required_attendance': 8, 'actual_attendance': 7, 'absence_count': 1, 'deduction': 2.0}
    ]
    
    # 12. 论文发表数据
    sample_data['published_papers'] = [
        {'paper_title': '外语教学研究论文A', 'author_name': '作者A', 'journal_name': '外语教学期刊', 'publish_time': '2022-05-01', 'journal_level': '核心期刊', 'bonus_points': 20},
        {'paper_title': '语言学研究论文B', 'author_name': '作者B', 'journal_name': '语言学期刊', 'publish_time': '2022-07-01', 'journal_level': 'SCI', 'bonus_points': 50}
    ]
    
    # 13. 讲座数据
    sample_data['lectures'] = [
        {'lecture_topic': '外语教学方法创新', 'lecturer_name': '主讲人A', 'lecture_type': '学术讲座', 'lecture_time': '2022-04-15', 'attendance_count': 80, 'bonus_points': 10},
        {'lecture_topic': '跨文化交际研究', 'lecturer_name': '主讲人B', 'lecture_type': '专题报告', 'lecture_time': '2022-06-20', 'attendance_count': 120, 'bonus_points': 8}
    ]
    
    return sample_data

def import_table_data(supabase: Client, table_name: str, data: list):
    """导入单个表的数据"""
    if not data:
        print(f"⚠️  {table_name} 表没有数据可导入")
        return False
    
    try:
        # 清空表的现有数据
        result = supabase.table(table_name).delete().neq('id', '00000000-0000-0000-0000-000000000000').execute()
        
        # 批量插入新数据
        result = supabase.table(table_name).insert(data).execute()
        
        print(f"✅ {table_name} 表导入成功，插入了 {len(data)} 条记录")
        return True
        
    except Exception as e:
        print(f"❌ {table_name} 表导入失败: {str(e)}")
        return False

def import_all_data():
    """导入所有表的数据"""
    print("🚀 开始导入完整数据到Supabase...")
    
    # 初始化Supabase客户端
    supabase = init_supabase()
    
    # 生成示例数据
    sample_data = generate_sample_data()
    
    # 统计信息
    success_count = 0
    total_count = len(sample_data)
    total_records = 0
    
    # 逐表导入数据
    for table_name, data in sample_data.items():
        success = import_table_data(supabase, table_name, data)
        if success:
            success_count += 1
            total_records += len(data)
    
    # 显示结果统计
    print(f"\n📊 导入完成统计:")
    print(f"✅ 成功导入: {success_count}/{total_count} 个表")
    print(f"📝 总记录数: {total_records} 条")
    
    if success_count == total_count:
        print("🎉 所有表数据导入成功！")
    else:
        print("⚠️  部分表导入失败，请检查错误信息")

def test_connection():
    """测试Supabase连接"""
    try:
        supabase = init_supabase()
        # 尝试查询一个表来测试连接
        result = supabase.table('teacher_evaluations').select('*').limit(1).execute()
        print("✅ Supabase连接测试成功")
        return True
    except Exception as e:
        print(f"❌ Supabase连接测试失败: {str(e)}")
        return False

def main():
    """主函数"""
    print("=" * 60)
    print("外国语学院年终考核加分管理系统 - 数据导入工具")
    print("=" * 60)
    
    # 测试连接
    if not test_connection():
        print("请检查Supabase配置和网络连接")
        return
    
    # 导入数据
    import_all_data()
    
    print("\n🔗 数据库连接信息:")
    print(f"URL: {SUPABASE_URL}")
    print("请在Supabase控制台查看导入的数据")

if __name__ == "__main__":
    main()