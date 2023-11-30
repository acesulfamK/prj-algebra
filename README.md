# prj-algebra

# Overview

様々な自然数の関数を、`Z`, `S`, `P n`, `Comp []`, `Pr (,)`という5つのパーツを組み合わせて表すことができる。
例えば、`Pr (P 0, Comp [S; P 0])`は2つの自然数を足す関数を表す。
`Pr (Z, Comp[Pr (P 0, Comp [S; P 0]); P 0; P 2])`は2つの数の積を返す関数を表す。

# Introduction


任意の原始再帰関数は、零関数, 後者関数, 射影関数に対して関数合成、原始再帰を繰り返し適用することによって構成される。
これは見方を変えると、原始再帰関数全体が、zero, suc, projという定数とComp, Prという演算子(Apprの引数は有限個、Prの引数は2個)によって構成される代数をなすということである。
そこで、この見方を強調するために、Z, S, P(n)という定数とComp, Prという演算子による代数的な式から、その意味である自然数 -> 自然数の関数を作成するソフトウェアを構成しようと思った。

実装はOcamlを用いた。

# Getting Started

1. Ocaml, utop を installする

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install ocaml
opam init
eval `opam config env`
opam install utop
```

3. リポジトリをクローンする

```
sudo apt-get update
sudo apt-get install git
git clone https://github.com/acesulfamK/prj-algebra.git
```

2. prf-algebra上でutopを開き、prf.mlを実行する。

```
> cd prj-algebra
> utop
> #use "prf.ml"
```

# Tutorial 

## 自然数関数をZ, S, P n, Comp, Pr で表現する (exp型リテラル)

prf.mlでは、`Z`, `S`, `P n`, `Comp []`, `Pr (,)` という記号を組み合わせて様々な自然数関数を表すことができる。
例えば、`Pr (P 0, Comp [S; P 0])`は2つの自然数を足す関数を表す。
例えば、`Pr (Z, Comp[Pr (P 0, Comp [S; P 0]); P 0; P 2])`は2つの数の積を返す関数を表す。

このように`Z`, `S`, `P n`, `Comp []`, `Pr (,)` を組み合わせて作られた式をexp型リテラルと呼ぶ。
例えば、先ほどの`Pr (P 0, Comp [S; P 0])`はexp型リテラルである。


## exp型リテラルの実体化

exp型リテラルを実際の関数に変換するには、prf.mlで定義されたtrans_exp関数: exp (int list -> int) を用いる。
これによって、exp型リテラルは自然数関数に変換される。以降、この作業を実体化と呼ぶ。
以下は`Pr (P 0, Comp [S; P 0])`の実体でaddという変数を宣言した例である。

```
utop #> let add = trans_exp (Pr (P 0, Comp [S; P 0]));;
val add : int list -> int = <fun>
```

こうしてできた実体の関数addは、2つの引数をリスト形式で受け取り、intを返り値とする。
実際に3と5を受け取って8を返していることが分かる。

```
utop #> add [3; 5];;
- : int = 8
```

Z, S, P n, Comp [f1, f2, f3], Pr (f,g)の実体は以下のような意味である。
- Z: 任意の入力に対して0を返す関数
- S: 任意の入力に対して、入力に+1した値を返す関数。
- P n: 任意の入力に関して、そのn番目の引数を返す関数。
- Comp [f1, f2, f3]: f1の実体の引数それぞれにf2, f3の実体を関数合成した関数。
Compの後のリスト長さが1以上であれば任意に取ることができ、
いずれにしても先頭の関数の引数として後続の関数を1つずつ合成させたものになる。
詳しくは原始帰納関数の関数合成の定義を参照。
- Pr (f, g): fを基底関数、gを再帰ステップとして、原始帰納法を行ってできる関数。
詳しくは原始帰納関数の原始帰納法の定義を参照。

これらのexp型リテラルの詳細は、以下のReferenceを参照。

# Reference

exp型リテラルは、expというバリアント型であらわされた、Z, S, P, Comp, Prというフィールドを持つデータである。それぞれのフィールドは以下に述べるような仕様と意味を持つ。
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
