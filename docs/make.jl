using Distributions, DistributionFits
using Documenter

DocMeta.setdocmeta!(DistributionFits, :DocTestSetup, :(using DistributionFits); recursive=true)

makedocs(;
    modules=[DistributionFits],
    authors="Thomas Wutzler <twutz@bgc-jena.mpg.de> and contributors",
    repo="https://github.com/bgctw/DistributionFits.jl/blob/{commit}{path}#{line}",
    sitename="DistributionFits.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://bgctw.github.io/DistributionFits.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "LogitNormal" => "logitnormal.md",
        #"Details" => "z_autodocs.md",
    ],
)

deploydocs(;
    repo="github.com/bgctw/DistributionFits.jl",
    devbranch="main",
)
