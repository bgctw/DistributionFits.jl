function fit(::Type{Normal}, m::AbstractMoments)
    n_moments(m) >= 2 || error("Need mean and variance to estimate normal")
    return Normal(mean(m),std(m))
end

function fit(::Type{Normal}, lower::QuantilePoint, upper::QuantilePoint)
    # https://www.johndcook.com/quantiles_parameters.pdf
    if (upper < lower) 
        lower,upper = (upper,lower)
    end
    qz1 = quantile(Normal(), lower.p)
    qz2 = quantile(Normal(), upper.p)
    dqz = (qz2 - qz1)
    σ = (upper.q - lower.q)/dqz
    μ = (lower.q*qz2 - upper.q*qz1)/dqz
    Normal(μ,σ)
end

fit_mean_quantile(D::Type{Normal}, mean::Real, qp::QuantilePoint) = 
    fit(D, QuantilePoint(mean, 0.5), qp)

fit_mode_quantile(D::Type{Normal}, mode::Real, qp::QuantilePoint) = 
    fit(D, QuantilePoint(mode, 0.5), qp)

println("loading normal.jl")    
