using DistributionFits
using Documenter
using StatsPlots, Statistics # used in help

# use plot on headleass server: 
# https://juliadocs.github.io/Documenter.jl/stable/man/syntax/#@example-block
ENV["GKSwstype"] = "100"

DocMeta.setdocmeta!(DistributionFits,
    :DocTestSetup,
    :(using DistributionFits);
    recursive = true)

makedocs(;
    modules = [DistributionFits],
    authors = "Thomas Wutzler <twutz@bgc-jena.mpg.de> and contributors",
    #repo="https://github.com/EarthyScience/DistributionFits.jl/blob/{commit}{path}#{line}",
    repo = Remotes.GitHub("EarthyScience", "DistributionFits.jl"),
    sitename = "DistributionFits.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://EarthyScience.github.io/DistributionFits.jl",
        assets = String[],),
    pages = [
        "Home" => "index.md",
        "Parameter type" => "partype.md",
        "Distributions" => [
            "LogNormal" => "lognormal.md",
            "LogitNormal" => "logitnormal.md",
            "Weibull" => "weibull.md",
            "Gamma" => "gamma.md",
            "MvLogNormal" => "mvlognormal.md",
        ],
        "Dependencies" => "set_optimize.md",
        "API" => "api.md",
        #"Details" => "z_autodocs.md",
    ],)

deploydocs(;
    repo = "github.com/EarthyScience/DistributionFits.jl",
    devbranch = "main",)
