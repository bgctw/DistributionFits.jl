using DistributionFits
using Test
using Random: Random
using LoggingExtras


tmpf = () -> begin
    push!(LOAD_PATH, expanduser("~/julia/devtools/")) # access local pack
    push!(LOAD_PATH, joinpath(pwd(), "test/")) # access local pack
end

using Test, SafeTestsets
const GROUP = get(ENV, "GROUP", "All") # defined in in CI.yml
@show GROUP

# @time begin
#     if GROUP == "All" || GROUP == "Basic"
#         #@safetestset "Tests" include("test/test_plant_face_fluct.jl")
#         @time @safetestset "plant_face_fluct" include("test_plant_face_fluct.jl")
#     end
#     if GROUP == "All" || GROUP == "JET"
#         #@safetestset "Tests" include("test/test_JET.jl")
#         @time @safetestset "test_JET" include("test_JET.jl")
#         #@safetestset "Tests" include("test/test_aqua.jl")
#         @time @safetestset "test_Aqua" include("test_aqua.jl")
#     end
# end


#using Aqua; Aqua.test_all(DistributionFits) # ambiguities from other packages
#using JET; JET.report_package(DistributionFits) # 
#invalid possible error due to quantile may accept/return an Array (we pass a scalar)
#only report problems in this module:
#using JET; JET.report_package(DistributionFits; target_modules=(@__MODULE__,)) # 

@testset "optimize error" begin
    @test_throws Exception DistributionFits.optimize(x -> x * x, -1, 1)
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
    @static if VERSION ≥ v"1.9.2"
        JET.test_package(DistributionFits; target_modules=(@__MODULE__,)) # 
    end    
end;

