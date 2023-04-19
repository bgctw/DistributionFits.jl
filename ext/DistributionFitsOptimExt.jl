module DistributionFitsOptimExt

isdefined(Base, :get_extension) ? (using Optim) : (using ..Optim)
using DistributionFits: DistributionFits, optimize, AbstractDistributionFitOptimizer

struct OptimOptimizer <:  AbstractDistributionFitOptimizer; end

function DistributionFits.optimize(f, ::OptimOptimizer, lower, upper) 
    result = Optim.optimize(f, lower, upper)
    (;minimizer = result.minimizer, converged = result.converged, result)
end

function __init__()
    @info "DistributionFits: setting OptimOptimizer"
    #DistributionFits.set_optimizer(DistributionFitsOptimExt.OptimOptimizer())
    DistributionFits.set_optimizer(OptimOptimizer())
end

end