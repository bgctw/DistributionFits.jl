using DistributionFits
using Test
using Random: Random

@testset "optimize error" begin
    @test_throws Exception DistributionFits.optimize(x -> x*x, -1, 1)
end
# Optim package for interactive testing
i_loadlibs = () -> begin
    push!(LOAD_PATH, expanduser("~/julia/scimltools/")) # access local package repo
    push!(LOAD_PATH, expanduser("~/julia/18_tools/scimltools/")) # access local package repo
end
using Optim: Optim, optimize

DistributionFitsOptimExt = isdefined(Base, :get_extension) ? Base.get_extension(DistributionFits, :DistributionFitsOptimExt) : DistributionFits.DistributionFitsOptimExt

@testset "optimize set in __init__ after using Optim" begin
    # set in __init__
    @test DistributionFits.df_optimizer isa DistributionFitsOptimExt.OptimOptimizer
end

const tests = [
    "fitstats",
    "normal",
    "lognormal",
    "logitnormal",
    "exponential",
    "laplace",
    "weibull",
    "gamma",
]
#tests = ["logitnormal"]


for t in tests
    @testset "Test $t" begin
        Random.seed!(345679)
        include("$t.jl")
    end
end

# test coverage of set_optimize (already called  in init)

# print method ambiguities
println("Potentially stale exports: ")
display(Test.detect_ambiguities(DistributionFits))
println()

