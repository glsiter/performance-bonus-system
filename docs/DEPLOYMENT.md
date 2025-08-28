# 部署指南

## 系统架构
```
前端 (Vue.js) → Supabase (PostgreSQL) → GitHub Pages/Vercel
```

## 1. Supabase数据库设置

### 1.1 创建数据库表
1. 访问 [Supabase Dashboard](https://supabase.com/dashboard/project/vzfctheujcssdazwqliu)
2. 进入 SQL Editor
3. 复制并执行 `database/schema.sql` 中的SQL语句

### 1.2 获取API密钥
1. 在Supabase项目中，进入 `Settings > API`
2. 复制以下密钥：
   - `Project URL`: `https://vzfctheujcssdazwqliu.supabase.co`
   - `anon public` key: 用于前端
   - `service_role` key: 用于数据导入（保密）

### 1.3 导入初始数据
```bash
cd database
pip install supabase pandas
python import_data.py
```

## 2. 前端应用部署

### 2.1 本地开发
```bash
cd frontend
npm install
cp .env.example .env.local
# 编辑 .env.local，填入实际的Supabase配置
npm run dev
```

### 2.2 生产构建
```bash
npm run build
```

### 2.3 部署到Vercel
1. 将代码推送到GitHub
2. 在 [Vercel](https://vercel.com) 中导入项目
3. 设置环境变量：
   - `VITE_SUPABASE_URL`: Supabase项目URL
   - `VITE_SUPABASE_ANON_KEY`: Supabase匿名密钥

## 3. GitHub Pages部署（静态版本）

### 3.1 配置GitHub Actions
创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v2
      
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18'
        
    - name: Install dependencies
      run: |
        cd frontend
        npm install
        
    - name: Build
      env:
        VITE_SUPABASE_URL: ${{ secrets.VITE_SUPABASE_URL }}
        VITE_SUPABASE_ANON_KEY: ${{ secrets.VITE_SUPABASE_ANON_KEY }}
      run: |
        cd frontend
        npm run build
        
    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: frontend/dist
```

### 3.2 设置GitHub Secrets
在GitHub仓库设置中添加：
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 4. 域名和SSL

### 4.1 自定义域名
- Vercel: 在项目设置中添加自定义域名
- GitHub Pages: 在仓库设置中配置自定义域名

### 4.2 SSL证书
- Vercel: 自动提供SSL证书
- GitHub Pages: 自动提供SSL证书

## 5. 数据库备份

### 5.1 自动备份
Supabase提供自动备份功能：
- 每日备份保留7天
- 可在Dashboard中手动创建备份

### 5.2 数据导出
```bash
# 导出教师数据
curl -X GET 'https://vzfctheujcssdazwqliu.supabase.co/rest/v1/teacher_performance' \
-H "apikey: YOUR_ANON_KEY" \
-H "Authorization: Bearer YOUR_ANON_KEY"

# 导出项目数据
curl -X GET 'https://vzfctheujcssdazwqliu.supabase.co/rest/v1/student_projects' \
-H "apikey: YOUR_ANON_KEY" \
-H "Authorization: Bearer YOUR_ANON_KEY"
```

## 6. 监控和日志

### 6.1 Supabase监控
- 在Dashboard中查看数据库使用情况
- 监控API请求数量和响应时间

### 6.2 前端错误监控
可集成Sentry或其他错误监控服务：

```javascript
// main.js
import * as Sentry from "@sentry/vue"

Sentry.init({
  app,
  dsn: "YOUR_SENTRY_DSN",
})
```

## 7. 安全配置

### 7.1 Row Level Security (RLS)
在Supabase中启用行级安全：

```sql
-- 启用RLS
ALTER TABLE teacher_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_projects ENABLE ROW LEVEL SECURITY;

-- 允许匿名读取
CREATE POLICY "Allow anonymous read access" ON teacher_performance
  FOR SELECT USING (true);

CREATE POLICY "Allow anonymous read access" ON student_projects
  FOR SELECT USING (true);
```

### 7.2 API速率限制
Supabase自带API速率限制，免费版本：
- 每小时500个请求
- 每分钟60个请求

## 8. 性能优化

### 8.1 数据库索引
在Supabase SQL编辑器中创建索引：

```sql
-- 教师姓名索引
CREATE INDEX IF NOT EXISTS idx_teacher_name ON teacher_performance(teacher_name);

-- 排名索引
CREATE INDEX IF NOT EXISTS idx_school_rank ON teacher_performance(school_rank);
CREATE INDEX IF NOT EXISTS idx_college_rank ON teacher_performance(college_rank);

-- 项目类型索引
CREATE INDEX IF NOT EXISTS idx_project_type ON student_projects(project_type);
```

### 8.2 前端缓存
配置Vite构建优化：

```javascript
// vite.config.js
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue', 'vue-router', 'pinia'],
          ui: ['element-plus']
        }
      }
    }
  }
})
```

## 9. 故障排除

### 9.1 常见问题
- **数据库连接失败**: 检查API密钥是否正确
- **CORS错误**: 确保域名在Supabase中配置
- **构建失败**: 检查环境变量是否设置

### 9.2 日志查看
- Vercel: 在Vercel Dashboard查看构建和运行时日志
- Supabase: 在Dashboard查看数据库日志

## 10. 维护清单

### 10.1 定期任务
- [ ] 每月检查数据库使用情况
- [ ] 每季度更新依赖包
- [ ] 每半年检查安全更新

### 10.2 备份验证
- [ ] 每月验证自动备份可用性
- [ ] 每季度执行完整恢复测试

---

*部署完成后，访问应用URL即可使用年终考核加分管理系统*