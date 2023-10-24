
fit(::Type{Exponential}, m::AbstractMoments) = fit(Exponential{eltype(m)}, m)
function fit(::Type{Exponential{T}}, m::AbstractMoments) where {T}
    # https://en.wikipedia.org/wiki/Exponential_distribution
    n_moments(m) >= 1 || error("Need mean to estimate exponential")
    return Exponential(T(mean(m)))
end

function fit(::Type{Exponential}, lower::QuantilePoint, upper::Missing)
    fit(Exponential{Float64}, lower, upper)
end
function fit(::Type{Exponential{T}}, lower::QuantilePoint, upper::Missing) where {T}
    θ_lower = -lower.q / log(1 - lower.p)
    Exponential(T(θ_lower))
end

function fit(::Type{Exponential}, lower::Missing, upper::QuantilePoint)
    fit(Exponential{Float64}, lower, upper)
end
function fit(::Type{Exponential{T}}, lower::Missing, upper::QuantilePoint) where {T}
    θ_upper = -upper.q / log(1 - upper.p)
    Exponential(T(θ_upper))
end

function fit(::Type{Exponential}, lower::QuantilePoint, upper::QuantilePoint)
    fit(Exponential{Float64}, lower, upper)
end
function fit(dt::Type{Exponential{T}}, lower::QuantilePoint, upper::QuantilePoint) where {T}
    # return average for the two quantiles
    ismissing(lower.q) && return (fit(dt, missing, upper))
    ismissing(upper.q) && return (fit(dt, lower, missing))
    θ_lower = -lower.q / log(1 - lower.p)
    θ_upper = -upper.q / log(1 - upper.p)
    θ_lower ≈ θ_upper || @warn("Averaging scale for lower and upper quantile "*
    "for fitting expoenential distribution.")
    θ = (θ_lower + θ_upper) / 2
    Exponential(T(θ))
end

function fit_mean_quantile(::Type{Exponential},
    mean::T,
    qp::QuantilePoint) where {T <: Real}
    fit_mean_quantile(Exponential{T}, mean, qp)
end
function fit_mean_quantile(dt::Type{Exponential{T}},
    mean::Real,
    qp::QuantilePoint) where {T}
    # only fit to mean
    @warn "ignoring upper quantile when fitting Exponential to mean." #exception=(e,catch_backtrace(),)
    fit_mean_quantile(dt, mean, missing)
end
function fit_mean_quantile(::Type{Exponential}, mean::T, qp::Missing) where {T <: Real}
    fit(Exponential{T}, Moments(mean))
end
function fit_mean_quantile(::Type{Exponential{T}},
    mean::Real,
    qp::Missing) where {T <: Real}
    fit(Exponential{T}, Moments(mean))
end

function fit_mode_quantile(::Type{<:Exponential},
    mode::T,
    qp::QuantilePoint) where {T <: Real}
    # ignore mode (its always at 0)
    mode != zero(mode) && @warn("ignoring mode when fitting Exponential.")
    fit_mode_quantile(Exponential{T}, missing, qp)
end

function fit_mode_quantile(::Type{Exponential}, mode::Missing, qp::QuantilePoint)
    fit_mode_quantile(Exponential{Float64}, mode, qp)
end
function fit_mode_quantile(::Type{Exponential{T}},
    mode::Missing,
    qp::QuantilePoint) where {T <: Real}
    θ = -qp.q / log(1 - qp.p)
    Exponential(T(θ))
end
