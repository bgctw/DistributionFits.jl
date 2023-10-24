@testset "Default partype" begin
    d = LogitNormal(1.3)
    # note: did not specify type parameter
    test_univariate_fits(d, LogitNormal)
end;

@testset "Float32" begin
    d = LogitNormal(1.3f0)
    test_univariate_fits(d)
end;

@testset "numerical moments" begin
    DN = LogitNormal(1.3)
    x = rand(DN, 1_000_000)
    m = mean(DN)
    @test abs(m - mean(x)) / mean(x) <= 1e-3
    s2 = var(DN)
    @test abs(s2 - var(x)) / var(x) <= 1e-2 #1e-4 too strong for random numbers
    s2m = var(DN; mean = m) # specify so that not need to recompute
    @test abs(s2m - var(x)) / var(x) <= 1e-2 #1e-4 too strong for random numbers
    sd = std(DN) # specify so that not need to recompute
    @test abs(sd - std(x)) / std(x) <= 1e-2 #1e-4 too strong for random numbers
    # sd2 = std(DN, mean=m) # specify so that not need to recompute
    # @test abs(sd2 - std(x))/std(x) <= 1e-2 #1e-4 too strong for random numbers
    #
    DN32 = LogitNormal(1.3f0)
    @test partype(DN32) == Float32
    x = rand(DN32, 1_000_000)
    # TODO: specify Type of sample with distribution creation?
    m = mean(DN32)
    @test m isa Float32
    s2 = var(DN32)
    @test s2 isa Float32
    @test abs(s2 - var(x)) / var(x) <= 1e-2 #1e-4 too strong for random numbers
    s2m = var(DN32; mean = m) # specify so that not need to recompute
    @test s2m isa Float32
    @test abs(s2m - var(x)) / var(x) <= 1e-2 #1e-4 too strong for random numbers
    sd = std(DN32) # specify so that not need to recompute
    @test sd isa Float32
    @test abs(sd - std(x)) / std(x) <= 1e-2 #1e-4 too strong for random numbers
end;

###### numerical estimation of moments
@testset "Logitnormal seek mode" begin
    #plot(g); vline!([mode(g)])
    # median
    g = LogitNormal()
    test_mode_larger_than_neighbors(g)
    g = LogitNormal(0, 1.4)
    test_mode_larger_than_neighbors(g)
    # larger one of two modes, infer the lower one
    g = LogitNormal(0, 1.6)
    test_mode_larger_than_neighbors(g)
    # two modes, larger is on the right
    g = LogitNormal(0.1, 1.6)
    test_mode_larger_than_neighbors(g)
    # two modes, larger is on the left
    g = LogitNormal(-0.1, 1.6)
    test_mode_larger_than_neighbors(g)
    #
    # test with Float32
    g = LogitNormal(0.0f0, 1.4f0)
    @test partype(g) == Float32
    test_mode_larger_than_neighbors(g)
end

function is_logit_slope_monotone(d, upper = 0.5, lower = 0.0, decreasing = false)
    x = range(lower, upper; length = 41)[2:40]# plotting grid
    dx = pdf.(d, x)#density function
    if decreasing
        all(diff(dx) .<= 0)
    else
        all(diff(dx) .>= 0)
    end
end

@testset "fit by single mode and flat" begin
    d9 = d = fit_mode_flat(LogitNormal, 0.9)
    @test isapprox(mode(d), 0.9, atol = 1e-4)
    @test is_logit_slope_monotone(d, 0.9)
    @test is_logit_slope_monotone(d, 0.0, 0.9, true)
    d1 = d = fit_mode_flat(LogitNormal, 0.1)
    @test isapprox(mode(d), 0.1, atol = 1e-4)
    @test is_logit_slope_monotone(d, 0.1)
    @test is_logit_slope_monotone(d, 0.0, 0.1, true)
    @test d1.σ == d9.σ
    @test d1.μ == -d9.μ
    d5 = d = fit_mode_flat(LogitNormal, 0.5)
    @test isapprox(mode(d), 0.5, atol = 1e-4)
    @test is_logit_slope_monotone(d, 0.5)
    @test is_logit_slope_monotone(d, 0.0, 0.5, true)
    #plot(d1)
    #
    d32 = fit_mode_flat(LogitNormal{Float32}, 0.9)
    @test partype(d32) == Float32
    d32 = fit_mode_flat(LogitNormal, 0.9f0)
    @test partype(d32) == Float32
end

@testset "shifloNormal" begin
    d = shifloNormal(1, 3)
    @test isapprox(mode(d), 2.0, atol = 0.001)
    @test minimum(d) == 1.0
    @test maximum(d) == 3.0
    @test scale(d) == 3 - 1
    @test location(d) == 1.0
    #plot(d)
end;

# @testset "LocationScale Float32" begin
#     dln = LogitNormal{Float32}(0f0, sqrt(2f0))
#     dshifted = dln * 2f0 + 1f0
#     @test_broken params(dshifted)[1] isa Float32
#     @test_broken mean(dshifted) isa Float32
#     #plot(d)
# end;

@testset "shifloNormal Float32" begin
    d32 = shifloNormal(1.0f0, 3.0f0)
    @test partype(d32) == Float32
    @test mean(d32) isa Float32
    # wait until fix in AffineDistribution is merged to Distributions.jl
    # @test rand(d32) isa eltype(d32)
    m = mode(d32)
    @test m isa Float32
    @test isapprox(m, 2.0, atol = 0.1)
    dmin = minimum(d32)
    @test dmin == 1.0
    @test maximum(d32) == 3.0
    @test scale(d32) == 3 - 1
    @test scale(d32) isa Float32
    @test location(d32) == 1.0
    @test location(d32) isa Float32
    #plot(d)
    #dln = LogitNormal(0f0,sqrt(2f0)); plot!(dln)
end;
