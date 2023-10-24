# function fit(::Type{Exponential}, m::AbstractMoments)
#     # https://en.wikipedia.org/wiki/Exponential_distribution
#     n_moments(m) >= 1 || error("Need mean to estimate exponential")
#     return Exponential(mean(m))
# end

function fit(::Type{Weibull}, lower::QuantilePoint, upper::QuantilePoint)
    fit(Weibull{Float64}, lower, upper)
end
function fit(::Type{Weibull{T}}, lower::QuantilePoint, upper::QuantilePoint) where {T}
    # https://www.johndcook.com/quantiles_parameters.pdf
    gamma = (log(-log(1 - upper.p)) - log(-log(1 - lower.p))) /
            (log(upper.q) - log(lower.q))
    beta = lower.q / (-log(1 - lower.p))^(1 / gamma)
    Weibull(T(gamma), T(beta))
end

# function fit_mean_quantile(::Type{Exponential}, mean::Real, qp::QuantilePoint)
#     # only fit to mean
#     fit(Type{Exponential}, AbstractMoments(mean))
# end

# function fit_mode_quantile(::Type{Exponential}, mode::Real, qp::QuantilePoint)
#     # ignore mode (its always at 0)
#     θ = -qp.q/log(1-qp.p)
#     Exponential(θ)
# end
