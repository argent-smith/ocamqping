type t = {
  amqp_uri       : string;
  retry_interval : int;
  retry_count    : int
}

let create ~amqp_uri ~retry_interval ~retry_count =
  { amqp_uri; retry_interval; retry_count }

let pp ppf { amqp_uri; retry_interval; retry_count } =
  Fmt.pf ppf "uri: %s; retry %i times after each %is" amqp_uri retry_count retry_interval
