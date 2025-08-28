# Supabase 数据库设置指南

## 🗄️ 数据库配置步骤

### 1. 登录 Supabase
1. 访问 [supabase.com](https://supabase.com)
2. 登录你的账户
3. 进入项目：`vzfctheujcssdazwqliu`

### 2. 创建数据库表结构
1. 在 Supabase 仪表板中，点击左侧菜单的 "SQL Editor"
2. 创建新查询
3. 复制 `database-schema.sql` 文件中的所有内容
4. 粘贴到 SQL Editor 中
5. 点击 "Run" 执行 SQL 语句

### 3. 验证表创建
执行完成后，应该看到以下10个表被创建：

- `student_evaluation` (学生评教)
- `management_evaluation` (管理人员服务对象打分)
- `class_adjustment` (调停课)
- `student_projects` (指导学生项目统计)
- `school_projects` (校级项目统计)
- `awards` (获奖统计)
- `student_awards` (学生获奖)
- `teacher_attendance` (教师参会扣分情况)
- `publications` (发表论文)
- `lectures` (讲座)

### 4. 配置 RLS (Row Level Security)
所有表都已启用 RLS 并配置了允许所有操作的策略，适合管理系统使用。

## 🔧 API 配置信息

### 连接信息
- **Supabase URL**: `https://vzfctheujcssdazwqliu.supabase.co`
- **API Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6ZmN0aGV1amNzc2RhendxbGl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNDc3OTgsImV4cCI6MjA3MTkyMzc5OH0.XKm2enTM14LDwHU_Yz7IT5FOvr3eCGClINZTvdSDgds`

### 安全配置
- API Key 为匿名访问密钥 (anon key)
- 已配置 RLS 策略允许所有 CRUD 操作
- 适合内部管理系统使用

## 📊 数据库功能特性

### 自动化功能
1. **自动时间戳**: 每个表都有 `created_at` 和 `updated_at` 字段
2. **自动更新**: 数据更新时自动更新 `updated_at` 字段
3. **数据验证**: 使用 PostgreSQL 约束确保数据完整性

### 性能优化
1. **索引优化**: 为常用查询字段创建了索引
2. **时间戳索引**: 支持快速的时间范围查询
3. **外键关联**: 维护数据关系完整性

### 数据完整性
1. **字段验证**: 设置了适当的数据类型和约束
2. **枚举检查**: 对选择字段使用 CHECK 约束
3. **非空约束**: 对必填字段设置 NOT NULL

## 🌐 访问地址

部署完成后可通过以下地址访问：

- **主页（Supabase版）**: `https://your-project.vercel.app/`
- **云端版本**: `https://your-project.vercel.app/cloud`
- **可编辑版（本地存储）**: `https://your-project.vercel.app/editable`
- **简化版**: `https://your-project.vercel.app/simple`
- **完整版**: `https://your-project.vercel.app/complete`

## 🔄 数据迁移

### 从本地存储迁移到 Supabase
如果你之前使用了本地存储版本 (editable_system.html)，可以：

1. 访问本地存储版本，导出每个工作表的数据
2. 在 Supabase 版本中使用批量导入功能
3. 验证数据迁移完整性

### 数据备份
建议定期从 Supabase 仪表板导出数据备份：

1. 进入 Supabase 项目仪表板
2. 选择 "Database" → "Backups"
3. 创建手动备份或设置自动备份

## 🚨 故障排除

### 常见问题

1. **数据库连接失败**
   - 检查 API Key 是否正确
   - 确认网络连接正常
   - 验证 Supabase 项目状态

2. **表不存在错误**
   - 确认已执行 `database-schema.sql`
   - 检查表名拼写是否正确
   - 验证 RLS 策略配置

3. **数据保存失败**
   - 检查必填字段是否填写完整
   - 验证数据格式是否符合要求
   - 确认网络连接稳定

4. **权限错误**
   - 检查 RLS 策略配置
   - 确认 API Key 权限范围

### 调试技巧
1. 打开浏览器开发者工具查看 Console 错误信息
2. 在 Supabase 仪表板的 "Logs" 中查看详细错误
3. 使用 SQL Editor 直接测试数据库查询

## 📈 性能优化建议

### 查询优化
1. 使用索引字段进行搜索和排序
2. 限制查询结果数量，使用分页
3. 避免查询不必要的字段

### 网络优化
1. 批量操作减少网络请求
2. 使用 Supabase 实时功能监听数据变化
3. 适当使用客户端缓存

## 🔒 安全建议

### 生产环境配置
1. 创建专门的服务角色和权限
2. 配置更精细的 RLS 策略
3. 启用审计日志记录
4. 定期轮换 API 密钥

### 数据保护
1. 定期备份重要数据
2. 设置数据访问监控
3. 实施数据脱敏策略
4. 配置访问 IP 白名单

## 📞 获取支持

- Supabase 官方文档：https://supabase.com/docs
- 项目 GitHub Issues：https://github.com/glsiter/performance-bonus-system/issues
- Supabase 社区：https://github.com/supabase/supabase/discussions

---

🎉 **完成数据库设置后，你的年终考核管理系统将支持：**

- ☁️ **云端存储**：数据安全存储在 PostgreSQL 数据库
- 🔄 **实时同步**：多设备数据实时同步
- 📊 **数据分析**：强大的 SQL 查询和分析能力
- 🔒 **安全可靠**：企业级数据库安全保障
- 📱 **随时访问**：通过网络随时随地访问数据

祝使用愉快！🎊