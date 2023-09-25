@testset "Default partype" begin
    d = LogNormal(1,0.6)
    # note: did not specify type parameter
    test_univariate_fits(d,LogNormal)
    # handle not giving variance
    @test_throws Exception fit(typeof(d), Moments(3.2))

end;

@testset "fit moments Float32" begin
    d = LogNormal(1f0,0.6f0)
    @test partype(d) === Float32
    test_univariate_fits(d)
end;

@testset "fit to quantilepoint and mean" begin
    d = LogNormal(1.,1.)
    m = log(mean(d))
    qp = @qp(quantile(d,0.95),0.95)
    d_fit = fit_mean_quantile(LogNormal, mean(d), qp)
    @test d_fit ≈ d
    d_fit = fit(LogNormal, mean(d), qp, Val(:mean))
    @test d_fit ≈ d
    # with lower quantile
    qp = @qp(quantile(d,0.05),0.05)
    d_fit = fit_mean_quantile(LogNormal, mean(d), qp)
    @test d_fit ≈ d
    # very close to mean can give very different results:
    qp = @qp(mean(d)-1e-4,0.95)
    d_fit = fit_mean_quantile(LogNormal, mean(d), qp)
    @test mean(d_fit) ≈ mean(d) && quantile(d_fit, qp.p) ≈ qp.q
    #
    #qp32 = @qp(Float32(quantile(d,0.95f0)),0.95f0)
    qp = @qp(quantile(d,0.95f0),0.95)
    dfit32 = fit_mean_quantile(LogNormal, Float32(mean(d)), qp)
    @test partype(dfit32) === Float32
end;
@testset "fit to quantilepoint and mode" begin
    d = LogNormal(1,1)
    m = log(mode(d))
    qp = @qp(quantile(d,0.95),0.95)
    d_fit = fit_mode_quantile(LogNormal, mode(d), qp)
    @test d_fit ≈ d
    d_fit = fit(LogNormal, mode(d), qp, Val(:mode))
    @test d_fit ≈ d
    # with lower quantile
    qp = @qp(quantile(d,0.025),0.025)
    d_fit = fit_mode_quantile(LogNormal, mode(d), qp)
    @test mode(d_fit) ≈ mode(d) && quantile(d_fit, qp.p) ≈ qp.q
    #
    qp32 = @qp(Float32(quantile(d,0.25f0)),0.25f0)
    dfit32 = fit_mode_quantile(LogNormal, Float32(mode(d)), qp32)
    @test partype(dfit32) === Float32
end;
@testset "fit to quantilepoint and median" begin
    d = LogNormal(1,1)
    qp = @qp(quantile(d,0.95),0.95)
    d_fit = fit(LogNormal, median(d), qp, Val(:median))
    @test d_fit ≈ d
    #
    # median does not define type
    #qp32 = @qp(Float32(quantile(d,0.25f0)),0.25f0)
    #dfit32 = fit(LogNormal, Float32(median(d)), qp32, Val(:median))
    dfit32 = fit(LogNormal{Float32}, median(d), qp, Val(:median))
    @test partype(dfit32) === Float32
end;

@testset "Σstar" begin
    ss = Σstar(4.5)
    @test ss() == 4.5
end;

@testset "fit to mean and Σstar" begin
    d = LogNormal(1, log(1.2))
    d_fit = fit(LogNormal, mean(d), Σstar(1.2))
    @test d == d_fit
    @test σstar(d) ≈ 1.2
    #
    dfit32 = fit(LogNormal, Float32(mean(d)), Σstar(1.2f0))
    @test partype(dfit32) === Float32
end;

@testset "fit_mean_relerror" begin
    d = fit_mean_relerror(LogNormal, 10.0, 0.03);
    @test all((mean(d), std(d)/mean(d)) .≈ (10.0, 0.03))
    #
    dfit32 = fit_mean_relerror(LogNormal, 10.0f0, 0.03f0)
    @test mean(dfit32) == 10.0
    @test std(dfit32)/mean(dfit32) ≈ 0.03
    @test partype(dfit32) === Float32
    #
    # plot(d); plot!(dfit32)
end;

