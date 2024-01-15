using DistributionFits
using Test

@testset "fit_mean_Σ" begin
    m = [3.0f0, 4.0f0]
    Σ = hcat([2.0f0,0.2],[0.2, 2.0f0])
    d = fit_mean_Σ(MvNormal, m, Σ)
    @test mean(d) == m
    @test cov(d) == Σ
end;

