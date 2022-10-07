
@testset "fit moments" begin
    D = Laplace(1.1,2)
    m = Moments(mean(D), var(D))
    Dfit = fit(Laplace, m)
    @test D ≈ Dfit
    # handle not given any moment
    @test_throws Exception fit(Laplace, Moments(1.1))
end;

@testset "fit to quantilepoint and mode" begin
    d = Laplace(1.1,0.8)
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit_mode_quantile(Laplace, mode(d), qp)
    @test dfit ≈ d
    dfit = fit(Laplace, mode(d), qp, Val(:mode))
    @test dfit ≈ d
    # with lower quantile
    qp = @qp(quantile(d,0.025),0.025)
    dfit = fit_mode_quantile(Laplace, mode(d), qp)
    @test dfit ≈ d
end;

@testset "fit to quantilepoint and mean" begin
    # mode and mean are the same
    d = Laplace(1.1,0.8)
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit_mean_quantile(Laplace, mean(d), qp)
    @test dfit ≈ d
end;

@testset "fit two quantiles" begin
    qpl = @qp_m(3)
    qpu = @qp_u(5)
    d = fit(Laplace, qpl, qpu);
    #plot(d); 
    #plot!(fit_mode_quantile(Laplace, NaN, qpl))
    #plot!(fit_mode_quantile(Laplace, NaN, qpu))
    #vline!([3,5])
    @test quantile(d, qpl.p) == qpl.q
    @test quantile(d, qpu.p) == qpu.q
end;

