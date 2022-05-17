# @testset "fit moments" begin
# end;

# @testset "fit to quantilepoint and mode - ignore mode" begin
# end;

# @testset "fit two quantiles same" begin
# end;

@testset "fit two quantiles" begin
    qpl = @qp_m(0.5)
    qpu = @qp_uu(5)
    d = fit(Gamma, qpl, qpu);
    @test median(d) ≈ 0.5
    @test quantile(d, 0.975) ≈ 5
    #Plots.plot(d); 
end;

i_tmp = () -> begin
    dw = fit(Weibull, @qp_m(0.5), @qp_uu(5));
    dg = fit(Gamma, @qp_m(0.5), @qp_uu(5));
    Plots.plot(dw)
    Plots.plot!(dg, xlim=(0,0.2))
    pdf(dw, 0)
    pdf(dg, 0)
    pdf(dw, 0.01)
    pdf(dg, 0.01)
end