# tf-workflow

Terraform/Terragrunt workflow safety hooks for Claude Code.

Ensures AWS credentials are configured before running `terraform` or `terragrunt` commands, preventing accidental execution without proper authentication.

## Installation

```
/plugin marketplace add daichitomita/tf-workflow
```

## What it does

This plugin adds a `PreToolUse` hook that intercepts any `terraform` or `terragrunt` command and checks for valid AWS credentials before execution.

The hook verifies one of the following:

- `AWS_PROFILE` environment variable is set
- Both `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are set

If no credentials are found, the command is denied with an error message.

## Local testing

```bash
claude --plugin-dir /path/to/tf-workflow
```

## License

MIT
