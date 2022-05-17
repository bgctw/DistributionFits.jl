# function fit(::Type{Gamma}, m::AbstractMoments)
#     # https://en.wikipedia.org/wiki/Gamma_distribution
#     n_moments(m) >= 1 || error("Need mean to estimate exponential")
#     return Gamma(mean(m))
# end

function fit(::Type{Gamma}, lower::QuantilePoint, upper::QuantilePoint)
    # https://www.johndcook.com/quantiles_parameters.pdf
    #    Shape-scale paras, shape α - cook:α - w:k, scale θ - cook:β - w:θ
    0 < lower.p < upper.p < 1 || error(
        "Expected 0 < lower.p < upper.p < 1, but got " * 
        "lower.p = $(lower.p) and upper.p = $(upper.p)")
    0 < lower.q < upper.q || error(
        "Expected 0 < lower.q < upper.q, but got " *
        "lower.q = $(lower.q) and upper.q = $(upper.q)")
    logp1 = log(lower.p)
    logp2 = log(upper.p)
    lhs = upper.q/lower.q
    #α = 1
    fcost = (α) -> begin
        gamma1 = Gamma(α,1)
        rhs = invlogcdf(gamma1, logp2)/invlogcdf(gamma1, logp1)
        abs2(rhs - lhs)
    end
    resOpt = optimize(fcost, 1e-2, 1e8)
    resOpt.converged || error("Could not fit distribution to quantiles. resOpt=$resOpt")
    α_opt = resOpt.minimizer
    fbeta(α) = lower.q / invlogcdf(Gamma(α,1), log(lower.p))
    Gamma(α_opt, fbeta(α_opt))
end

# function fit_mean_quantile(::Type{Gamma}, mean::Real, qp::QuantilePoint)
#     # only fit to mean
#     fit(Type{Gamma}, AbstractMoments(mean))
# end

# function fit_mode_quantile(::Type{Gamma}, mode::Real, qp::QuantilePoint)
#     # ignore mode (its always at 0)
#     θ = -qp.q/log(1-qp.p)
#     Gamma(θ)
# end


