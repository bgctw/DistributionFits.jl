using DistributionFits
using Test

# before loading Optim
@testset "optimize error" begin
    @test_throws Exception DistributionFits.optimize(x -> x * x, -1, 1)
end

# after loading Optim
using Optim: Optim, optimize

DistributionFitsOptimExt = isdefined(Base, :get_extension) ?
                           Base.get_extension(DistributionFits, :DistributionFitsOptimExt) :
                           DistributionFits.DistributionFitsOptimExt

@testset "optimize set in __init__ after using Optim" begin
    # set in __init__
    @test DistributionFits.df_optimizer isa DistributionFitsOptimExt.OptimOptimizer
end


