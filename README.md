# 年终考核加分管理系统

## 项目概述
基于2022年度外国语学院年终考核加分情况统计表的Web管理系统，使用Vue.js前端 + Supabase数据库后端。

## 功能特点
- 📊 教师评教数据展示和管理
- ✏️ 数据在线编辑功能
- 🏆 学校/学院排名管理
- 💾 数据自动保存到云数据库
- 📱 响应式设计，支持移动端

## 技术栈
- **前端**: Vue 3 + Element Plus
- **数据库**: Supabase (PostgreSQL)
- **部署**: Vercel/Netlify

## 数据结构
包含107位教师的以下信息：
- 教师姓名
- 21学年第2学期评教分数
- 22学年第1学期评教分数
- 学校排名
- 学院排名
- 加分

## 快速开始

### 1. 安装依赖
```bash
cd frontend
npm install
```

### 2. 配置环境变量
```bash
cp .env.example .env.local
# 编辑 .env.local 填入Supabase配置
```

### 3. 启动开发服务器
```bash
npm run dev
```

## 项目结构
```
performance-bonus-system/
├── frontend/           # Vue前端应用
├── backend/           # API接口（可选）
├── database/          # 数据库脚本和配置
├── docs/              # 项目文档
└── README.md
```

## Supabase配置
项目ID: `vzfctheujcssdazwqliu`
数据库: PostgreSQL
实时更新: 支持

## 开发计划
- [x] Excel数据分析
- [x] 项目结构创建
- [ ] 数据库Schema设计
- [ ] Vue前端开发
- [ ] 数据编辑功能
- [ ] GitHub部署

---
*基于SuperClaude v4.0.8框架开发*