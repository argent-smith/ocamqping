open Lwt

let source = Logs.Src.create "operations" ~doc:"Toplevel operations"
module Log = (val Ag_logger.create ~source : Ag_logger.LOG)

let setup_signals_handling () =
  let open Lwt_unix in
  let (_ : signal_handler_id) = on_signal Sys.sigint @@
            fun _  ->
              async (fun () -> Log.warn (fun f -> f "Caught user interruption; exiting"));
              exit 0
  in ()

let rec main amqp_uri retry_interval retry_count log_opts =
  Ag_logger.setup log_opts;
  setup_signals_handling ();
  let config = Pinger_config.create ~amqp_uri ~retry_interval ~retry_count in
  let threads = [Pinger.run config] in
  choose threads
  |> Lwt_main.run
