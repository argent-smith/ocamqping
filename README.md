[![argent-smith](https://circleci.com/gh/argent-smith/ocamqping.svg?style=shield)](https://circleci.com/gh/argent-smith/ocamqping)

# OCamqping

A minimalistic AMQP server ping tool. It tries to ping the AMQP
server, then exits with zero status. If the server isn't responding it
exits with nonzero status after making a configured number of attempts.

## Dockerized binary distribution

[argentoff/ocamqping](https://hub.docker.com/repository/docker/argentoff/ocamqping)

This may be used as a stage image to get the statically linked binary from.

## Docker installation example

```dockerfile
FROM argentoff/ocamqping as ocamqping
FROM other_base_image

RUN something important

WORKDIR /app

COPY --from=ocamqping /ocamqping /sbin/

COPY . .
RUN something also important
```

## Installation from the source with OPAM

```
$ git clone https://github.com/argent-smith/ocamqping.git
$ cd ocamqping
$ opam install -y .
```

## Synopsis

`ocamqping [OPTION]...`

## Logging options
  * `-P`, `--log-process` (absent `LOG_PROCESS` env)
      Whether to add process info (name & pid) to log messages.

  * -T, --log-times (absent LOG_TIMES env)
      Whether to timestamp log messages.

## Options
  * `--help[=FMT]` (default=`auto`)
    Show this help in format FMT. The value FMT must be one of `auto`,
    `pager`, `groff` or `plain`. With `auto`, the format is `pager` or
    `plain` whenever the TERM env var is `dumb` or undefined.

  * `-i VAL`, `--retry-interval=VAL` (absent=`1` or `OCAMQPING_RETRY_INTERVAL` env)
    Ping retry interval in seconds

  * `-q`, `--quiet`
    Be quiet. Takes over `--verbosity`.

  * `-r VAL`, `--retry-count=VAL` (absent=`255` or `OCAMQPING_RETRY_COUNT` env)
    Ping retry count

  * `-u VAL`, `--amqp-uri=VAL` (absent=`amqp://localhost/` or `AMQP_URI` env)
      AMQP server URI

  * `--verbosity=LEVEL` (absent=`info` or `LOG_VERBOSITY` env)
    Be more or less verbose. LEVEL must be one of `quiet`, `error`,
    `warning`, `info` or `debug`.

  * `--version`
      Show version information.

## Environment
These environment variables affect the execution of ocamqping:

* `OCAMQPING_RETRY_COUNT` See option --retry-count.

* `OCAMQPING_RETRY_INTERVAL` — See option --retry-interval.

* `AMQP_URI` — See option --amqp-uri.

* `LOG_PROCESS` — See option --log-process.

* `LOG_TIMES` — See option --log-times.

## Contribution

Feel free to clone and contribute to this program.

## License

[MIT](LICENSE)
