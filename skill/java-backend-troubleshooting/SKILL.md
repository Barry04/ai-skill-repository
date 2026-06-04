---
name: java-backend-troubleshooting
description: Java backend troubleshooting patterns for recurring Spring, transaction, MyBatis, pagination, and SQL behavior issues. Use when debugging Java service failures, Spring transaction rollback problems, MyBatis pagination not taking effect, or backend validation workflows.
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
