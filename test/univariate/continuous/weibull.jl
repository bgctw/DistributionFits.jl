@testset "Default partype" begin
    d = Weibull(1, 1)
    # note: did not specify type parameter
    test_univariate_fits(d, Weibull)
end;

@testset "Float32" begin
    d = Weibull(1.0f0, 1.0f0)
    test_univariate_fits(d)
end;
