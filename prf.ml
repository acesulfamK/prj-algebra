(* zero関数: 0を返す *)
let zero arg = 
        match arg with 
        | -1::[] -> -1
        | n::[] -> 0
        | _ -> let _ = print_endline "error: an arg of zero is wrong" in
                -1

(* suc関数: 後者関数、引数に1を加える *)
let suc arg = 
        match arg with 
        | -1::[] -> -1
        | n::[] -> n + 1
        | _ -> let _ = print_endline "error: an arg of suc is wrong" in
                -1

(* proj関数: 射影関数、n番目の引数を返す。ここでは0オリジンとします *)
let proj n args = 
        match args with
        | -1::[] -> -1
        | _ -> 
                if n >= List.length args then
                        let _ = print_endline "error: args of proj is wrong" in
                                -1
                else
                        List.nth args n

type exp = 
        | Z
        | S
        | P of (int)
        | Appl of ((int list -> int) * ((int list -> int) list))
        | Pr of ((int list -> int) * (int list -> int))

let trans_exp exp =
        match exp with
        | Z -> zero
        | S -> suc
        | P(n) -> proj n
        | Appl(e, li) -> 
                let f = trans_exp e in
                let li = trans_exp li in (*編集中*)
        
                
(*テストケース*)
let test1 = trans_exp Z
let test2 = trans_exp S
let test3 = trans_exp (P 1)
