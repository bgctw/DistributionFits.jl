using DistributionFits
using Test
using Aqua

@testset "DistributionFits.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(
            DistributionFits;
            #unbound_args = false, # does not recognize NamedTuple{K, NTuple{N,E}}
            stale_deps = (ignore = [:Requires],),
            #ambiguities = false, # many ambiguities in Symbolic and Stats packages
            piracies = false
        )
    end;
    @testset "ambiguities package" begin
        Aqua.test_ambiguities(DistributionFits;)
    end;
    @testset "pircacy" begin
        Aqua.test_piracies(DistributionFits;
            treat_as_own = [LogitNormal] # TODO 
        )
    end;
end
