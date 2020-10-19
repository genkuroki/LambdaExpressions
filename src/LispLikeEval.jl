module LispLikeEval

export lambda, cond, lexpr2expr, @lexpr2expr, leval, @leval

########## manipulate tuple expressions

arraycdr(x) = length(x) ≥ 2 ? x[2:end] : eltype(x)[]

"""
`lambda` is a Lisp-like dummy function to be translated to Julia expression by `lexpr2expr`.

For example, `lambda((x, y), f(x, y))(a, b)` is translated to

```julia
let
    x = a
    y = b
    f(x, y)
end
```

`lambda((x, y), f(x, y))` without arguments (a, b) is translated to

```julia
(x, y) -> f(x, y)
```
"""
function lambda end

"""
`cond` is a Lisp-like dummy function to be translated to Julia expression by `lexpr2expr`.

For example, `cond((a, A), (b, B), (c, C))` is translated to

```julia
if a
    A
elseif b
    B
elseif c
    C
end
```
"""
function cond end

"""`lexpr2expr!(x)` is the in-place version of lexpr2expr(x)."""
lexpr2expr!(x) = x

function lexpr2expr!(expr::Expr)
    head, args = expr.head, expr.args
    if head == :call && args[1] == :lambda
        xs = args[2]
        F = args[3]
        expr = Expr(:->, xs, F)
    elseif head == :call && args[1] == :cond
        isone(length(args)) && return :nil
        k = 2
        a = args[k].args[1]
        A = arraycdr(args[k].args)
        expr = Expr(:if, a, Expr(:block, A...))
        ifelseargs = expr.args
        k += 1
        while k ≤ length(args)
            a = args[k].args[1]
            A = arraycdr(args[k].args)
            push!(ifelseargs, Expr(:elseif, Expr(:block, a), Expr(:block, A...)))
            ifelseargs = ifelseargs[end].args
            k += 1
        end
    elseif (!isempty(args) && args[1] isa Expr &&
            args[1].head == :call && args[1].args[1] == :lambda)
        xs = args[1].args[2]
        if xs isa Expr
            if xs.head == :tuple
                xs = args[1].args[2].args
            elseif xs.head == :call && xs.args[1] == :list
                xs = arraycdr(xs.args)
            end
        end
        F = args[1].args[3]
        Xs = arraycdr(args)
        @assert length(xs) == length(Xs)
        alist = (x => X for (x, X) in zip(xs, Xs))
        expr = Expr(:let, Expr(:block), 
            Expr(:block, (Expr(:(=), x, X) for (x, X) in alist)..., F))
    end
    
    for i in eachindex(expr.args)
        expr.args[i] = lexpr2expr!(expr.args[i])
    end
    expr
end

"""
    lexpr2expr(x)

translates a Lisp-like expression `x` to the corresponding Julia expression.
"""
lexpr2expr(x) = lexpr2expr!(deepcopy(x))

"""
`@lexpr2expr(x)` is the macro version of `lexpr2expr(x)`.
"""
macro lexpr2expr(x)
    QuoteNode(lexpr2expr(x))
end

"""`leval(x, m::Module=Main)` is the function version of `@leval(x)`"""
leval(x, m::Module=Main) = Core.eval(m, lexpr2expr(x))

"""
    @leval x

evaluates a Lisp-like expression `x`.
"""
macro leval(x)
    esc(lexpr2expr(x))
end

########## Lisp-like functions

export Nil, nil, null, eq, cons, car, cdr, caar, cadr, cdar, cddr, list

"""`Nil` is the type of `nil`."""
struct Nil end
"""`nil` is the singleton of type `Nil` regarded as the Lisp-like nil."""
const nil = Nil()
Base.show(io::IO, ::Nil) = print(io, "nil")

"""`null(x)` returns `true` if x is equal to `nil` and `false` otherwise."""
null(x) = false
null(::Nil) = true

"""`eq(x, y)` returns `true` if x is equal to y and false otherwise, where `()` is considered to be equal to `nil`."""
eq(x, y) = x == y
eq(x::Tuple, ::Nil) = x == ()
eq(::Nil, y::Tuple) = () == y

"""
`cons(x, y)` is a Lisp-like cons function.

* The S-expression (a b c d) is represented by the tuple (a, b, c, d).
* The S-expression (a b c . d) is represented by the tuple (a, b, c=>d).
"""
cons(x, y) = Pair(x, y)
cons(x, ::Nil) = (x,)
cons(x, y::Pair) = (x, y)
cons(x, y::Tuple) = (x, y...)

"""`car(x)` is a Lisp-like car function."""
car(x) = nil
car(x::Pair) = x.first
car(x::Tuple) = x[begin]

"""`cdr(x)` is a Lisp-like cdr function."""
cdr(x) = nil
cdr(x::Pair) = x.second
cdr(x::Tuple) = isone(length(x)) ? nil : x[begin+1:end]

"""`caar(x)` is a Lisp-like caar function."""
caar(x) = car(car(x))

"""`cadr(x)` is a Lisp-like cadr function."""
cadr(x) = car(cdr(x))

"""`cdar(x)` is a Lisp-like cdar function."""
cdar(x) = cdr(car(x))

"""`cddr(x)` is a Lisp-like cddr function."""          
cddr(x) = cdr(cdr(x))

"""`list(x...)` is a Lisp-like list function."""
list() = nil
list(x) = cons(x, nil)
list(x, y, z...) = cons(x, list(y, z...))

end
