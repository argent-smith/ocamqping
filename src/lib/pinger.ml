open Base
open Lwt
open Lwt.Infix

let source = Logs.Src.create "pinger" ~doc:"Pinger loop"
module Log = (val Ag_logger.create ~source : Ag_logger.LOG)

let ping uri =
  let open Amqp_client_lwt.Connection in
  let open Amqp_client_lwt.Thread.Deferred in
  try_with (fun () -> connect_uri ~id:"TestConnection" uri >>= close)

let run Config.({amqp_uri; retry_interval; retry_count} as config) =
  let rec loop count =
    let up_count = retry_count - count + 1 in
    let%lwt () = Log.debug (fun f -> f "Pinging %s, count %i of %i" amqp_uri up_count retry_count) in
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
  Log.debug (fun f -> f "Starting OCamqping for %a" Config.pp config)
  >>= (fun () -> loop retry_count)
