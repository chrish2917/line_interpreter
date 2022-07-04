type id = string

type binop = Plus | Minus | Times | Div

type stm = CompoundStm of stm * stm
         | AssignStm of id * exp
         | PrintStm of exp list
and exp = IdExp of id
        | NumExp of int
        | OpExp of exp * binop * exp
        | EseqExp of stm * exp

type entry = {key : id; value : int;}

type table = entry list

let prog =
 CompoundStm(AssignStm("a", OpExp(NumExp 5, Plus, NumExp 3)),
  CompoundStm(AssignStm("b",
      EseqExp(PrintStm[IdExp"a"; OpExp(IdExp"a", Minus,NumExp 1)],
           OpExp(NumExp 10, Times, IdExp"a"))),
              PrintStm[IdExp "b"]))

let prog2 = AssignStm("a", IdExp "3")

let rec map f = function
  | [] -> []
  | h :: t -> (f h) :: map f t

let max (a : int) (b : int) = if (a > b) then a else b

let rec max_list m = function
  | [] -> 0
  | h :: t -> max_list (max h m) t   

let rec size_list acc = function
  | [] -> acc
  | _ :: t -> size_list (acc + 1) t
 
let rec maxargs = function
  | CompoundStm (s, s') -> max (maxargs s) (maxargs s')
  | AssignStm (i, e) -> parse_exp e
  | PrintStm (l) -> max (max_list 0 (map parse_exp l)) (size_list 0 l)

and parse_exp = function
  | OpExp (e, b, e') -> parse_exp e
  | EseqExp (s, e) -> max (parse_exp e) (maxargs s)
  | _ -> 0

let snd (_, y) = y
let fst (x, _) = x

let rec lookup (l : table) (i : id) : int =
  match l with
  | [] -> 0
  | h :: t -> if (i = h.key) then h.value else lookup t i

let update (t : table) (e : entry) : table = e :: t

let rec interpStm (s : (stm * table)) : table =
  match s with
  | (CompoundStm (st, st'), tb1) ->
    let tb2 = (interpStm (st, tb1)) in (interpStm (st', (tb2)))  
  | (AssignStm (i, e), tb1) ->
    let pair = (interpExp (e, tb1)) in
    let ent = {key = i; value = fst pair} in 
      update (snd pair) (ent)
  | (PrintStm l, tb1) -> match l with
    | h :: t -> let pair = interpExp(h, tb1) in Printf.printf "%d" (fst pair)
    | [] -> snd s 

and interpExp : (exp * table) -> (int * table) = function
  | (NumExp (n), t) -> (n, t)
  | (IdExp (i), t) -> (lookup t i, t)
  | (EseqExp (s, e), t) ->
    let s1 = interpStm (s, t) in interpExp (e, s1)
  | (OpExp (e, b, e'), t) ->
      let e1 = interpExp (e, t) in
      let e2 = interpExp (e', (snd e1)) in
    match b with
    | Plus ->
      ((fst e1 + fst e2), snd e2)
    | Minus -> 
      ((fst e1 - fst e2), snd e2)
    | Times ->
      ((fst e1 * fst e2), snd e2)
    | Div ->
      ((fst e1 / fst e2), snd e2) 

