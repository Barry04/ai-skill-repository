# Remote Operation Rules

Before executing any command:

1. Ask the user for the Linux test machine IP or hostname, SSH port, SSH username, and authentication method.

Use key-based login when the user provides a private key path.

```bash
ssh -i ~/.ssh/id_rsa -p 22 user@host "hostname"
```

2. Store repeatable connection details in a local JSON config when the host will be reused.

```json
{
  "host": "192.168.1.100",
  "port": 22,
  "user": "root",
  "identityFile": "~/.ssh/id_rsa"
}
```

Never store passwords in the config file.

3. Verify host reachability.

```bash
ping -c 1 host
```

4. Verify SSH login with the provided port and authentication method.

```bash
ssh -p port user@host "hostname"
```

5. Upload required files before running commands that depend on them.
6. Execute commands sequentially.
7. Capture stdout, stderr, exit code, and duration.
8. Never delete production files.
9. Never run destructive system commands, including:

```text
rm -rf /
shutdown
reboot
mkfs
```

10. Return an execution summary.
11. Store or collect execution logs when available.
12. Retry transient network failures up to 3 times.

If the command targets a production host or the host role is unknown, ask the user for confirmation before performing state-changing operations.
