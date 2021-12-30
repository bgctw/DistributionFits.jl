@testset "fit moments" begin
    # there is no analytical mean nor var for logitnormal
end;
@testset "fit two quantiles" begin
    qpl = @qp_m(0.3)
    qpu = @qp_u(0.9)
    d = fit(LogitNormal, qpl, qpu);
    @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
    d = fit(LogitNormal, qpu, qpl) # sort
    @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
end;
@testset "fit to quantilepoint and mean" begin
    # not implemented
end;
@testset "fit to quantilepoint and mode" begin
    # see LogitNormals.jl
    # d = LogitNormal(1,1)
    # m = log(mode(d))
    # qp = @qp(quantile(d,0.95),0.95)
    # dfit = fit_mode_quantile(LogitNormal, mode(d), qp)
    # @test dfit ≈ d
    # dfit = fit(LogitNormal, mode(d), qp, Val(:mode))
    # @test dfit ≈ d
    # # with lower quantile
    # qp = @qp(quantile(d,0.025),0.025)
    # dfit = fit_mode_quantile(LogitNormal, mode(d), qp)
    # @test mode(dfit) ≈ mode(d) && quantile(dfit, qp.p) ≈ qp.q
end;
@testset "fit to quantilepoint and median" begin
    d = LogitNormal(1,1)
    qp = @qp(quantile(d,0.95),0.95)
    dfit = fit(LogitNormal, median(d), qp, Val(:median))
    @test dfit ≈ d
end;

