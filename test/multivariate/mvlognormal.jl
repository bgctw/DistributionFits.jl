using PDMats
using DistributionFits
using Test

@testset "fit_mean_Σ" begin
    Σ = PDiagMat([0.6,0.7])
    μ = [1.2,1.2]
    d = MvLogNormal(μ, Σ)
    mean(d)
    d2 = fit_mean_Σ(MvLogNormal, mean(d), params(d)[2])
    @test d2 ≈ d rtol = 1e6
    #
    # Float32
    d2_f32 = fit_mean_Σ(MvLogNormal, Float32.(mean(d)), Float32.(params(d)[2]))
    @test d2 ≈ d rtol = 1e6
    @test partype(d2_f32) === Float32
end;
