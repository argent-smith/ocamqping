module C = Configurator.V1

let env_var_name = "BUILD_STATIC_BINARY"
let result_file_name = "ocamlopt_flags.sexp"
let standard_flags = ["-O2"]
let static_flags = standard_flags @ ["-ccopt"; "-static"; "-cclib"; "-static"]

let write_standard_flags () =
  C.Flags.write_sexp result_file_name standard_flags

let write_static_flags () =
  C.Flags.write_sexp result_file_name static_flags

let write_configuration () =
  match Sys.getenv_opt env_var_name with
  | None -> write_standard_flags ()
  | Some str -> match str with
                | "true" -> write_static_flags ()
                | _ -> C.die "Bad environment variable %s" env_var_name

let () =
  let discovery _ = write_configuration () in
  C.main ~name:"build_flags_discovery" discovery
