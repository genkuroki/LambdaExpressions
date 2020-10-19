---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.1'
      jupytext_version: 1.2.1
  kernelspec:
    display_name: Julia MKL depwarn -O3 1.5.2
    language: julia
    name: julia-mkl-depwarn--o3-1.5
---

<!-- #region -->
# LispLikeEval.ipynb

* Author: Gen Kuroki
* Date: 2020-10-19
* Repository: https://github.com/genkuroki/LispLikeEval.jl

**Installation**
```
pkg> add https://github.com/genkuroki/LispLikeEval.jl
```
<!-- #endregion -->

<!-- #region {"toc": true} -->
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Lisp-like-functions" data-toc-modified-id="Lisp-like-functions-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Lisp-like functions</a></span></li><li><span><a href="#@leval-examples" data-toc-modified-id="@leval-examples-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>@leval examples</a></span></li><li><span><a href="#MetaUtils.@teval-plot-exmaple" data-toc-modified-id="MetaUtils.@teval-plot-exmaple-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>MetaUtils.@teval plot exmaple</a></span></li><li><span><a href="#Documents" data-toc-modified-id="Documents-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Documents</a></span></li></ul></div>
<!-- #endregion -->

```julia
if isfile("Project.toml")
    using Pkg
    Pkg.activate(".")
    using Revise
end
```

```julia
using LispLikeEval
using MetaUtils
```

## Lisp-like functions

```julia
@lexpr2expr lambda((x, y), f(x, y))(a, b)
```

```julia
@lexpr2expr lambda((x, y), f(x, y))
```

```julia
@lexpr2expr cond((a, A), (b, B), (c, C))
```

```julia
@show null(nil)
@show null(1)
;
```

```julia
@show eq(nil, nil)
@show eq(nil, ())
@show eq((), nil)
@show eq(1, 1)
@show eq(1, 2)
;
```

```julia
@show a = cons(2, 1)
@show b = cons(3, a)
@show c = cons(4, b)
@show d = cons(5, c)
;
```

```julia
@show car(1)
@show car(1=>2)
@show car((1, 2=>3))
@show car((1, 2, 3=>4))
@show car((1,))
@show car((1, 2))
@show car((1, 2, 3))
@show car(((1, 2), 3, 4))
;
```

```julia
@show cdr(1)
@show cdr(1=>2)
@show cdr((1, 2=>3))
@show cdr((1, 2, 3=>4))
@show cdr((1,))
@show cdr((1, 2))
@show cdr((1, 2, 3))
@show cdr(((1, 2), 3, 4))
;
```

```julia
@show list()
@show list(1)
@show list(1, 2)
@show list(1, 2, 3)
@show list(1, 2, 3, 4)
;
```

## @leval examples

```julia
lexpr = :(lambda((x, y), x+y)(1, 2))
show(lexpr); println("\n")
show_texpr(lexpr); println("\n")

println("|\nV\n")

expr = lexpr2expr(lexpr)
show(expr); println("\n")
show_texpr(expr); println("\n")

@leval lambda((x, y), x+y)(1, 2)
```

```julia
lexpr = :(lambda((f, x), f(x))(
        lambda(x, cond((iszero(x), 1), (true, x*f(x-1)))),
        10))
show(lexpr); println("\n")
show_texpr(lexpr); println("\n")

println("|\nV\n")

expr = lexpr2expr(lexpr)
show(expr); println("\n")
show_texpr(expr); println("\n")

@leval lambda((f, x), f(x))(
    lambda(x, cond((iszero(x), 1), (true, x*f(x-1)))),
    10)
```

```julia
@lexpr2expr lambda((assoc, k, v), assoc(k, v))(
    lambda((k, v), cond(
            (eq(v, nil), nil),
            (eq(car(car(v)), k), car(v)), 
            (true, assoc(k, cdr(v))))),
    :Orange,
    (:Apple=>120, :Orange=>210, :Lemmon=>180))
```

```julia
@leval lambda((assoc, k, v), assoc(k, v))(
    lambda((k, v), cond(
            (eq(v, nil), nil),
            (eq(car(car(v)), k), car(v)), 
            (true, assoc(k, cdr(v))))),
    :Apple,
    (:Apple=>120, :Orange=>210, :Lemmon=>180))
```

```julia
@leval lambda((assoc, k, v), assoc(k, v))(
    lambda((k, v), cond(
            (eq(v, nil), nil),
            (eq(car(car(v)), k), car(v)), 
            (true, assoc(k, cdr(v))))),
    :Orange,
    (:Apple=>120, :Orange=>210, :Lemmon=>180))
```

```julia
@leval lambda((assoc, k, v), assoc(k, v))(
    lambda((k, v), cond(
            (eq(v, nil), nil),
            (eq(car(car(v)), k), car(v)), 
            (true, assoc(k, cdr(v))))),
    :Lemmon,
    (:Apple=>120, :Orange=>210, :Lemmon=>180))
```

```julia
@leval lambda((assoc, k, v), assoc(k, v))(
    lambda((k, v), cond(
            (eq(v, nil), nil),
            (eq(car(car(v)), k), car(v)), 
            (true, assoc(k, cdr(v))))),
    :Melon,
    (:Apple=>120, :Orange=>210, :Lemmon=>180))
```

```julia
texpr_exmaple4(x) = (:call, 
    (:lambda, (:tuple, :assoc, :k, :v), (:call, :assoc, :k, :v)), 
    (:lambda, (:tuple, :k, :v), (:cond, 
            (:tuple, (:eq, :v, :nil), :nil), 
            (:tuple, (:eq, (:car, (:car, :v)), :k), (:car, :v)), 
            (:tuple, true, (:call, :assoc, :k, (:cdr, :v))))), 
    QuoteNode(x), 
    :((:Apple=>120, :Orange=>210, :Lemmon=>180)))
```

```julia
texpr_exmaple4(:Apple) |> texpr2expr |> leval
```

```julia
texpr_exmaple4(:Orange) |> texpr2expr |> leval
```

```julia
texpr_exmaple4(:Lemmon) |> texpr2expr |> leval
```

```julia
texpr_exmaple4(:Melon) |> texpr2expr |> leval
```

## MetaUtils.@teval plot exmaple

```julia
begin
    using Plots
    n = 20
    x = range(-π, π; length=20)
    noise = 0.3randn(n)
    y = sin.(x) + noise
    X = hcat((x.^k for k in 0:3)...)
    b = X\y
    f(x) = sum(b[k+1]*x^k for k in 0:3)
    xs = range(-π, π; length=400)
    plot(; legend=:topleft)
    scatter!(x, y; label="sample")
    plot!(xs, sin.(xs); label="sin(x)", color=:blue, ls=:dash)
    plot!(xs, f.(xs); label="degree-3 polynomial", color=:red, lw=2)
end
```

```julia
@show_texpr begin
    using Plots
    n = 20
    x = range(-π, π; length=20)
    noise = 0.3randn(n)
    y = sin.(x) + noise
    X = hcat((x.^k for k in 0:3)...)
    b = X\y
    f(x) = sum(b[k+1]*x^k for k in 0:3)
    xs = range(-π, π; length=400)
    plot(; legend=:topleft)
    scatter!(x, y; label="sample")
    plot!(xs, sin.(xs); label="sin(x)", color=:blue, ls=:dash)
    plot!(xs, f.(xs); label="degree-3 polynomial", color=:red, lw=2)
end
```

```julia
@teval (:block, 
    (:using, (:., :Plots)), 
    (:(=), :n, 20), 
    (:(=), :x, (:range, (:parameters, (:kw, :length, 20)), (:-, :π), :π)), 
    (:(=), :noise, (:*, 0.3, (:randn, :n))), 
    (:(=), :y, (:+, (:., :sin, (:tuple, :x)), :noise)), 
    (:(=), :X, 
        (:hcat, (:..., (:generator, (:call, :.^, :x, :k), (:(=), :k, (:(:), 0, 3)))))), 
    (:(=), :b, (:\, :X, :y)), 
    (:(=), (:call, :f, :x), 
        (:sum, (:generator, (:*, (:ref, :b, (:+, :k, 1)), (:^, :x, :k)), 
            (:(=), :k, (:(:), 0, 3))))), 
    (:(=), :xs, (:range, (:parameters, (:kw, :length, 400)), (:-, :π), :π)), 
    (:plot, (:parameters, (:kw, :legend, QuoteNode(:topleft)))), 
    (:scatter!, (:parameters, (:kw, :label, "sample")), :x, :y), 
    (:plot!, (:parameters, 
            (:kw, :label, "sin(x)"), 
            (:kw, :color, QuoteNode(:blue)), 
            (:kw, :ls, QuoteNode(:dash))), 
        :xs, (:., :sin, (:tuple, :xs))), 
    (:plot!, (:parameters, 
            (:kw, :label, "degree-3 polynomial"), 
            (:kw, :color, QuoteNode(:red)), 
            (:kw, :lw, 2)), 
        :xs, (:., :f, (:tuple, :xs))))
```

```julia
(:block, 
    (:using, (:., :Plots)), 
    (:(=), :n, 20), 
    (:(=), :x, (:range, (:parameters, (:kw, :length, 20)), (:-, :π), :π)), 
    (:(=), :noise, (:*, 0.3, (:randn, :n))), 
    (:(=), :y, (:+, (:., :sin, (:tuple, :x)), :noise)), 
    (:(=), :X, 
        (:hcat, (:..., (:generator, (:call, :.^, :x, :k), (:(=), :k, (:(:), 0, 3)))))), 
    (:(=), :b, (:\, :X, :y)), 
    (:(=), (:call, :f, :x), 
        (:sum, (:generator, (:*, (:ref, :b, (:+, :k, 1)), (:^, :x, :k)), 
            (:(=), :k, (:(:), 0, 3))))), 
    (:(=), :xs, (:range, (:parameters, (:kw, :length, 400)), (:-, :π), :π)), 
    (:plot, (:parameters, (:kw, :legend, QuoteNode(:topleft)))), 
    (:scatter!, (:parameters, (:kw, :label, "sample")), :x, :y), 
    (:plot!, (:parameters, 
            (:kw, :label, "sin(x)"), 
            (:kw, :color, QuoteNode(:blue)), 
            (:kw, :ls, QuoteNode(:dash))), 
        :xs, (:., :sin, (:tuple, :xs))), 
    (:plot!, (:parameters, 
            (:kw, :label, "degree-3 polynomial"), 
            (:kw, :color, QuoteNode(:red)), 
            (:kw, :lw, 2)), 
        :xs, (:., :f, (:tuple, :xs)))) |> texpr2expr |> 
x -> display("text/markdown", "```julia\n$x\n```")
```

## Documents

```julia
@doc lambda
```

```julia
@doc cond
```

```julia
@doc lexpr2expr
```

```julia
@doc @lexpr2expr
```

```julia
@doc leval
```

```julia
@doc @leval
```

```julia
@doc Nil
```

```julia
@doc nil
```

```julia
@doc null
```

```julia
@doc eq
```

```julia
@doc cons
```

```julia
@doc car
```

```julia
@doc cdr
```

```julia
@doc caar
```

```julia
@doc cadr
```

```julia
@doc cdar
```

```julia
@doc cddr
```

```julia
@doc list
```

```julia

```
