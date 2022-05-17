```@meta
CurrentModule = DistributionFits
```

# Gamma distribution

The [Gamma distribution](https://juliastats.org/Distributions.jl/stable/univariate/#Distributions.Gamma) has a scale and a shape parameter.
It can be fitted using two quantiles.

```jldoctest; output = false, setup = :(using DistributionFits,Optim)
d = fit(Gamma, @qp_m(0.5), @qp_uu(5));
median(d) ≈ 0.5 && quantile(d, 0.975) ≈ 5
# output
true
```

Fitting by mean or mode is not yet implemented.

