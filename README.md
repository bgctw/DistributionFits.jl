# DistributionFits

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://EarthyScience.github.io/DistributionFits.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://EarthyScience.github.io/DistributionFits.jl/dev)
[![Build Status](https://github.com/EarthyScience/DistributionFits.jl/workflows/CI/badge.svg)](https://github.com/EarthyScience/DistributionFits.jl/actions)
[![Coverage](https://codecov.io/gh/EarthyScience/DistributionFits.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/EarthyScience/DistributionFits.jl)


Extends [Distributions.jl](https://github.com/JuliaStats/Distributions.jl) 
to 
- numerically estimate moments and mode for distributions without
  analytical formulas for those, i.e. logitnormal distribution
- allow fitting a distribution to a given set of aggregate statistics.
  - to specified moments
  - to mean and upper quantile point
  - to mode and upper quantile point
  - to median and upper quantile point
  - to lower and upper quantiles, i.e confidence range

This can also be used to approximate one distribution via a different distribution by matching its moments.

User needs to [explicitly using Optim.jl](https://EarthyScience.github.io/DistributionFits.jl/stable/set_optimize/) for DistributionFits.jl to work properly:
```julia
using DistributionFits, Optim
```

Currently, support for the following distributios are implemented:
- Normal
- Lognormal
- Logitnormal 
- Exponential 
- Weibull (only fitting to two quantiles)
- Gamma (only fitting to two quantiles)

See [Documentation](https://EarthyScience.github.io/DistributionFits.jl/dev)