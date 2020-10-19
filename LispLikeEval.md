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

```julia
expr = :(lambda((x, y), sin(x)*y)(1, 2))
show(expr); println("\n")
show_texpr(expr); println("\n")
translate_lambda(expr) |> show
@eval_lambda lambda((x, y), sin(x)*y)(1, 2)
```

```julia
expr = :(lambda((f, x), f(x))(lambda(x, iszero(x) ? 1 : x*f(x-1)), 10))
show(expr); println("\n")
show_texpr(expr); println("\n")
translate_lambda(expr) |> show
@eval_lambda lambda((f, x), f(x))(
    lambda(x, iszero(x) ? 1 : x*f(x-1)),
    10
)
```

```julia
@eval_lambda lambda((f, x), f(x))(
    x -> iszero(x) ? 1 : x*f(x-1),
    10
)
```

```julia
@show_texpr (lambda((assoc, k, v), assoc(k, v)))(
    lambda((k, v), 
        eq(v, nil)         ? nil    :
        eq(car(car(v)), k) ? car(v) :
        assoc(k, cdr(v))),
    :Orange,
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
@translate_lambda (lambda((assoc, k, v), assoc(k, v)))(
    lambda((k, v), 
        eq(v, nil)         ? nil    :
        eq(car(car(v)), k) ? car(v) :
        assoc(k, cdr(v))),
    :Orange,
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
@eval_lambda (lambda((assoc, k, v), assoc(k, v)))(
    lambda((k, v), 
        eq(v, nil)         ? nil    :
        eq(car(car(v)), k) ? car(v) :
        assoc(k, cdr(v))),
    :Apple,
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
@eval_lambda (lambda((assoc, k, v), assoc(k, v)))(
    lambda((k, v), 
        eq(v, nil)         ? nil    :
        eq(car(car(v)), k) ? car(v) :
        assoc(k, cdr(v))),
    :Orange,
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
@eval_lambda (lambda((assoc, k, v), assoc(k, v)))(
    lambda((k, v), 
        eq(v, nil)         ? nil    :
        eq(car(car(v)), k) ? car(v) :
        assoc(k, cdr(v))),
    :Lemmon,
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
@eval_lambda (lambda((assoc, k, v), assoc(k, v)))(
    lambda((k, v), 
        eq(v, nil)         ? nil    :
        eq(car(car(v)), k) ? car(v) :
        assoc(k, cdr(v))),
    :Melon,
    ((:Apple, 120), (:Orange, 210), (:Lemmon, 180), nil))
```

```julia
texpr_exmaple4(x) = (:call, 
    (:lambda, (:tuple, :assoc, :k, :v), (:call, :assoc, :k, :v)), 
    (:lambda, (:tuple, :k, :v), 
        (:if, (:eq, :v, (:tuple,)), :nil,
            (:if, (:eq, (:car, (:car, :v)), :k), (:car, :v), 
                (:call, :assoc, :k, (:cdr, :v))))), 
    QuoteNode(x), 
    (:tuple, 
        (:tuple, QuoteNode(:Apple),  120), 
        (:tuple, QuoteNode(:Orange), 210), 
        (:tuple, QuoteNode(:Lemmon), 180), :nil))
```

```julia
texpr_exmaple4(:Apple) |> texpr2expr |> eval_lambda
```

```julia
texpr_exmaple4(:Orange) |> texpr2expr |> eval_lambda
```

```julia
texpr_exmaple4(:Lemmon) |> texpr2expr |> eval_lambda
```

```julia
texpr_exmaple4(:Melon) |> texpr2expr |> eval_lambda
```

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

```julia

```
