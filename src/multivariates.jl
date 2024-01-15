##### Specific distributions #####

for fname in [
    # "dirichlet.jl",
    # "multinomial.jl",
    # "dirichletmultinomial.jl",
    # "jointorderstatistics.jl",
    "mvnormal.jl",
    # "mvnormalcanon.jl",
    # "mvlogitnormal.jl",
    "mvlognormal.jl",
    # "mvtdist.jl",
    # "vonmisesfisher.jl"
    ]
include(joinpath("multivariate", fname))
end
