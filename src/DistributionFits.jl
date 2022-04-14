module DistributionFits

using Reexport
@reexport using Distributions

using FillArrays, StaticArrays
using StatsFuns: logit, logistic, normcdf
using Requires: @require 

# for extension
import Distributions: mean, var, mode
import StatsBase: fit
# Moments also extends getindex, mean, kurtorsis ....

export 
  # fitting distributions
  AbstractMoments, Moments, n_moments, moments,
  QuantilePoint, 
  fit_mean_quantile, fit_mode_quantile, fit_median_quantile,
  @qp, @qp_ll, @qp_l, @qp_m, @qp_u, @qp_uu, 
  @qs_cf90, @qs_cf95,
  fit_mean_relerror

# LogNormal
export AbstractΣstar, Σstar, σstar

# LogitNormal  
export fit_mode_flat, shifloNormal

# dependency inversion: need to define DistributionFits.optimize by user
export AbstractDistributionFitOptimizer, optimize


include("optimizer.jl")

function __init__()
  @require Optim="429524aa-4258-5aef-a3af-852621145aeb" include("requires_optim.jl")
end

# fitting distributions to stats
include("fitstats.jl")
include("univariates.jl")

end
