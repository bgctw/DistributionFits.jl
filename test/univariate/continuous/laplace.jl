
@testset "Default partype" begin
    d = Laplace(1.1, 2)
    # note: did not specify type parameter
    test_univariate_fits(d, Laplace)
end;

@testset "Float32" begin
    d = Laplace(1.1f0, 2.0f0)
    test_univariate_fits(d)
end;
