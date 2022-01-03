# DistributionFits

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bgctw.github.io/DistributionFits.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bgctw.github.io/DistributionFits.jl/dev)
[![Build Status](https://github.com/bgctw/DistributionFits.jl/workflows/CI/badge.svg)](https://github.com/bgctw/DistributionFits.jl/actions)
[![Coverage](https://codecov.io/gh/bgctw/DistributionFits.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/bgctw/DistributionFits.jl)


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

This can also be used to approximate a different distribution by matching its moments

Currently, support for the following distributios are implemented:
- Normal
- Lognormal
- Logitnormal 

See [Documentation](https://bgctw.github.io/DistributionFits.jl/dev)