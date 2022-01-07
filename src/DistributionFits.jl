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
  @qs_cf90, @qs_cf95

# LogNormal
export AbstractΣstar, Σstar, σstar

# LogitNormal  
export fit_mode_flat

# dependency inversion: need to define DistributionFits.optimize by user
export set_optimize
"""
    set_optimize(f_optimize) 

`DistributionFits.jl` uses the following interface to opimize an univariate 
function `f` on bounded interval `[lower,upper]`:

    optimize(f, lower, upper)

Returning an object with fields `minimizer` and `converged`.

`set_optimize` tells the concrete implementation passed by `f_optimize` 
to `DistributionFits.jl`.

If package [Optim](https://julianlsolvers.github.io/Optim.jl/stable/) is in scope, then its
[optimize](https://julianlsolvers.github.io/Optim.jl/stable/#user/minimization/#minimizing-a-univariate-function-on-a-bounded-interval) 
function is set automatically. 

Hence, the module using DistribuitonFits.jl has to either

- explicitly tell `using Optim`, or
- call `set_optimize` with the concrete implementation of the interface

If the optimizer has not been set yet, then several functions in `Distribution.jl` 
fail with the error: `UndefVarError: optimize not defined`.
"""
set_optimize(f_optimize) = (global optimize = f_optimize)
function __init__()
  @require Optim="429524aa-4258-5aef-a3af-852621145aeb" optimize = Optim.optimize
end


# fitting distributions to stats
include("fitstats.jl")
include("univariates.jl")

end
