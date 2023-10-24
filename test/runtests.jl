using DistributionFits
using Test
using Random: Random
using LoggingExtras

#using Aqua; Aqua.test_all(DistributionFits) # ambiguities from other packages
#using JET; JET.report_package(DistributionFits) # 
#invalid possible error due to quantile may accept/return an Array (we pass a scalar)
#only report problems in this module:
#using JET; JET.report_package(DistributionFits; target_modules=(@__MODULE__,)) # 

@testset "optimize error" begin
    @test_throws Exception DistributionFits.optimize(x -> x * x, -1, 1)
end
# Optim package for interactive testing
i_loadlibs = () -> begin
    push!(LOAD_PATH, expanduser("~/julia/scimltools/")) # access local package repo
    push!(LOAD_PATH, expanduser("~/julia/18_tools/scimltools/")) # access local package repo
end
using Optim: Optim, optimize

DistributionFitsOptimExt = isdefined(Base, :get_extension) ?
                           Base.get_extension(DistributionFits, :DistributionFitsOptimExt) :
                           DistributionFits.DistributionFitsOptimExt

@testset "optimize set in __init__ after using Optim" begin
    # set in __init__
    @test DistributionFits.df_optimizer isa DistributionFitsOptimExt.OptimOptimizer
end

#include("test/testutils.jl")
include("testutils.jl")

#include("test/fitstats.jl")
include("fitstats.jl")

#include("test/univariate/test_univariate.jl")
include("univariate/test_univariate.jl")

# test coverage of set_optimize (already called  in init)

# print method ambiguities
println("Potentially stale exports: ")
display(Test.detect_ambiguities(DistributionFits))
println()

using JET: JET
@testset "JET" begin
   JET.test_package(DistributionFits; target_modules=(@__MODULE__,)) # 
end;

