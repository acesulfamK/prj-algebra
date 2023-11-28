# prj-algebra

# Overview

任意の原始再帰関数は、零関数, 後者関数, 射影関数に対して関数合成、原始再帰を繰り返し適用することによって構成される。
これは見方を変えると、原始再帰関数全体が、zero, suc, projという定数とAppl, Prという演算子(Apprの引数は有限個、Prの引数は2個)によって構成される代数をなすということである。
そこで、この見方を強調するために、Z, S, P(n)という定数とAppl, Prという演算子による代数的な式から、その意味である自然数 -> 自然数の関数を作成するソフトウェアを構成しようと思った。

# Introduction

Ocamlを用いて実装する。

# Getting Started

1. Ocaml, utop を installする
2. prf-algebraディレクトリで以下を実行する

```
> utop
> #use "prf.ml"
```

# Tutorial 

trans_exp に式を渡すことで、式の表現する自然数関数を作成することができる。
そうしてできた関数は、引数としてint list を受け取り、intを返す。

以下は2つの値の足し算を行う関数addを構成する様子である。この関数は式`Pr (P 0, Comp [S; P 0])`で表現される。
これを trans_exp で翻訳しできた関数 add は2つの値をリストとして受け取り、可算した値を返す。

```
utop #> let add = trans_exp (Pr (P 0, Comp [S; P 0]));;
val add : int list -> int = <fun>
utop #> add [3; 5];;
- : int = 8
```

# Reference

式は、expというバリアント型で表現され、これはZ, S, P, Comp, Prというフィールドを持つ。それぞれのフィールドは以下のような仕様と意味を持つ。
exp型のデータは、trans_exp関数に通すことで、そのデータの表現する自然数関数(int list -> int)に翻訳することができる。

## Z : none

`Z`は、trans_expを通すと、任意の自然数に対してゼロを返す関数となる。

**`trans_exp Z`**: int list -> int
- 引数がリスト: 0を返す。ただし、要素がただ一つで-1のときのみ-1を返す (-1はエラーを表す)。
- それ以外: エラーをprintし、-1 を返す

```
utop # let zero = trans_exp Z;;
val zero : int list -> int = <fun>
utop # zero [3];;
- : int = 0
utop # zero [3; 5];;
- : int = 0
```

## S : none

`S`は、trans_expを通すと、任意の自然数に対してその数に+1した数を返す関数となる。

**`trans_exp S`**: int list -> int
- 引数の要素が1つ: 引数の要素に+1した数を返す。ただし、要素が-1のときのみ-1を返す (-1はエラーを表す)。
- それ以外: エラーをプリントし、-1 を返す

```
utop # let suc = trans_exp S;;
val suc : int list -> int = <fun>
utop # suc [3];;
- : int = 4
```

## P : exp list

`P`は、値としてint型の数(nとする)を持ち、trans_expを通すとリストのn番目の値を返す関数となる。

**`trans_exp (P n)`**: int list -> int
- リストのn番目の値を返す。ただし、引数が[-1]のときはえらーを返す。

```
utop # let proj2 = trans_exp (P 2);;
val proj2 : int list -> int = <fun>
utop # proj2 [0,1,2,3];;
- : int = 2
```


## Comp : exp list

`Comp`は、値としてexp list 型を持ち([f, g1, g2, g3]だったとする)、trans_expを通すとfの引数リストにg1, g2, g3を関数合成した関数int list -> intを返す。

注意:
- Compの値リストのうち、先頭以外の要素(例ではg1, g2, g3)の引数の数は全て同じでなくてはいけない。

## Pr : exp * exp

`Pr`は、値としてexp * exp型を持ち(f,gだったとする)、fを基底関数、gを再帰ステップ関数と見た原始再帰の結果できる関数を表現する。

注意:
- gの表現する関数の引数の数を n とすると、fの表現する関数の引数の数は n + 2 でなくてはいけない。また、このときComp [f; g]が表現する関数の引数の数は n + 1 である。


# 参考文献

[wikipedia 原始再帰関数](https://ja.wikipedia.org/wiki/%E5%8E%9F%E5%A7%8B%E5%86%8D%E5%B8%B0%E9%96%A2%E6%95%B0#:~:text=%E5%8E%9F%E5%A7%8B%E5%86%8D%E5%B8%B0%E9%96%A2%E6%95%B0%EF%BC%88%E3%81%92%E3%82%93%E3%81%97,%E3%81%AE1%E3%81%A4%E3%81%A7%E3%81%82%E3%82%8B%E3%80%82)


[Ocaml](https://ocaml.org)
