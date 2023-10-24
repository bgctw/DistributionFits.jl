"""
    AbstractDistributionFitOptimizer
    OptimOptimizer <: AbstractDistributionFitOptimizer
    set_optimizer(::AbstractDistributionFitOptimizer) 

`DistributionFits.jl` uses the following interface to opimize an univariate 
function `f` on bounded interval `[lower,upper]`:

    optimize(f, ::AbstractDistributionFitOptimizer, lower, upper)

Returning an object with fields `minimizer` and `converged`.

`DistributionFits.set_optimizer(::AbstractDistributionFitOptimizer)` 
sets the specific AbstractDistributionFitOptimizer that is used 
throughout the package for calling the optimize function. 
Specializing this function with a concrete type, allows using different
optimization packages. 

By default, when the [Optim.jl](https://julianlsolvers.github.io/Optim.jl/stable/) 
package is in scope, the
`OptimOptimizer` is set, which implements the interface by using Optim's 
[optimize](https://julianlsolvers.github.io/Optim.jl/stable/#user/minimization/#minimizing-a-univariate-function-on-a-bounded-interval) function.

Hence, the module using `DistributionFits.jl` has to either

- explicitly invoke `using Optim`, or
- call `set_optimizer` with the concrete subtype of `AbstractDistributionFitOptimizer`
  for which the corresponding `optimize` method is implemented. 
    
Developers implementing usage of a different specific optimizer see code in 
ext/DistributionFitsOptimExt.
"""
abstract type AbstractDistributionFitOptimizer end
struct NotSetOptimizer <: AbstractDistributionFitOptimizer end

# see to ext/DistributionFitsOptimExt.jl

function optimize(f, ::NotSetOptimizer, lower, upper)
    error("Optimizer not set yet. Either invoke 'using Optim' " *
          "or 'DistributionFits.set_optimizer(...)'.")
end

df_optimizer = NotSetOptimizer();
optimize(f, lower, upper) = optimize(f, df_optimizer, lower, upper)
set_optimizer(opt::AbstractDistributionFitOptimizer) = (global df_optimizer = opt)
