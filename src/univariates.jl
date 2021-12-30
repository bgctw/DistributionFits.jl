##### specific distributions #####

const discrete_distributions = [
    # "bernoulli",
    # "betabinomial",
    # "binomial",
    # "dirac",
    # "discreteuniform",
    # "discretenonparametric",
    # "categorical",
    # "geometric",
    # "hypergeometric",
    # "negativebinomial",
    # "noncentralhypergeometric",
    # "poisson",
    # "skellam",
    # "soliton",
    # "poissonbinomial"
]

const continuous_distributions = [
    # "arcsine",
    # "beta",
    # "betaprime",
    # "biweight",
    # "cauchy",
    # "chernoff",
    # "chisq",    # Chi depends on Chisq
    # "chi",
    # "cosine",
    # "epanechnikov",
    # "exponential",
    # "fdist",
    # "frechet",
    # "gamma", "erlang",
    # "pgeneralizedgaussian", # GeneralizedGaussian depends on Gamma
    # "generalizedpareto",
    # "generalizedextremevalue",
    # "gumbel",
    # "inversegamma",
    # "inversegaussian",
    # "kolmogorov",
    # "ksdist",
    # "ksonesided",
    # "laplace",
    # "levy",
    # "locationscale",
    # "logistic",
    # "noncentralbeta",
    # "noncentralchisq",
    # "noncentralf",
    # "noncentralt",
     "normal",
    # "normalcanon",
    # "normalinversegaussian",
     "lognormal",    # LogNormal depends on Normal
    # "logitnormal",    # LogitNormal depends on Normal
    # "pareto",
    # "rayleigh",
    # "semicircle",
    # "skewnormal",
    # "studentizedrange",
    # "symtriangular",
    # "tdist",
    # "triangular",
    # "triweight",
    # "uniform",
    # "vonmises",
    # "weibull"
]

for dname in discrete_distributions
    include(joinpath("univariate", "discrete", "$(dname).jl"))
end

for dname in continuous_distributions
    include(joinpath("univariate", "continuous", "$(dname).jl"))
end
