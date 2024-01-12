@testset "Default partype" begin
    d = LogNormal(1, 0.6)
    # note: did not specify type parameter
    test_univariate_fits(d, LogNormal)
end;

@testset "Float32" begin
    d = LogNormal(1.0f0, 0.6f0)
    test_univariate_fits(d)
end;

@testset "Σstar" begin
    ss = Σstar(4.5)
    @test ss() == 4.5
    @test eltype(Σstar(4.5f0)) == Float32
    @test eltype(Σstar{Float32}) == Float32
end;

@testset "fit to mean and Σstar" begin
    d = LogNormal(1, log(1.2))
    d_fit = fit(LogNormal, mean(d), Σstar(1.2))
    @test d == d_fit
    @test σstar(d) ≈ 1.2
    #
    dfit32 = fit(LogNormal, Float32(mean(d)), Σstar(1.2f0))
    @test partype(dfit32) === Float32
    #
    # former fit without type was type piracy
    # d_fit = fit(LogNormal, mean(d), log(1.2))
    # @test d == d_fit
    # @test σstar(d) ≈ 1.2
end;

@testset "fit_mean_relerror" begin
    d = fit_mean_relerror(LogNormal, 10.0, 0.03)
    @test all((mean(d), std(d) / mean(d)) .≈ (10.0, 0.03))
    #
    dfit32 = fit_mean_relerror(LogNormal, 10.0f0, 0.03f0)
    @test mean(dfit32) == 10.0
    @test std(dfit32) / mean(dfit32) ≈ 0.03
    @test partype(dfit32) === Float32
    #
    # plot(d); plot!(dfit32)
end;

@testset "fit_mode_quantile_0.5" begin
    # special for LogitNormal mode
    d = fit_mode_quantile(LogNormal, 0.5, @qp(0.9, 0.95))
    @test mode(d) ≈ 0.5
    @test quantile(d, 0.95) ≈ 0.9
    #
    dfit32 = fit_mode_quantile(LogNormal, 0.5f0, @qp(0.9, 0.95))
    @test partype(dfit32) === Float32
    @test mode(d) ≈ 0.5
    @test quantile(d, 0.95) ≈ 0.9
end;
