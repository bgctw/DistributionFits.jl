d = Normal(3,2)
qp = @qp(quantile(d,0.95),0.95)

@testset "fit moments" begin
    dfit = DistributionFits.fit(Normal, moments(d))
    @test dfit ≈ d
    @test_throws ErrorException d = fit(Normal, Moments(3.0))
end;
@testset "fit two quantiles" begin
    qpl = @qp_m(3)
    qpu = @qp_u(5)
    dn = fit(Normal, qpl, qpu)
    @test quantile.(dn, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
    dn = fit(Normal, qpu, qpl) # check resorting arguments
    @test quantile.(dn, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
end;
@testset "fit to quantilepoint and mean" begin
    dfit = fit(Normal, mean(d), qp, Val(:mean))
    @test dfit ≈ d
end;
@testset "fit to quantilepoint and mode" begin
    dfit = fit(Normal, mode(d), qp, Val(:mode))
    @test dfit ≈ d
end;
@testset "fit to quantilepoint and median" begin
    dfit = fit(Normal, median(d), qp, Val(:median))
    @test dfit ≈ d
end;