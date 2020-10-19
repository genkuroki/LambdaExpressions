module LispLikeEval

export translate_lambda, @translate_lambda, eval_lambda, @eval_lambda, lambda

########## manipulate tuple expressions

"""`lambda()` is the dummy function."""
function lambda end

"""`translate_lambda!(x)` is the in-place version."""
translate_lambda!(x) = x

function translate_lambda!(expr::Expr)
    if expr.head == :call && expr.args[1] == :lambda
        xs = expr.args[2]
        F = expr.args[3]
        expr = Expr(:->, xs, F)
    elseif (!isempty(expr.args) && expr.args[1] isa Expr &&
        expr.args[1].head == :call && expr.args[1].args[1] == :lambda)
        if expr.args[1].args[2] isa Symbol
            xs = expr.args[1].args[2]
        else
            xs = expr.args[1].args[2].args
        end
        F = expr.args[1].args[3]
        Xs = @view expr.args[2:end]
        @assert length(xs) == length(Xs)
        alist = (x => X for (x, X) in zip(xs, Xs))
        expr = Expr(:let, Expr(:block), 
            Expr(:block, (Expr(:(=), x, X) for (x, X) in alist)..., F))
    end
    for i in eachindex(expr.args)
        expr.args[i] = translate_lambda!(expr.args[i])
    end
    expr
end

"""
    translate_lambda(x)

returns the translation of an expression `x` with __lambda__ to the corresponding Julia expression.
"""
translate_lambda(x) = translate_lambda!(deepcopy(x))

macro translate_lambda(x)
    QuoteNode(translate_lambda(x))
end

"""`eval_lambda(x, m::Module=Main)` is the function version of `@eval_lambda(x)`"""
eval_lambda(x, m::Module=Main) = Core.eval(m, translate_lambda(x))

"""
    @eval_lambda(x)

evaluates an expression with __lambda__.
"""
macro eval_lambda(x)
    esc(translate_lambda(x))
end

########## Lisp-like functions

export Nil, nil, null, eq, cons, car, cdr, caar, cadr, cdar, cddr

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

"""`cons(x, y)` is the Lisp-like cons function."""
cons(x, y) = (x, y)
cons(x, y::Tuple) = (x, y...)

"""
`car(x, y)` is the Lisp-like car function.

* The S-expression (a b c d) is represented by the tuple (a, b, c, d, nil).
* The S-expression (a b c . d) is represented by the tuple (a, b, c, d).
"""
car(x) = nil
car(x::Tuple) = x[1]

"""`cdr(x, y)` is the Lisp-like cdr function."""
cdr(x) = nil
cdr(x::Tuple) = length(x) == 2 ? x[2] : x[2:end]

"""`caar(x, y)` is the Lisp-like caar function."""
caar(x) = car(car(x))

"""`cadr(x, y)` is the Lisp-like cadr function."""
cadr(x) = car(cdr(x))

"""`cdar(x, y)` is the Lisp-like cdar function."""
cdar(x) = cdr(car(x))

"""cddr(x, y) is the Lisp-like cddr function."""          
cddr(x) = cdr(cdr(x))

end
