```@meta
CurrentModule = DistributionFits
```

# Multivariate LogNormal distribution

Can be fitted to a given mean, provided the Covariance of the underlying
normal distribution.

```jldoctest; output = false, setup = :(using DistributionFits)
Σ = hcat([0.6,0.02],[0.02,0.7])
μ = [1.2,1.3]
d = MvLogNormal(μ, Σ)
d2 = fit_mean_Σ(MvLogNormal, mean(d), Σ)
isapprox(d2, d, rtol = 1e6)
# output
true
```
