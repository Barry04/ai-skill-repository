---
name: java-backend-troubleshooting
description: >-
  MUST use for Java backend debugging and recurring Spring/MyBatis issues. Use
  when the user mentions Java 后端排错、Spring Boot、Spring 事务、事务不回滚、
  rollback 失效、@Transactional 不生效、同类调用、代理失效、MyBatis、分页失效、
  limit 不生效、SQL 被改写、Java 服务启动失败, or asks to diagnose backend logs,
  exceptions, database behavior, integration tests, or service validation.
---

# Java Backend Troubleshooting

## Purpose

Capture compact, reusable troubleshooting rules for common Java backend issues.

## Spring Transaction Rollback

Triggers:

- `事务不回滚`
- `rollback 失效`
- `@Transactional 不生效`

Rules:

- Ensure the thrown exception is a `RuntimeException` or configure rollback rules explicitly.
- Avoid same-class self-invocation because it bypasses the Spring proxy.
- Ensure the transactional method is `public`.
- Check whether transaction management is enabled.

## MyBatis Pagination Failure

Triggers:

- `分页失效`
- `limit 不生效`
- `MyBatis 分页`

Rules:

- Check whether the pagination plugin is enabled.
- Check whether the SQL was wrapped, rewritten, or executed outside the pagination interceptor path.
