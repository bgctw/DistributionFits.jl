using DistributionFits
using Test
using JET: JET
using Logging, LoggingExtras

@testset "JET" begin
    @static if VERSION ≥ v"1.9.2"
        logger = ActiveFilteredLogger(global_logger()) do args
            return !isnothing(match(r"overwritten in module .+ on the same line", args.message))
        end        
        with_logger(logger) do
            JET.test_package(DistributionFits; target_modules = (@__MODULE__,))
        end
    end
end;
# JET.report_package(DistributionFits) # to debug the errors
# JET.report_package(DistributionFits; target_modules=(@__MODULE__,)) # to debug the errors
