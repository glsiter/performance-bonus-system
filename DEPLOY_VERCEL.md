# Vercel 部署指南

## 🚀 快速部署步骤

### 方法1：一键部署（推荐）

点击下面的按钮直接部署到Vercel：

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/glsiter/performance-bonus-system)

### 方法2：手动部署

1. **登录Vercel**
   - 访问 [vercel.com](https://vercel.com)
   - 使用GitHub账号登录

2. **导入项目**
   - 点击 "New Project"
   - 选择 GitHub 仓库：`glsiter/performance-bonus-system`
   - 点击 "Import"

3. **配置项目**
   - Project Name: `performance-bonus-system`
   - Framework Preset: `Other`
   - Root Directory: `./`
   - 保持其他默认设置

4. **部署**
   - 点击 "Deploy"
   - 等待部署完成（约1-2分钟）

## 📊 访问地址

部署完成后，你将获得以下访问地址：

- **主页（完整版）**: `https://your-project.vercel.app/`
- **简化版**: `https://your-project.vercel.app/simple`
- **完整版**: `https://your-project.vercel.app/complete`

## 🔧 项目配置

### Vercel配置文件
项目已包含以下配置文件：

- `vercel.json` - Vercel部署配置
- `.vercelignore` - 排除不必要的文件

### 路由配置
```json
{
  "/": "complete_system.html (默认完整版)",
  "/simple": "index.html (简化版)",
  "/complete": "complete_system.html (完整版)"
}
```

## 🌐 自定义域名

### 添加自定义域名
1. 在Vercel项目仪表板中
2. 进入 "Settings" > "Domains"
3. 添加你的域名
4. 按照提示配置DNS记录

### SSL证书
Vercel会自动为你的域名提供免费的SSL证书。

## 🔄 自动更新

### GitHub集成
- 每次推送到`main`分支都会自动触发重新部署
- 支持预览部署（PR预览）
- 实时部署日志

### 手动重新部署
1. 访问Vercel项目仪表板
2. 点击 "Deployments" 标签
3. 点击最新部署旁边的三个点
4. 选择 "Redeploy"

## 📈 性能优化

### CDN加速
- Vercel的全球CDN自动加速静态资源
- HTML、CSS、JS文件自动优化和压缩

### 缓存策略
- 静态文件自动设置缓存头
- HTML页面设置适当的缓存策略

## 🔍 监控和分析

### 访问统计
1. 在Vercel仪表板中查看访问统计
2. 查看性能指标和错误日志

### 性能监控
- Core Web Vitals监控
- 页面加载速度分析
- 用户访问地理分布

## ⚠️ 注意事项

### 文件大小限制
- 单个文件最大100MB
- 项目总大小最大100MB
- 已通过`.vercelignore`排除大文件

### 功能限制
- 免费版每月100GB带宽
- 无服务器函数执行时间10秒
- 并发执行数1000

## 🆘 故障排除

### 常见问题

1. **部署失败**
   - 检查`vercel.json`配置
   - 查看部署日志错误信息
   - 确认文件路径正确

2. **页面404错误**
   - 检查路由配置
   - 确认HTML文件存在
   - 验证文件名大小写

3. **资源加载失败**
   - 检查CDN链接可用性
   - 验证相对路径正确性

### 获取帮助
- Vercel官方文档：https://vercel.com/docs
- GitHub Issues：https://github.com/glsiter/performance-bonus-system/issues

## 🎉 部署成功

部署成功后，你的年终考核加分管理系统将在全球范围内可访问，支持：

- ⚡ 快速加载（CDN加速）
- 🔒 HTTPS安全连接
- 📱 移动端完美适配
- 🌍 全球访问优化
- 🔄 自动更新部署

享受你的在线管理系统吧！🎊