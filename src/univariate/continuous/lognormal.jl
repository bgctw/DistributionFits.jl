function fit(::Type{LogNormal}, m::AbstractMoments)
    # https://en.wikipedia.org/wiki/Log-normal_distribution
    n_moments(m) >= 2 || error("Need mean and variance to estimate lognormal")
    γ = 1+var(m)/mean(m)^2
    μ = log(mean(m)/sqrt(γ))
    σ = sqrt(log(γ))
    return LogNormal(μ,σ)
end

function fit(::Type{LogNormal}, lower::QuantilePoint, upper::QuantilePoint)
    #length(qset) == 2 || error("only implemented yet for exactly two quantiles.")
    #qset_log = [QuantilePoint(qp, q = log(qp.q)) for qp in qset]
    lower_log = QuantilePoint(lower, q = log(lower.q))
    upper_log = QuantilePoint(upper, q = log(upper.q))
    DN = fit(Normal, lower_log, upper_log)
    LogNormal(params(DN)...)
end

function fit_mean_quantile(::Type{LogNormal}, mean::Real, qp::QuantilePoint)
    # solution of
    # (1) mean = exp(mu + sigma^2/2)
    # (2) upper = mu + sigmaFac sigma
    # see R packaage lognorm inst/doc/coefLognorm.Rmd for derivation
    sigmaFac = quantile(Normal(),qp.p)
    m = log(mean)
    discr = sigmaFac^2 - 2*(log(qp.q) - m)
    (discr > 0) || error("Cannot fit LogNormal with quantile $(qp) and mean $(mean).")
    sigma = sigmaFac > sqrt(discr) ? (sigmaFac - sqrt(discr)) : sigmaFac + sqrt(discr)
    mu = m - sigma^2/2
    LogNormal(mu, sigma)
end

function fit_mode_quantile(::Type{LogNormal}, mode::Real, qp::QuantilePoint)
    # solution of
    # (1) mle = exp(mu - sigma^2)
    # (2) upper = mu + sigmaFac sigma
    # see R packaage lognorm inst/doc/coefLognorm.Rmd for derivation
    sigmaFac = quantile(Normal(),qp.p)
    m = log(mode)
    discr = sigmaFac^2/4 + (log(qp.q) - m)
    (discr > 0) || error("Cannot fit LogNormal with quantile $(qp) and mode $(mode).")
    root_discr = sqrt(discr)
    mfh = -sigmaFac/2
    sigma = mfh > root_discr ? (mfh - root_discr) : (mfh + root_discr)
    #sigma = mfh + root_discr
    mu = m + sigma^2
    LogNormal(mu, sigma)
end

"""
    Σstar <: AbstractΣstar
    
Represent the multiplicative standard deviation of a LogNormal distribution.

Supports dispatch of `fit`.
Invoking the type as a function returns its single value.

# Examples
```jldoctest; output = false, setup = :(using DistributionFits)
a = Σstar(4.2)
a() == 4.2
# output
true
```
"""
abstract type AbstractΣstar end

struct Σstar <: AbstractΣstar
    σstar 
end
(a::Σstar)() = a.σstar

"""
    σstar(d)
    
Get the multiplicative standard deviation of LogNormal distribution d.

# Arguments
- `d`: The type of distribution to fit

# Examples
```jldoctest fm1; output = false, setup = :(using DistributionFits)
d = LogNormal(2,log(1.2))
σstar(d) == 1.2
# output
true
```
"""
σstar(d::LogNormal) = exp(params(d)[2])

"""
    fit(D, mean, σstar)
    
Fit a statistical distribution of type `D` to mean and multiplicative 
standard deviation.

# Arguments
- `D`: The type of distribution to fit
- `mean`: The moments of the distribution
- `σstar::AbstractΣstar`: The multiplicative standard deviation

See also [`σstar`](@ref), [`AbstractΣstar`](@ref). 

# Examples
```jldoctest fm1; output = false, setup = :(using DistributionFits)
d = fit(LogNormal, 2, Σstar(1.1));
(mean(d), σstar(d)) == (2, 1.1)
# output
true
```
"""
function fit(::Type{LogNormal}, mean, σstar::AbstractΣstar)
    σ = log(σstar())
    μ = log(mean) - σ*σ/2
    LogNormal(μ, σ)
end

