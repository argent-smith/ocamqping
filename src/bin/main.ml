open Base
open Cmdliner

let info =
  let version = "%%VERSION%%"
  and doc = "A minimalistic AMQP server ping tool. It tries to \
             ping the AMQP server, then exits with zero status. \
             If the server isn't responding it exits with nonzero status \
             after making a configured number of attempts."
  in
  Term.info "ocamqping" ~version ~doc

let amqp_uri =
  let doc = "AMQP server host"
  and default = "amqp://localhost/"
  and env = Arg.env_var "AMQP_URI"
  in
  Arg.(value & opt string default & info ["u"; "amqp-uri"] ~env ~doc)

let retry_interval =
  let doc = "Ping retry interval in seconds"
  and default = 1
  and env = Arg.env_var "OCAMQPING_RETRY_INTERVAL"
  in
  Arg.(value & opt int default & info ["i"; "retry-interval"] ~env ~doc)

let retry_count =
  let doc = "Ping retry count"
  and default = 255
  and env = Arg.env_var "OCAMQPING_RETRY_COUNT"
  in
  Arg.(value & opt int default & info ["r"; "retry-count"] ~env ~doc)

let logger_config = Ag_logger.Cli.opts ()

let operation =
  Term.(
    const Operations.main
    $ amqp_uri
    $ retry_interval
    $ retry_count
    $ logger_config
  )

let () =
  let open Caml in
  match Term.eval (operation, info) with
  | `Error _ -> exit 1
  | _ -> exit 0
