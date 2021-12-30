# function fit(::Type{LogitNormal}, m::AbstractMoments)
#     error("Fitting LogitNormal to moments not implemented.")
# end

function fit(::Type{LogitNormal}, lower::QuantilePoint, upper::QuantilePoint)
    lower_logit = QuantilePoint(lower, q = logit(lower.q))
    upper_logit = QuantilePoint(upper, q = logit(upper.q))
    DN = fit(Normal, lower_logit, upper_logit)
    LogitNormal(params(DN)...)
end

# function fit_mean_quantile(::Type{LogitNormal}, mean::Real, qp::QuantilePoint)
#     error("Fitting LogitNormal to mean and quantile not implemented.")
# end

# function fit_mode_quantile(::Type{LogitNormal}, mode::Real, qp::QuantilePoint)
#     error("for Fitting LogitNormal to mode and quantile see XXX.")
# end

