using DistributionFits
using Test
using Random: Random

@testset "optimize error" begin
    @test_throws Exception DistributionFits.optimize(x -> x*x, DistributionFits.optimizer, -1, 1)
end
using Optim: Optim, optimize
@testset "optimize set in __init__ after using Optim" begin
    # set in __init__
    @test DistributionFits.optimizer isa DistributionFits.OptimOptimizer
end

const tests = [
    "fitstats",
    "normal",
    "lognormal",
    "logitnormal",
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

