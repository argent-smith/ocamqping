type t = {
  amqp_uri       : string;
  retry_interval : int;
  retry_count    : int
}

let create ~amqp_uri ~retry_interval ~retry_count =
  { amqp_uri; retry_interval; retry_count }
