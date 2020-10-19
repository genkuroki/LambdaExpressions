using LispLikeEval
using Documenter

makedocs(;
    modules=[LispLikeEval],
    authors="genkuroki <genkuroki@gmail.com> and contributors",
    repo="https://github.com/genkuroki/LispLikeEval.jl/blob/{commit}{path}#L{line}",
    sitename="LispLikeEval.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://genkuroki.github.io/LispLikeEval.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/genkuroki/LispLikeEval.jl",
)
