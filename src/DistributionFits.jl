module DistributionFits

using Reexport
@reexport using Distributions

using FillArrays, StaticArrays
using StatsFuns: logit, logistic, normcdf

if !isdefined(Base, :get_extension)
  using Requires
end

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

# document but do not export - need to qualify by 'DistributionFits.'
# export
#   # Optimizer detail
#   optimize, set_optimizer  

# LogNormal
export AbstractΣstar, Σstar, σstar

# LogitNormal  
export fit_mode_flat, shifloNormal

# dependency inversion: need to define DistributionFits.optimize by user
export AbstractDistributionFitOptimizer, optimize

include("optimizer.jl")


function __init__()
  @static if !isdefined(Base, :get_extension)
    @require Optim="429524aa-4258-5aef-a3af-852621145aeb" include("../ext/DistributionFitsOptimExt.jl")
  end
end

# fitting distributions to stats
include("fitstats.jl")
include("univariates.jl")

end
