```@meta
CurrentModule = DistributionFits
```

# DistributionFits

Package [DistributionFits](https://github.com/bgctw/DistributionFits.jl)
allows fitting a distribution to a given
set of aggregate statistics.

- to specified moments
```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```
```jldoctest; output = false
d = fit(LogNormal, Moments(3.0,4.0))
(mean(d), var(d)) .≈ (3.0, 4.0)
# output
(true, true)
```
- mean and upper quantile point
```jldoctest; output = false
d = fit(LogNormal, 3.0, @qp_uu(8))
(mean(d), quantile(d, 0.975)) .≈ (3.0, 8.0)
# output
(true, true)
```
- to mode and upper quantile point
```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```
```jldoctest; output = false
d = fit(LogNormal, 3.0, @qp_uu(8), Val(:mode))
(mode(d), quantile(d, 0.975)) .≈ (3.0, 8.0)
# output
(true, true)
```
- to median and upper quantile point
```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```
```jldoctest; output = false
d = fit(LogitNormal, 0.3, @qp_u(0.8), Val(:median))
(median(d), quantile(d, 0.95)) .≈ (0.3, 0.8)
# output
(true, true)
```
- to two quantiles, i.e confidence range
```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```
```jldoctest; output = false
d = fit(Normal, @qp_ll(1.0), @qp_uu(8))
(quantile(d, 0.025), quantile(d, 0.975)) .≈ (1.0, 8.0)
# output
(true, true)
```
- approximate a different distribution by matching moments
```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```
```jldoctest; output = false
dn = Normal(3,2)
d = fit(LogNormal, moments(dn))
(mean(d), var(d)) .≈ (3.0, 4.0)
# output
(true, true)
```

## Fit to statistical moments

```@docs
fit(::Type{D}, ::AbstractMoments) where {D<:Distribution}
```

## Fit to several quantile points

```@docs
fit(::Type{D}, ::QuantilePoint, ::QuantilePoint) where {D<:Distribution}
```

## Fit to mean, mode, median and a quantile point

```@docs
fit(::Type{D}, ::Any, ::QuantilePoint, ::Val{stats} = Val(:mean)) where {D<:Distribution, stats}
```

## Fit to mean and uncertainty parameter
For bayesian inversion it is often required to specify a distribution given
the expected value (the predction of the population value) and a description of 
uncertainty of an observation.

```@docs
fit_mean_Σ
```


## Currently supported distributions
Univariate continuous
- Normal
- [LogNormal distribution](@ref)
- [LogitNormal distribution](@ref)
- Exponential
- Laplace
- [Weibull distribution](@ref)
- [Gamma distribution](@ref)

## Implementing support for another distribution

In order to use the fitting framework for a distribution `MyDist`, 
one needs to implement the following four methods.

```julia
fit(::Type{MyDist}, m::AbstractMoments)

fit_mean_quantile(::Type{MyDist}, mean, qp::QuantilePoint)

fit_mode_quantile(::Type{MyDist}, mode, qp::QuantilePoint)

fit(::Type{MyDist}, lower::QuantilePoint, upper::QuantilePoint)
```

The default method for `fit` with `stats = :median` already works based on the methods for 
two quantile points. If the general method on two quantile points cannot be specified, 
one can alternatively implement method:

```julia
fit_median_quantile(::Type{MyDist}, median, qp::QuantilePoint)
```






