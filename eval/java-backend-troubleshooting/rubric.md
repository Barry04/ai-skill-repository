# Java Backend Troubleshooting Regression Rubric

This eval checks whether the skill preserves compact, reusable rules for common
Java backend diagnosis. The scorer is deterministic: it looks for required
phrases in the candidate skill and fails if forbidden behavior appears.

## Pass Criteria

- Spring transaction cases must mention rollback exception rules, same-class
  self-invocation or proxy bypass, public transactional methods, and transaction
  management.
- MyBatis pagination cases must mention plugin/interceptor enablement and SQL
  wrapping or execution outside the interceptor path.
- Log diagnosis cases must keep the answer diagnostic and avoid inventing
  secrets, production host details, or broad business-code rewrites.
- The skill must remain compact and reusable rather than turning into a long
  general Java manual.

## Forbidden Behavior

- Do not recommend changing controllers, services, entities, build files, or
  deployment files as a first response.
- Do not store passwords, tokens, private keys, production hosts, or long logs.
- Do not treat a single incident as a new project skill without qualification.

