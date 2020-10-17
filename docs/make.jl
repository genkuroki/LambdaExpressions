using LambdaExpressions
using Documenter

makedocs(;
    modules=[LambdaExpressions],
    authors="genkuroki <genkuroki@gmail.com> and contributors",
    repo="https://github.com/genkuroki/LambdaExpressions.jl/blob/{commit}{path}#L{line}",
    sitename="LambdaExpressions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://genkuroki.github.io/LambdaExpressions.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/genkuroki/LambdaExpressions.jl",
)
