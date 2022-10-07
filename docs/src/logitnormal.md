```@meta
CurrentModule = DistributionFits
```

# LogitNormal distribution

## Aggregate statistics
The [logitnormal distribution](https://en.wikipedia.org/wiki/Logit-normal_distribution)
has no analytical formula for mean, variance nor its mode.
This package estimates those by numerically integrating the 
distribution.

```@meta
DocTestSetup = :(using Statistics,DistributionFits,Optim)
```
```jldoctest; output = false
d = fit(LogitNormal, 0.8, @qp_u(0.9), Val(:mode))
mean(d), var(d)
mode(d) ≈ 0.8
# output
true
```

## Specifying a logitnormal distribution by mode and peakedness

It is sometimes difficult to specify a precise upper quantile, because
the logitnormal distribution is already constrained in (0,1).
However, user might have an idea of the spread, or the inverse: peakedness, 
of the distribution.

With increasing spread, the logitnormal distribution becomes bimodal.
The following functiion estimates the most spread, i.e most
flat distribution that has a single mode at the given location.

```@docs
fit_mode_flat
```

The found maximum spread parameter, σ, is devided by the peakedness
argument to specify distributions given the mode that are more
peaked.

```@setup plot_peakedness
using DistributionFits,Optim
using StatsPlots # do not forget to add to docs environment
peakedness_vec = 1:0.5:2
m = 0.6
p = plot(
    legend = :topleft, ylab="probability density", legendtitle = "peakedness",
    palette = :Dark2_3,)
for peakedness in peakedness_vec
    d = fit_mode_flat(LogitNormal, m; peakedness)
    plot!(p, d, label = peakedness)
end
#savefig(p, "logitnormal_peakedness.svg")
#![](logitnormal_peakedness.svg)
```
```@example plot_peakedness
p # hide
```

A shifted and scaled version of this distribution can be
used as a moother alternative to the Bounded uniform distribution.

```@docs
shifloNormal
```




