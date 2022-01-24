function optimize(f, ::OptimOptimizer, lower, upper) 
    result = Optim.optimize(f, lower, upper)
    (;minimizer = result.minimizer, converged = result.converged, result)
end

@info "DistributionFits: setting OptimOptimizer"
DistributionFits.set_optimizer(OptimOptimizer())
