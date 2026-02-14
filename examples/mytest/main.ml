open Brr
open Brr_lwd
open Lwd_infix

let ui =
  let v = Lwd.var true in
  let click= Elwd.handler Ev.click (fun _ -> Lwd.update (not) v) in
  let button = Elwd.button ~ev:[`P click] [`P(El.txt' "Salut")] in
  let at1 =
    let$ b = Lwd.get v in
    if b then
      At.name (Jstr.v "name1")
    else
      At.title (Jstr.v "title1")
  in
  let at2 =
    let$ b = Lwd.get v in
    if not b then
      At.name (Jstr.v "name2")
    else
      At.title (Jstr.v "title2")
  in
  let el =
    Elwd.div ~at:[`R at1; `R at2] [
      `P (El.txt' "Try clicking the button and see how the attributes change.");
    ]
  in
  Elwd.div [
    `R el; `R button
  ]

let () =
  let ui = Lwd.observe ui in
  let on_invalidate _ =
    Console.(log [str "on invalidate"]);
    let _ : int =
      G.request_animation_frame @@ fun _ ->
      let _ui = Lwd.quick_sample ui in
      (*El.set_children (Document.body G.document) [ui]*)
      ()
    in
    ()
  in
  let on_load _ =
    Console.(log [str "onload"]);
    El.append_children (Document.body G.document) [Lwd.quick_sample ui];
    Lwd.set_on_invalidate ui on_invalidate
  in
  ignore (Ev.listen Ev.dom_content_loaded on_load (Window.as_target G.window));
  ()
