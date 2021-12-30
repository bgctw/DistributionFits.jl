@testset "fit moments" begin
    D = LogNormal(1,0.6)
    M = Moments(mean(D), var(D))
    Dfit = fit(LogNormal, M)
    @test D ≈ Dfit
    # handle not giving variance
    @test_throws Exception fit(LogNormal, Moments(3.2))
end;
@testset "fit two quantiles" begin
    qpl = @qp_m(3)
    qpu = @qp_u(5)
    d = fit(LogNormal, qpl, qpu);
    @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
    d = fit(LogNormal, qpu, qpl) # sort
    @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
end;
@testset "fit to quantilepoint and mean" begin
    d = LogNormal(1,1)
    m = log(mean(d))
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit_mean_quantile(LogNormal, mean(d), qp)
    @test dfit ≈ d
    dfit = fit(LogNormal, mean(d), qp, Val(:mean))
    @test dfit ≈ d
    # with lower quantile
    qp = @qp(quantile(d,0.05),0.05)
    dfit = fit_mean_quantile(LogNormal, mean(d), qp)
    @test dfit ≈ d
    # very close to mean can give very different results:
    qp = @qp(mean(d)-1e-4,0.95)
    dfit = fit_mean_quantile(LogNormal, mean(d), qp)
    @test mean(dfit) ≈ mean(d) && quantile(dfit, qp.p) ≈ qp.q
end;
@testset "fit to quantilepoint and mode" begin
    d = LogNormal(1,1)
    m = log(mode(d))
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit_mode_quantile(LogNormal, mode(d), qp)
    @test dfit ≈ d
    dfit = fit(LogNormal, mode(d), qp, Val(:mode))
    @test dfit ≈ d
    # with lower quantile
    qp = @qp(quantile(d,0.025),0.025)
    dfit = fit_mode_quantile(LogNormal, mode(d), qp)
    @test mode(dfit) ≈ mode(d) && quantile(dfit, qp.p) ≈ qp.q
end;
@testset "fit to quantilepoint and median" begin
    d = LogNormal(1,1)
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit(LogNormal, median(d), qp, Val(:median))
    @test dfit ≈ d
end;

