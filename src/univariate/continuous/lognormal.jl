fit(::Type{LogNormal}, m::AbstractMoments) = fit(LogNormal{eltype(m)}, m)
function fit(::Type{LogNormal{T}}, m::AbstractMoments) where {T}
    # https://en.wikipedia.org/wiki/Log-normal_distribution
    n_moments(m) >= 2 || error("Need mean and variance to estimate lognormal")
    γ = 1 + var(m) / mean(m)^2
    μ = log(mean(m) / sqrt(γ))
    σ = sqrt(log(γ))
    return LogNormal(T(μ), T(σ))
end

function fit(::Type{LogNormal}, lower::QuantilePoint, upper::QuantilePoint)
    fit(LogNormal{Float64}, lower, upper)
end
function fit(::Type{LogNormal{T}}, lower::QuantilePoint, upper::QuantilePoint) where {T}
    #length(qset) == 2 || error("only implemented yet for exactly two quantiles.")
    #qset_log = [QuantilePoint(qp, q = log(qp.q)) for qp in qset]
    lower_log = QuantilePoint(lower, q = log(lower.q))
    upper_log = QuantilePoint(upper, q = log(upper.q))
    DN = fit(Normal{T}, lower_log, upper_log)
    LogNormal(params(DN)...)
end

function fit_mean_quantile(::Type{LogNormal}, mean::T, qp::QuantilePoint) where {T <: Real}
    fit_mean_quantile(LogNormal{T}, mean, qp)
end
function fit_mean_quantile(::Type{LogNormal{T}}, mean::Real, qp::QuantilePoint) where {T}
    # solution of
    # (1) mean = exp(mu + sigma^2/2)
    # (2) upper = mu + sigmaFac sigma
    # see R packaage lognorm inst/doc/coefLognorm.Rmd for derivation
    sigmaFac = quantile(Normal(), qp.p)
    m = log(mean)
    discr = sigmaFac^2 - 2 * (log(qp.q) - m)
    (discr > 0) || error("Cannot fit LogNormal with quantile $(qp) and mean $(mean).")
    sigma = sigmaFac > sqrt(discr) ? (sigmaFac - sqrt(discr)) : sigmaFac + sqrt(discr)
    mu = m - sigma^2 / 2
    LogNormal(T(mu), T(sigma))
end

function fit_mode_quantile(::Type{LogNormal}, mode::T, qp::QuantilePoint) where {T <: Real}
    fit_mode_quantile(LogNormal{T}, mode, qp)
end
function fit_mode_quantile(::Type{LogNormal{T}}, mode::Real, qp::QuantilePoint) where {T}
    # solution of
    # (1) mle = exp(mu - sigma^2)
    # (2) upper = mu + sigmaFac sigma
    # see R packaage lognorm inst/doc/coefLognorm.Rmd for derivation
    sigmaFac = quantile(Normal(), qp.p)
    m = log(mode)
    discr = sigmaFac^2 / 4 + (log(qp.q) - m)
    (discr > 0) || error("Cannot fit LogNormal with quantile $(qp) and mode $(mode).")
    root_discr = sqrt(discr)
    mfh = -sigmaFac / 2
    sigma = mfh > root_discr ? (mfh - root_discr) : (mfh + root_discr)
    #sigma = mfh + root_discr
    mu = m + sigma^2
    LogNormal(T(mu), T(sigma))
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

struct Σstar{T} <: AbstractΣstar
    σstar::T
end
(a::Σstar)() = a.σstar
Base.eltype(::Type{Σstar{T}}) where {T} = T
Base.eltype(::Σstar{T}) where {T} = T

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
    fit(D, mean, σstar::AbstractΣstar)
    fit_mean_Σ(D, mean, σ::Real)
    
Fit a statistical distribution of type `D` to mean and multiplicative 
standard deviation, `σstar`, or scale parameter at log-scale: `σ`.

# Arguments
- `D`: The type of distribution to fit
- `mean`: The moments of the distribution
- `σstar::AbstractΣstar`: The multiplicative standard deviation
- `σ`: The standard-deviation parameter at log-scale

The first version uses type [`AbstractΣstar`](@ref) to distinguish from 
other methods of function fit. 

# Examples
```jldoctest fm1; output = false, setup = :(using DistributionFits)
d = fit(LogNormal, 2, Σstar(1.1));
(mean(d), σstar(d)) == (2, 1.1)
# output
true
```
"""
function fit(d::Type{LogNormal}, mean, σstar::AbstractΣstar) 
    fit_mean_Σ(d, mean, log(σstar()))
end
function fit(d::Type{LogNormal{T}}, mean::Real, σstar::AbstractΣstar) where {T}
    fit_mean_Σ(d, mean, log(σstar()))
end
function fit_mean_Σ(::Type{LogNormal}, mean::T1, σ::T2) where {T1 <: Real,T2 <: Real}
    _T = promote_type(T1, T2)
    fit_mean_Σ(LogNormal{_T}, mean, σ)
end
function fit_mean_Σ(::Type{LogNormal{T}}, mean::Real, σ::Real) where {T}
    #σ = log(σstar())
    μ = log(mean) - σ * σ / 2
    LogNormal(T(μ), T(σ))
end


"""
    fit_mean_relerror(D, mean, relerror)
    
Fit a distribution of type `D` to mean and relative error.

# Arguments
- `D`: The type of distribution to fit
- `mean`: The first moment of the distribution
- `relerror`: The relative error, i.e. the coefficient of variation

# Examples
```jldoctest fm1; output = false, setup = :(using DistributionFits)
d = fit_mean_relerror(LogNormal, 10.0, 0.03);
(mean(d), std(d)/mean(d)) .≈ (10.0, 0.03)
# output
(true, true)
```
"""
function fit_mean_relerror(::Type{LogNormal}, mean, relerror)
    # e.g. Limpert 2001, Wutzler 2020
    w = 1 + abs2(relerror)
    μ = log(mean / sqrt(w))
    σ = sqrt(log(w))
    LogNormal(μ, σ)
end


#---- support LogNormal(-x) of negative values ------------
const ScaledLogNormal{T} = LocationScale{T1, Continuous, LogNormal{T}} where {T1, T}

σstar(d::ScaledLogNormal) = exp(params(d.ρ)[2])


function fit_mean_Σ(::Type{ScaledLogNormal}, mean::T1, σ::T2) where {T1 <: Real,T2 <: Real}
    _T = promote_type(T1, T2)
    fit_mean_Σ(ScaledLogNormal{_T}, mean, σ)
end
function fit_mean_Σ(d::Type{ScaledLogNormal{T}}, mean::Real, σ::Real) where T
    mean < 0 && return(-1 * fit_mean_Σ(LogNormal{T}, -mean, σ))
    1 * fit_mean_Σ(LogNormal{T}, mean, σ)
end

function fit_mode_quantile(::Type{ScaledLogNormal}, mode::T, qp::QuantilePoint) where T<:Real
    fit_mode_quantile(ScaledLogNormal{T}, mode, qp)
end
function fit_mode_quantile(::Type{ScaledLogNormal{T}}, mode::Real, qp::QuantilePoint) where T
    if mode < 0 
        return(-1 * fit_mode_quantile(LogNormal{T}, -mode, QuantilePoint(-qp.q,1-qp.p)))
        #return(-1 * fit_mode_quantile(LogNormal{T}, -mode, qp))
    end
    1 * fit_mode_quantile(LogNormal{T}, mode, qp)
end


