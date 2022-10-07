function fit(::Type{Laplace}, m::AbstractMoments)
    # https://en.wikipedia.org/wiki/Laplace_distribution
    #    θ corresponds to b
    n_moments(m) >= 2 || error("Need mean and variance to estimate Laplace distribution.")
    μ = mean(m)
    θ = sqrt(var(m)/2)
    Laplace(μ,θ)
end

function fit(::Type{Laplace}, lower::QuantilePoint, upper::QuantilePoint)
    # q = F^-1(p) = μ - θ a(p)
    a = (p) -> sign(p-0.5) * log(1-2*abs(p-0.5))
    a_lower, a_upper = a(lower.p), a(upper.p)
    θ = (upper.q - lower.q)/(a_lower - a_upper)
    μ = upper.q + θ * a_upper
    Laplace(μ,θ)
end

function fit_mode_quantile(::Type{Laplace}, mode::Real, qp::QuantilePoint)
    a = (p) -> sign(p-0.5) * log(1-2*abs(p-0.5))
    a_qp = a(qp.p)
    #θ = (qp.q - mode)/(0 - a_qp)
    θ = (mode - qp.q)/a_qp
    Laplace(mode,θ)
end

function fit_mean_quantile(::Type{Laplace}, mean::Real, qp::QuantilePoint)
    fit_mode_quantile(Laplace, mean, qp)
end

