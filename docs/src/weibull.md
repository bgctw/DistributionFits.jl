```@meta
CurrentModule = DistributionFits
```

# Weibull distribution

The Weibull distribution has a scale and a shape parameter.
It can be fitted using two quantiles.

```jldoctest; output = false, setup = :(using DistributionFits,Optim)
d = fit(Weibull, @qp_m(0.5), @qp_uu(5));
median(d) == 0.5 && quantile(d, 0.975) ≈ 5
# output
true
```

Fitting by mean or mode is not yet implemented.

