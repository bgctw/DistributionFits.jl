
@testset "Default partype" begin
    d = Exponential(2.1)
    # note: did not specify type parameter
    test_univariate_fits(d,Exponential)
end;

@testset "Float32" begin
    d = Exponential(2.1f0)
    test_univariate_fits(d)
end;

@testset "fit two quantiles same" begin
    qpl = @qp_m(3)
    d = fit(Exponential, qpl, qpl);
    @test quantile.(d, [qpl.p]) ≈ [qpl.q]
end;

