open Lwt
open Lwt.Infix

exception Ping_failed

let source = Logs.Src.create "pinger" ~doc:"Pinger loop"
module Log = (val Ag_logger.create ~source : Ag_logger.LOG)

let ping uri =
  let open Amqp_client_lwt.Connection in
  let open Amqp_client_lwt.Thread.Deferred in
  try_with (fun () -> connect_uri ~id:"TestConnection" uri >>= close)

let run Pinger_config.({ amqp_uri; retry_interval; retry_count }) =
  let rec loop count =
    let%lwt result = ping amqp_uri in
    match result with
    | `Ok ()     -> Log.info (fun f -> f "Server %s successfully pinged; exiting" amqp_uri)
                    >>= (fun () -> return result)
    | `Error exn -> match count with
                    | 1 -> Log.err (fun f -> f "Ping unsuccessful: %a; exiting" Fmt.exn exn)
                           >>= (fun () -> return result)
                    | n -> Log.warn (fun f -> f "Ping unsuccessful: %a; continuing" Fmt.exn exn)
                           >>= (fun () -> Lwt_unix.sleep (Float.of_int retry_interval))
                           >>= (fun () -> loop (n - 1))
  in
  loop retry_count
