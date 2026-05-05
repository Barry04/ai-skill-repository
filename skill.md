# Project Skills

## [事务不回滚]
trigger: 事务不回滚, rollback 失效

content:
- 异常必须是 RuntimeException
- 同类调用不会触发事务（需走代理）
- 方法必须是 public
- 检查是否开启事务管理

---

## [MyBatis 分页失效]
trigger: 分页失效, limit 不生效

content:
- 检查分页插件是否启用
- SQL 是否被二次封装或改写
