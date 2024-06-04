# Reeve CI / CD - Pipeline Step: SSH

This is a [Reeve](https://github.com/reeveci/reeve) step for executing remote shell scripts.

## Configuration

See the environment variables mentioned in [Dockerfile](Dockerfile).

If no script file is specified using `SCRIPT`, `input` is used to specify the commands to be executed, e.g.:

```yaml
params:
  ENV_SOME_VAR: test
input: |
  echo $SOME_VAR
  cat /etc/*-release
```
