---
name: linux-test-executor
description: Allow Agent to upload files to Linux servers, execute remote SSH commands or scripts, collect logs, and validate deployment or integration test results automatically. Use when Agent needs to test Java services, Docker deployments, database integrations, health checks, or other backend changes on a remote Linux test machine.
---

# Linux Test Executor Skill

## Purpose

Use this skill to validate code or deployment changes on a remote Linux test machine.

It supports:

- Uploading files or directories to Linux servers
- Executing shell commands remotely over SSH
- Running test scripts
- Collecting logs and command output
- Analyzing exit codes and common failure patterns
- Returning structured feedback to the Agent

For command safety rules, read `references/remote-operation-rule.md` before running remote commands.

## Preferred Tooling

Use the bundled bridge script when possible:

```bash
python skill/linux-test-executor/tools/remote_runner.py \
  --config skill/linux-test-executor/assets/connection.example.json \
  --upload target/app.jar \
  --run "bash /tmp/linux-test-executor/test.sh"
```

Use a connection config file for repeatable test hosts:

```json
{
  "host": "192.168.1.100",
  "port": 22,
  "user": "root",
  "identityFile": "~/.ssh/id_rsa",
  "remoteDir": "/tmp/linux-test-executor",
  "timeout": 300,
  "retries": 3,
  "localLogDir": "logs"
}
```

Command-line arguments override config values, so Agent can keep connection details stable and change only `--upload`, `--run`, or `--log-path` per test.

Before executing remote tests, ask the user for:

- Linux test machine IP or hostname
- SSH port
- SSH username
- Authentication method: private key path or password/manual SSH session

Prefer key-based login with `--identity-file` when the user provides a private key path.

The script returns JSON with:

- `success`
- `exitCode`
- `duration`
- `stdout`
- `stderr`
- `uploads`
- `logPath`
- `summary`

Use the lower-level scripts only when a single operation is needed:

- `tools/file_uploader.py`: upload files or directories with `scp`
- `tools/ssh_executor.py`: execute one remote command with `ssh`
- `tools/log_collector.py`: download one remote log file with `scp`

## Supported Operations

### Upload File

```bash
scp local_file user@host:/target/path/
```

### Upload Directory

```bash
scp -r project user@host:/target/path/
```

### Execute Command

```bash
ssh user@host "command"
```

With a private key:

```bash
ssh -i ~/.ssh/id_rsa -p 22 user@host "command"
```

### Execute Script

```bash
ssh user@host "bash /tmp/test.sh"
```

### Download Log

```bash
scp user@host:/tmp/test.log ./
```

With a private key:

```bash
scp -i ~/.ssh/id_rsa -P 22 user@host:/tmp/test.log ./
```

## Test Workflow

1. Verify that the host is reachable.
2. Verify SSH login with the provided port and authentication method using a low-risk command such as `hostname`.
3. Upload required files such as JARs, SQL files, configs, Docker files, or shell scripts.
4. Grant execute permission when scripts are uploaded.
5. Execute the test or deployment command.
6. Capture stdout, stderr, exit code, and duration.
7. Download logs when a log path is known.
8. Analyze failures using the rules below.
9. Return a structured summary.

## Common Validation Commands

### Java Service

```bash
ps -ef | grep java
```

### Health Check

```bash
curl http://127.0.0.1:8080/actuator/health
```

### Docker

```bash
docker ps
```

### Kubernetes

```bash
kubectl get pods
```

### DM Database

```bash
disql SYSDBA/SYSDBA
```

## Error Analysis Rules

### Connection Failure

Keywords:

```text
Connection refused
No route to host
Host unreachable
```

Action:

- Check host address.
- Check firewall rules.
- Check whether the SSH service is running.

### Permission Failure

Keywords:

```text
Permission denied
```

Action:

- Check SSH key or password login.
- Check file permissions.
- Check whether the remote user has the required privileges.

### Deployment Failure

Keywords:

```text
Address already in use
Port occupied
```

Action:

- Identify the occupied port.
- Use `netstat -tunlp` or `ss -tunlp` when available.

### Java Startup Failure

Keywords:

```text
Exception
BeanCreationException
NoSuchMethodError
```

Action:

- Extract the relevant stack trace.
- Report the likely root cause.
- Include the first application exception and any caused-by chain.

## Expected Output Format

Return a JSON-compatible summary:

```json
{
  "host": "192.168.1.100",
  "operation": "integration-test",
  "success": true,
  "exitCode": 0,
  "duration": 18,
  "logPath": "/tmp/test.log",
  "summary": "test passed"
}
```
