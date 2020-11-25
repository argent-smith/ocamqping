# amqping

A minimal AMQP server ping tool. It tries to ping the AMQP
server, then exits with zero status. If the server isn't responding it
exits with nonzero status after making a configured number of attempts.

## Installation from the source with OPAM

```
$ git clone https://github.com/argent-smith/amqping.git
$ cd amqping
$ opam install -y .
```

## Synopsis

`amqping [OPTION]...`

## Logging options
  * -P, --log-process (absent LOG_PROCESS env)
      Whether to add process info (name & pid) to log messages.

  * -T, --log-times (absent LOG_TIMES env)
      Whether to timestamp log messages.

## Options
  * --help[=FMT] (default=auto)
    Show this help in format FMT. The value FMT must be one of `auto`,
    `pager`, `groff` or `plain`. With `auto`, the format is `pager` or
    `plain` whenever the TERM env var is `dumb` or undefined.

  * -i VAL, --retry-interval=VAL (absent=1 or AMQPING_RETRY_INTERVAL env)
    Ping retry interval in seconds

  * -r VAL, --retry-count=VAL (absent=255 or AMQPING_RETRY_COUNT env)
    Ping retry count

  * -u VAL, --amqp-uri=VAL (absent=amqp://localhost/ or AMQP_URI env)
      AMQP server host

  * --version
      Show version information.

## Environment
These environment variables affect the execution of amqping:

* `AMQPING_RETRY_COUNT` See option --retry-count.

* `AMQPING_RETRY_INTERVAL` — See option --retry-interval.

* `AMQP_URI` — See option --amqp-uri.

* `LOG_PROCESS` — See option --log-process.

* `LOG_TIMES` — See option --log-times.

## Contribution

Feel free to clone and contribute to this program.

## License

[MIT](LICENSE)
