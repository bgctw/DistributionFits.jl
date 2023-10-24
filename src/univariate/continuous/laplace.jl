function fit(::Type{Laplace}, m::AbstractMoments)
    fit(Laplace{eltype(m)}, m)
end
function fit(::Type{Laplace{T}}, m::AbstractMoments) where {T}
    # https://en.wikipedia.org/wiki/Laplace_distribution
    #    θ corresponds to b
    n_moments(m) >= 2 || error("Need mean and variance to estimate Laplace distribution.")
    μ = mean(m)
    θ = sqrt(var(m) / 2)
    Laplace(T(μ), T(θ))
end

function fit(::Type{Laplace}, lower::QuantilePoint, upper::QuantilePoint)
    fit(Laplace{Float64}, lower, upper)
end
function fit(::Type{Laplace{T}}, lower::QuantilePoint, upper::QuantilePoint) where {T}
    # q = F^-1(p) = μ - θ a(p)
    a = (p) -> sign(p - 0.5) * log(1 - 2 * abs(p - 0.5))
    a_lower, a_upper = a(lower.p), a(upper.p)
    θ = (upper.q - lower.q) / (a_lower - a_upper)
    μ = upper.q + θ * a_upper
    Laplace(T(μ), T(θ))
end

function fit_mode_quantile(::Type{Laplace}, mode::T, qp::QuantilePoint) where {T <: Real}
    fit_mode_quantile(Laplace{T}, mode, qp)
end
function fit_mode_quantile(::Type{Laplace{T}}, mode::Real, qp::QuantilePoint) where {T}
    a = (p) -> sign(p - 0.5) * log(1 - 2 * abs(p - 0.5))
    a_qp = a(qp.p)
    #θ = (qp.q - mode)/(0 - a_qp)
    θ = (mode - qp.q) / a_qp
    Laplace(T(mode), T(θ))
end

function fit_mean_quantile(D::Type{<:Laplace}, mean::Real, qp::QuantilePoint)
    # mode equals mean
    fit_mode_quantile(D, mean, qp)
end
