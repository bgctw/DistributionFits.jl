

function fit(::Type{Exponential}, m::AbstractMoments)
    # https://en.wikipedia.org/wiki/Exponential_distribution
    n_moments(m) >= 1 || error("Need mean to estimate exponential")
    return Exponential(mean(m))
end

function fit(::Type{Exponential}, lower::QuantilePoint, upper::Missing)
    θ_lower = -lower.q/log(1-lower.p)
    Exponential(θ_lower)
end

function fit(::Type{Exponential}, lower::Missing, upper::QuantilePoint)
    θ_upper = -upper.q/log(1-upper.p)
    Exponential(θ_upper)
end

function fit(dt::Type{Exponential}, lower::QuantilePoint, upper::QuantilePoint)
    # return average for the two quantiles
    ismissing(lower.q) && return(fit(dt, missing, upper))
    ismissing(upper.q) && return(fit(dt, lower, missing))
    θ_lower = -lower.q/log(1-lower.p)
    θ_upper = -upper.q/log(1-upper.p)
    θ_lower ≈ θ_upper || @warn("Averaging scale for lower and upper quantile " * 
        "for fitting expoenential distribution.")
    θ = (θ_lower + θ_upper)/2
    Exponential(θ)
end

function fit_mean_quantile(dt::Type{Exponential}, mean::Real, qp::QuantilePoint)
    # only fit to mean
    warning("ignoring upper quantile when fitting Exponential to mean.")
    fit_mean_quantile(dt, mean, missing)
end

function fit_mean_quantile(::Type{Exponential}, mean::Real, qp::Missing)
    fit(Type{Exponential}, AbstractMoments(mean))
end

function fit_mode_quantile(dt::Type{Exponential}, mode::Real, qp::QuantilePoint)
    # ignore mode (its always at 0)
    mode != zero(mode) && @warn("ignoring mode when fitting Exponential.")
    fit_mode_quantile(dt, missing, qp)
end


function fit_mode_quantile(::Type{Exponential}, mode::Missing, qp::QuantilePoint)
    θ = -qp.q/log(1-qp.p)
    Exponential(θ)
end
