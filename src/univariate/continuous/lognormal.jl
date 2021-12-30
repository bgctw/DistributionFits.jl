function fit(::Type{LogNormal}, m::AbstractMoments)
    # https://en.wikipedia.org/wiki/Log-normal_distribution
    n_moments(m) >= 2 || error("Need mean and variance to estimate lognormal")
    γ = 1+var(m)/mean(m)^2
    μ = log(mean(m)/sqrt(γ))
    σ = sqrt(log(γ))
    return LogNormal(μ,σ)
end

function fit(::Type{LogNormal}, lower::QuantilePoint, upper::QuantilePoint)
    #length(qset) == 2 || error("only implemented yet for exactly two quantiles.")
    #qset_log = [QuantilePoint(qp, q = log(qp.q)) for qp in qset]
    lower_log = QuantilePoint(lower, q = log(lower.q))
    upper_log = QuantilePoint(upper, q = log(upper.q))
    DN = fit(Normal, lower_log, upper_log)
    LogNormal(params(DN)...)
end

function fit_mean_quantile(::Type{LogNormal}, mean::Real, qp::QuantilePoint)
    # solution of
    # (1) mean = exp(mu + sigma^2/2)
    # (2) upper = mu + sigmaFac sigma
    # see R packaage lognorm inst/doc/coefLognorm.Rmd for derivation
    sigmaFac = quantile(Normal(),qp.p)
    m = log(mean)
    discr = sigmaFac^2 - 2*(log(qp.q) - m)
    (discr > 0) || error("Cannot fit LogNormal with quantile $(qp) and mean $(mean).")
    sigma = sigmaFac > sqrt(discr) ? (sigmaFac - sqrt(discr)) : sigmaFac + sqrt(discr)
    mu = m - sigma^2/2
    LogNormal(mu, sigma)
end

function fit_mode_quantile(::Type{LogNormal}, mode::Real, qp::QuantilePoint)
    # solution of
    # (1) mle = exp(mu - sigma^2)
    # (2) upper = mu + sigmaFac sigma
    # see R packaage lognorm inst/doc/coefLognorm.Rmd for derivation
    sigmaFac = quantile(Normal(),qp.p)
    m = log(mode)
    discr = sigmaFac^2/4 + (log(qp.q) - m)
    (discr > 0) || error("Cannot fit LogNormal with quantile $(qp) and mode $(mode).")
    root_discr = sqrt(discr)
    mfh = -sigmaFac/2
    sigma = mfh > root_discr ? (mfh - root_discr) : (mfh + root_discr)
    #sigma = mfh + root_discr
    mu = m + sigma^2
    LogNormal(mu, sigma)
end

