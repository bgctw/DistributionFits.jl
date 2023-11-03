```@meta
CurrentModule = DistributionFits
```
```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```

# Creating Distributions with specific parameter types

Default type of distribution parameters is Float64. Many Distributions of Distributions.jl support also other Number types, such as duals numbers or Float32 for type parameters.

The fit function allow to specify the concrete parametric types of the resulting fitted distribution. Note the `Float32` parametric type in the following example.

```jldoctest; output = false
d = fit(LogNormal{Float32}, @qp_ll(1.0), @qp_uu(8))
partype(d) == Float32
# output
true
```

## Inferring the parametric type from other arguments.

If the parametric type is omitted, default Float64 is assumed, or inferred from
other parameters of the fitting function.
Since quantiles and median are rather sample-like measures than paraemter-like
measures, they do not influence the inferred parameter type.


```jldoctest; output = false
d = fit(LogitNormal, 0.3f0, @qp_u(0.8f0), Val(:median)) #f0 indicates Float32 literals
partype(d) == Float64
# output
true
```

Parameter type, however, can be inferred from provided moments, mean, and mode.

```jldoctest; output = false
d = fit(Exponential, Moments(3f0))  #f0 indicates Float32 literals
partype(d) == Float32
# output
true
```

```jldoctest; output = false
d = fit(LogNormal, 3f0, @qp_uu(8))
partype(d) == Float32
# output
true
```

```jldoctest; output = false
d = fit(LogNormal, 3f0, @qp_uu(8), Val(:mode))
partype(d) == Float32
# output
true
```









