using DistributionFits
using Test
using JET: JET

@testset "JET" begin
    @static if VERSION ≥ v"1.9.2"
        JET.test_package(DistributionFits; target_modules = (@__MODULE__,))
    end
end;
# JET.report_package(DistributionFits) # to debug the errors
# JET.report_package(DistributionFits; target_modules=(@__MODULE__,)) # to debug the errors
