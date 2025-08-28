#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
数据导入脚本
将Excel分析结果导入到Supabase数据库
"""

import pandas as pd
import json
import os
from supabase import create_client, Client
import sys

# Supabase配置
SUPABASE_URL = "https://vzfctheujcssdazwqliu.supabase.co"
SUPABASE_KEY = "your-supabase-service-role-key"  # 需要替换为实际的service role key

def connect_supabase():
    """连接Supabase"""
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
        print("✅ Supabase连接成功")
        return supabase
    except Exception as e:
        print(f"❌ Supabase连接失败: {e}")
        return None

def import_teacher_data(supabase: Client):
    """导入教师评教数据"""
    print("\n📊 开始导入教师评教数据...")
    
    try:
        # 读取分析结果中的CSV文件
        csv_path = "../analysis_results/data.csv"
        if not os.path.exists(csv_path):
            print(f"❌ 找不到数据文件: {csv_path}")
            return False
        
        df = pd.read_csv(csv_path)
        print(f"📄 读取到 {len(df)} 条记录")
        
        # 数据清洗和转换
        teachers_data = []
        for index, row in df.iterrows():
            if index == 0:  # 跳过标题行
                continue
                
            # 处理数据
            teacher_record = {
                "teacher_name": str(row.iloc[1]).strip() if pd.notna(row.iloc[1]) else None,
                "semester1_score": float(row.iloc[2]) if pd.notna(row.iloc[2]) and str(row.iloc[2]).replace('.', '').isdigit() else None,
                "semester2_score": float(row.iloc[3]) if pd.notna(row.iloc[3]) and str(row.iloc[3]).replace('.', '').isdigit() else None,
                "school_rank": int(row.iloc[4]) if pd.notna(row.iloc[4]) and str(row.iloc[4]).isdigit() else None,
                "college_rank": int(row.iloc[5]) if pd.notna(row.iloc[5]) and str(row.iloc[5]).isdigit() else None,
                "bonus_points": int(row.iloc[6]) if pd.notna(row.iloc[6]) and str(row.iloc[6]).isdigit() else 30
            }
            
            # 只保留有效的教师记录
            if teacher_record["teacher_name"] and teacher_record["teacher_name"] != "nan":
                teachers_data.append(teacher_record)
        
        print(f"🔄 处理后有效记录: {len(teachers_data)} 条")
        
        if not teachers_data:
            print("❌ 没有有效的教师数据可导入")
            return False
        
        # 批量插入数据
        result = supabase.table('teacher_performance').insert(teachers_data).execute()
        
        if result.data:
            print(f"✅ 成功导入 {len(result.data)} 条教师记录")
            return True
        else:
            print("❌ 数据导入失败")
            return False
            
    except Exception as e:
        print(f"❌ 导入教师数据时发生错误: {e}")
        return False

def import_project_data(supabase: Client):
    """导入学生项目数据（示例数据）"""
    print("\n📚 开始导入学生项目数据...")
    
    try:
        # 示例项目数据
        projects_data = [
            {
                "project_type": "学科竞赛",
                "project_name": "全国大学生英语竞赛",
                "project_leader": "张同学",
                "supervisor": "刘玥",
                "start_date": "2022-03-01",
                "end_date": "2022-06-30"
            },
            {
                "project_type": "学科竞赛",
                "project_name": "外研社杯英语演讲比赛",
                "project_leader": "李同学",
                "supervisor": "许婷芳",
                "start_date": "2022-04-01",
                "end_date": "2022-07-15"
            },
            {
                "project_type": "大创",
                "project_name": "基于AI的英语学习辅助系统",
                "project_leader": "王同学",
                "supervisor": "李群英",
                "start_date": "2022-01-01",
                "end_date": None  # 进行中
            },
            {
                "project_type": "学科竞赛",
                "project_name": "全国口译大赛",
                "project_leader": "赵同学",
                "supervisor": "RUBEN CASTILLA SANCHEZ",
                "start_date": "2022-05-01",
                "end_date": "2022-08-30"
            },
            {
                "project_type": "大创",
                "project_name": "多语言文化交流平台",
                "project_leader": "陈同学",
                "supervisor": "谢杭航",
                "start_date": "2022-02-01",
                "end_date": None  # 进行中
            }
        ]
        
        # 批量插入数据
        result = supabase.table('student_projects').insert(projects_data).execute()
        
        if result.data:
            print(f"✅ 成功导入 {len(result.data)} 个项目记录")
            return True
        else:
            print("❌ 项目数据导入失败")
            return False
            
    except Exception as e:
        print(f"❌ 导入项目数据时发生错误: {e}")
        return False

def create_tables(supabase: Client):
    """创建数据库表（如果不存在）"""
    print("\n🔧 检查并创建数据库表...")
    
    try:
        # 读取SQL schema文件
        schema_path = "schema.sql"
        if not os.path.exists(schema_path):
            print(f"❌ 找不到schema文件: {schema_path}")
            return False
        
        with open(schema_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        
        print("📝 请手动在Supabase SQL编辑器中执行以下SQL语句:")
        print("=" * 50)
        print(sql_content)
        print("=" * 50)
        
        input("\n按回车键继续...")
        return True
        
    except Exception as e:
        print(f"❌ 读取schema文件时发生错误: {e}")
        return False

def main():
    """主函数"""
    print("🚀 年终考核加分管理系统 - 数据导入工具")
    print("=" * 50)
    
    # 检查Supabase配置
    if SUPABASE_KEY == "your-supabase-service-role-key":
        print("⚠️  请先配置正确的Supabase Service Role Key")
        print("1. 登录 https://supabase.com/dashboard")
        print("2. 选择项目 vzfctheujcssdazwqliu")
        print("3. 在Settings > API中找到service_role key")
        print("4. 替换脚本中的 SUPABASE_KEY 变量")
        return
    
    # 连接Supabase
    supabase = connect_supabase()
    if not supabase:
        return
    
    # 创建表结构
    if not create_tables(supabase):
        return
    
    # 导入数据
    success_count = 0
    
    # 导入教师数据
    if import_teacher_data(supabase):
        success_count += 1
    
    # 导入项目数据
    if import_project_data(supabase):
        success_count += 1
    
    # 总结
    print(f"\n📊 数据导入完成: {success_count}/2 个数据表导入成功")
    
    if success_count == 2:
        print("🎉 所有数据导入成功！现在可以启动前端应用了")
        print("💡 下一步: cd frontend && npm run dev")
    else:
        print("⚠️  部分数据导入失败，请检查错误信息")

if __name__ == "__main__":
    main()