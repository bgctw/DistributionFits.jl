module DistributionFits

using Reexport
@reexport using Distributions

using FillArrays, StaticArrays
using Optim
import StatsFuns: logit, logistic, normcdf

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
  @qs_cf90, @qs_cf95

# LogNormal
export AbstractΣstar, Σstar, σstar

# LogitNormal  
export fit_mode_flat

# fitting distributions to stats
include("fitstats.jl")
include("univariates.jl")


end
