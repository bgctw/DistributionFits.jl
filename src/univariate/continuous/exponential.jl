

function fit(::Type{Exponential}, m::AbstractMoments)
    # https://en.wikipedia.org/wiki/Exponential_distribution
    n_moments(m) >= 1 || error("Need mean to estimate exponential")
    return Exponential(mean(m))
end

function fit(::Type{Exponential}, lower::QuantilePoint, upper::QuantilePoint)
    # return average for the two quantiles
    θ_lower = -lower.q/log(1-lower.p)
    θ_upper = -upper.q/log(1-upper.p)
    θ = (θ_lower + θ_upper)/2
    Exponential(θ)
end

function fit_mean_quantile(::Type{Exponential}, mean::Real, qp::QuantilePoint)
    # only fit to mean
    fit(Type{Exponential}, AbstractMoments(mean))
end

function fit_mode_quantile(::Type{Exponential}, mode::Real, qp::QuantilePoint)
    # ignore mode (its always at 0)
    θ = -qp.q/log(1-qp.p)
    Exponential(θ)
end
