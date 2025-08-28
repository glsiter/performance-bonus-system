# 年终考核加分管理系统

## 🎯 项目概述
基于2022年度外国语学院年终考核加分情况统计表的完整Web管理系统，包含Vue.js前端应用和独立HTML页面版本。

## ✨ 主要功能
- 📊 **教师评教数据管理** - 107位教师的评教分数、排名和加分信息
- 📚 **学生项目管理** - 学科竞赛和大创项目的完整信息管理
- 🔍 **智能搜索筛选** - 支持多条件搜索和筛选
- 📱 **响应式设计** - 完美适配桌面和移动设备
- 💾 **数据导出** - 支持CSV格式数据导出
- ⚡ **实时交互** - 流畅的用户交互体验

## 🛠️ 技术架构

### 版本1：Vue.js应用 (推荐)
- **前端**: Vue 3 + Element Plus + Vite
- **数据库**: Supabase (PostgreSQL)
- **部署**: Vercel/Netlify + GitHub Pages
- **特点**: 生产级应用，支持云端数据存储

### 版本2：独立HTML页面
- **技术**: 原生HTML + CSS + JavaScript
- **数据**: 本地JSON数据模拟
- **部署**: 任意静态服务器
- **特点**: 轻量级，可离线使用

## 🚀 快速开始

### 方法1：使用独立HTML页面（即时体验）
```bash
# 直接打开页面
open index.html
# 或在浏览器中访问
http://localhost:3000/index.html
```

### 方法2：使用Vue应用（完整功能）
```bash
# 安装依赖
cd frontend
npm install

# 配置环境变量
cp .env.example .env.local
# 编辑 .env.local 填入Supabase配置

# 启动开发服务器
npm run dev
```

## 📁 项目结构
```
performance-bonus-system/
├── index.html              # 🌟 独立HTML页面版本
├── frontend/               # Vue.js应用
│   ├── src/
│   │   ├── views/         # 页面组件
│   │   ├── components/    # 通用组件
│   │   ├── api/          # API接口
│   │   └── stores/       # 状态管理
│   ├── package.json
│   └── vite.config.js
├── database/              # 数据库相关
│   ├── schema.sql        # 数据库结构
│   └── import_data.py    # 数据导入脚本
├── docs/                 # 文档
│   └── DEPLOYMENT.md     # 部署指南
└── analysis_results/     # Excel分析结果
    ├── data.csv
    ├── data.json
    └── analysis_report.md
```

## 🎨 功能截图说明

### 📊 系统首页
- 统计数据概览（教师数量、项目数量、平均分数）
- 快速导航入口
- 功能模块介绍

### 👥 教师评教管理
- 数据表格展示（姓名、评教分数、排名、加分）
- 搜索筛选（按姓名、排名范围、分数区间）
- 添加/编辑/删除操作
- 数据导出功能
- 分数标签化显示（95分以上绿色，90-94黄色，90以下红色）

### 📚 学生项目管理
- 项目类型管理（学科竞赛/大创）
- 项目状态跟踪（进行中/已结项）
- 指导教师信息
- 时间管理（立项时间/结项时间）
- 批量数据操作

## 🔧 配置说明

### Supabase数据库配置（Vue版本）
1. 登录 [Supabase](https://supabase.com/dashboard/project/vzfctheujcssdazwqliu)
2. 执行 `database/schema.sql` 创建表结构
3. 获取API密钥并配置环境变量

### HTML页面配置
- 无需配置，直接打开即可使用
- 数据存储在浏览器本地（localStorage）
- 预置了真实的教师评教数据

## 📊 数据说明

### 教师评教数据
- **来源**: 2022年度外国语学院专职教师评教分数统计
- **字段**: 教师姓名、21学年第2学期评教分数、22学年第1学期评教分数、学校排名、学院排名、加分
- **记录数**: 107条真实数据

### 学生项目数据
- **类型**: 学科竞赛、大创项目
- **字段**: 项目类型、项目名称、项目负责人、指导老师、立项时间、结项时间
- **状态**: 进行中/已结项

## 🌐 部署方案

### GitHub Pages（推荐HTML版本）
```bash
# 提交代码到GitHub
git add .
git commit -m "Update HTML version"
git push origin main

# 在GitHub仓库设置中启用Pages
```

### Vercel部署（Vue版本）
1. 连接GitHub仓库到Vercel
2. 设置环境变量（Supabase配置）
3. 自动部署

### 本地服务器
```bash
# 使用Python简单服务器
python -m http.server 3000

# 使用Node.js服务器
npx serve .
```

## 📈 功能特点

### 🎯 用户体验
- **直观界面**: 清晰的数据展示和操作流程
- **响应速度**: 优化的加载性能和交互响应
- **移动适配**: 完美支持手机和平板设备
- **无障碍**: 支持键盘导航和屏幕阅读器

### 🔒 数据安全
- **本地存储**: HTML版本数据存储在本地
- **云端备份**: Vue版本支持Supabase云端存储
- **导出功能**: 随时导出数据进行备份

### ⚡ 性能优化
- **轻量设计**: HTML版本无依赖，加载迅速
- **懒加载**: 大数据量时的分页和虚拟滚动
- **缓存策略**: 智能缓存提升用户体验

## 🔗 相关链接
- **GitHub仓库**: https://github.com/glsiter/performance-bonus-system
- **Supabase项目**: vzfctheujcssdazwqliu
- **在线演示**: [待部署]

## 👥 开发团队
- **项目开发**: Claude Code AI Assistant
- **数据来源**: 2022年度外国语学院年终考核统计
- **技术支持**: SuperClaude v4.0.8 Framework

## 📄 许可证
MIT License - 可自由使用和修改

---

🤖 **Generated with [Claude Code](https://claude.ai/code)**

**Co-Authored-By**: Claude <noreply@anthropic.com>