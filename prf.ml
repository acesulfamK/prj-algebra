let zero arg = 
        match arg with
        | -1::[] -> -1
        | n::ns -> 0
        | _ -> let _ = print_endline "error: an arg of zero is wrong" in
                -1

        
                

let suc arg = 
        match arg with 
        | -1::[] -> -1
        | n::[] -> n + 1
        | _ -> let _ = print_endline "error: an arg of suc is wrong" in
                -1

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
        | Comp of (exp list)
        | Pr of (exp * exp)

let rec trans_exp st =
        match st with
        | Z -> zero
        | S -> suc
        | P(n) -> proj n
        | Comp(li) -> 
                let e::es = li in
                let f = trans_exp e in
                let gs = List.map trans_exp es in
                let rec function_prod fs x = 
                          match fs with
                          | [] -> []
                          | ff :: ffs -> 
                              let result = ff x in 
                              result :: (function_prod ffs x)  
                          | _ -> 
                              let _ = print_endline "error: length of function prod args is not equal" in
                              [-1]  (* エラー処理 *)
                in
                fun x -> f (function_prod gs x)
        | Pr(e1, e2) ->
                let f = trans_exp e1 in
                let g = trans_exp e2 in
                let rec h args =
                        match args with
                        | 0::xs -> f xs
                        | n::xs -> 
                                if n > 0 then 
                                        g ((h ((n-1)::xs))::([n-1]@xs))
                                else 
                                        let _ = print_endline "error: arg n in Pr is negative" in
                                                -1
                        | _ -> let _ = print_endline "error: args of Pr are wrong" in
                                -1
                in
                fun args -> h args

                
        
                
(*テストケース*)
let test1 = Z (* zero function*)
let test2 = S (* suc function *)
let test3 = P 1 (* projection func to the 2nd var *)
let test4 = Comp [S; S] (* plus 2 *)
let test6 = P 0 (* id func *)
let test7 = Pr (P 0, Comp [S; P 0]) (* add *)
let test8 = Pr (Z, Comp[Pr (P 0, Comp [S; P 0]); P 0; P 2]) (* mul *)
let test9 = Comp [Pr (Comp[S; Z], Comp[Pr (Z, Comp[Pr(P 0, Comp [S; P 0]); P 0; P 2]); P 0; P 2]); P 1; P 0] (* pow *)
let test10 = Pr (P 0, P 1) (* sub 1 (if x == 0 then 0) *)
let add = trans_exp test7
let mul = trans_exp test8
let pow = trans_exp test9
