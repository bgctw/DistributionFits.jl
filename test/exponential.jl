
@testset "fit moments" begin
    D = Exponential(2.1)
    M = Moments(mean(D))
    Dfit = fit(Exponential, M)
    @test D ≈ Dfit
    # handle not given any moment
    @test_throws Exception fit(Exponential, Moments())
end;

@testset "fit to quantilepoint and mode - ignore mode" begin
    d = Exponential(0.8)
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit_mode_quantile(Exponential, mode(d), qp)
    @test dfit ≈ d
    dfit = fit(Exponential, mode(d), qp, Val(:mode))
    @test dfit ≈ d
    # with lower quantile
    qp = @qp(quantile(d,0.025),0.025)
    dfit = fit_mode_quantile(Exponential, mode(d), qp)
    @test dfit ≈ d
end;

@testset "fit two quantiles same" begin
    qpl = @qp_m(3)
    d = fit(Exponential, qpl, qpl);
    @test quantile.(d, [qpl.p]) ≈ [qpl.q]
end;

@testset "fit two quantiles" begin
    qpl = @qp_m(3)
    qpu = @qp_u(5)
    d = @test_logs (:warn,) fit(Exponential, qpl, qpu);
    #plot(d); 
    #plot!(fit_mode_quantile(Exponential, NaN, qpl))
    #plot!(fit_mode_quantile(Exponential, NaN, qpu))
    #vline!([3,5])
    @test quantile(d, qpl.p) < qpl.q
    @test quantile(d, qpu.p) > qpu.q
    #
    d = fit(Exponential, missing, qpu);
    @test quantile.(d, [qpu.p]) ≈ [qpu.q]
    d = fit(Exponential, qpl, missing);
    @test quantile.(d, [qpl.p]) ≈ [qpl.q]
end;

