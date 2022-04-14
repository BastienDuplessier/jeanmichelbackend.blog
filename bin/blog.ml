open Yocaml

let destination = "_site"
let track_binary_update = Build.watch Sys.argv.(0)

let may_process_markdown file =
  let open Build in
  if with_extension "md" file then
    Yocaml_markdown.content_to_html ()
  else arrow Fun.id
;;

let pages =
  process_files
    [ "pages" ]
    (fun f -> with_extension "html" f || with_extension "md" f)
    (fun file ->
      let fname = basename file |> into destination in
      let target = replace_extension fname "html" in
      let open Build in
      create_file
        target
        (track_binary_update
        >>> Yocaml_yaml.read_file_with_metadata (module Metadata.Page) file
        >>> may_process_markdown file
        >>> Yocaml_jingoo.apply_as_template (module Metadata.Page) "templates/layout.html"
        >>^ Stdlib.snd))
;;

let article_destination file =
  let fname = basename file |> into "articles" in
  replace_extension fname "html"
;;

let articles =
  process_files
  [ "articles" ]
  (with_extension "md")
  (fun file ->
      let target = article_destination file |> into destination in
      let open Build in
      create_file
        target
        (track_binary_update
        >>> Yocaml_yaml.read_file_with_metadata (module Metadata.Article) file
        >>> Yocaml_markdown.content_to_html ()
        >>> Yocaml_jingoo.apply_as_template
              (module Metadata.Article)
              "templates/layout.html"
        >>^ Stdlib.snd))
;;

let () = Yocaml_unix.execute (pages >> articles)
;;
