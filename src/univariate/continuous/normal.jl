fit(::Type{Normal}, m::AbstractMoments) = fit(Normal{eltype(m)}, m)
function fit(::Type{Normal{T}}, m::AbstractMoments) where T
    n_moments(m) >= 2 || error("Need mean and variance to estimate normal")
    return Normal(T(mean(m)),T(std(m)))
end

function fit(::Type{Normal}, lower::QuantilePoint, upper::QuantilePoint)
    fit(Normal{Float64}, lower, upper)
end
function fit(::Type{Normal{T}}, lower::QuantilePoint, upper::QuantilePoint) where T
    # https://www.johndcook.com/quantiles_parameters.pdf
    if (upper < lower) 
        lower,upper = (upper,lower)
    end
    q_lower, q_upper = promote(lower.q, upper.q)
    TQ = typeof(q_lower)
    qz1 = convert(TQ, quantile(Normal(), lower.p))::TQ
    qz2 = convert(TQ, quantile(Normal(), upper.p))::TQ
    dqz = (qz2 - qz1)
    σ = (q_upper - q_lower)/dqz
    μ = (q_lower*qz2 - q_upper*qz1)/dqz
    Normal(T(μ),T(σ))
end

fit_mean_quantile(::Type{Normal}, mean::T, qp::QuantilePoint) where T <: Real = 
    fit(Normal{T}, mean, qp)
fit_mean_quantile(D::Type{Normal{T}}, mean::Real, qp::QuantilePoint) where T = 
    fit(D, QuantilePoint(mean, 0.5), qp)

fit_mode_quantile(::Type{Normal}, mode::T, qp::QuantilePoint) where T <: Real = 
    fit(Normal{T}, mode, qp)
fit_mode_quantile(D::Type{Normal{T}}, mode::Real, qp::QuantilePoint) where T = 
    fit(D, QuantilePoint(mode, 0.5), qp)
    