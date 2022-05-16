
# @testset "fit moments" begin
# end;

# @testset "fit to quantilepoint and mode - ignore mode" begin
# end;

# @testset "fit two quantiles same" begin
# end;

@testset "fit two quantiles" begin
    D = Weibull(1,1)
    #Plots.plot(D)
    median(D)
    qpl = @qp_m(median(D))
    qpu = @qp_u(quantile(D, 0.95))
    d = fit(Weibull, qpl, qpu);
    @test d == D
    #
    qpl = @qp_m(0.5)
    qpu = @qp_uu(5)
    d = fit(Weibull, qpl, qpu);
    @test median(d) == 0.5
    @test quantile(d, 0.975) ≈ 5
    #Plots.plot(d); 
end;

