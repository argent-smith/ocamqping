open Base
open Lwt

let source = Logs.Src.create "operations" ~doc:"Toplevel operations"
module Log = (val Ag_logger.create ~source : Ag_logger.LOG)

let setup_signals_handling () =
  let open Lwt_unix in
  let (_ : signal_handler_id) = on_signal Caml.Sys.sigint @@
    fun _ ->
      async (fun () -> Log.warn (fun f -> f "Caught user interruption; exiting"));
      Caml.exit 0
  in ()

let rec main amqp_uri retry_interval retry_count log_config =
  Ag_logger.setup log_config;
  setup_signals_handling ();
  let config = Config.create ~amqp_uri ~retry_interval ~retry_count in
  [Pinger.run config]
  |> choose
  |> Lwt_main.run
