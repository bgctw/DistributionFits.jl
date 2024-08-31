```@meta
CurrentModule = DistributionFits
```

# LogNormal distribution

The LogNormal distribution can be characterized by
the exponent of its parameters:

- exp(μ): the median
- exp(σ): the multiplicative standard deviation ``\sigma^*``.

Function [`σstar`](@ref) returns the multiplicative standard deviation.

A distribution can be specified by taking the log of median and ``\sigma^*``

```jldoctest; output = false, setup = :(using DistributionFits,Optim)
d = LogNormal(log(2), log(1.2))
σstar(d) == 1.2
# output
true
```

Alternatively the distribution can be specified by its mean and either 
- Multiplicative standard deviation,``\sigma^*``, using type [`AbstractΣstar`](@ref)
- Standard deviation at log-scale, ``\sigma``, or
- relative error, ``cv``. 

```jldoctest; output = false, setup = :(using DistributionFits,Optim)
d = fit(LogNormal, 2, Σstar(1.2))
(mean(d), σstar(d)) == (2, 1.2)
# output
true
```
```jldoctest; output = false, setup = :(using DistributionFits,Optim)
d = fit_mean_Σ(LogNormal, 2, 1.2)
(mean(d),  d.σ) == (2, 1.2)
# output
true
```
```jldoctest; output = false, setup = :(using DistributionFits,Optim)
d = fit_mean_relerror(LogNormal, 2, 0.2)
(mean(d), std(d)/mean(d)) .≈ (2, 0.2)
# output
(true, true)
```

## ScaledLogNormal: LogNormal(-x)
To support the use case of a distribution of strictly negative values, the
fitting of a mirrored LogNormal on `-x` is supported.

There is a type-alias 
`ScaledLogNormal = LocationScale{T, Continuous, LogNormal{T}} where T`,
denoting a scaled and shifted LogNormal distribution.

There are fitting function dispatched by this type that fit
such a mirrored distribution.

```jldoctest; output = false, setup = :(using DistributionFits)
d = fit_mean_Σ(ScaledLogNormal, -1, log(1.1))
(mean(d), σstar(d)) .≈ (-1.0, 1.1)
# output
(true, true)
```

```jldoctest; output = false, setup = :(using DistributionFits)
d = fit(ScaledLogNormal, -1.0, @qp_ll(-1.32), Val(:mode))
(mode(d), quantile(d, 0.025)) .≈ (-1.0, -1.32)
# output
(true, true)
```
Note the usage of lower quantile for the mirrored distribution, here.


## Detailed API

```@docs
σstar(::LogNormal)
```

```@docs
fit(d::Type{LogNormal}, mean, σstar::AbstractΣstar)
```

```@docs
AbstractΣstar
```

```@docs
fit_mean_relerror
```

