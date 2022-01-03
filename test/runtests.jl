using DistributionFits
using Test
import Random

const tests = [
    "fitstats",
    "normal",
    "lognormal",
    "logitnormal",
]


for t in tests
    @testset "Test $t" begin
        Random.seed!(345679)
        include("$t.jl")
    end
end

# print method ambiguities
println("Potentially stale exports: ")
display(Test.detect_ambiguities(DistributionFits))
println()

