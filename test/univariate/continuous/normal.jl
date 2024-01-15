@testset "Default partype" begin
    d = Normal(3, 2)
    # note: did not specify type parameter
    test_univariate_fits(d, Normal)
end;

@testset "Float32" begin
    d = Normal(3.0f0, 2.0f0)
    test_univariate_fits(d)
end;

@testset "fit_mean_Σ" begin
    m = 3.0f0
    σ = 2.0f0
    d = fit_mean_Σ(Normal, m, σ)
    @test mean(d) == m
    @test scale(d) == σ
end;
