using DistributionFits
using Test
using Random: Random
using LoggingExtras
using Optim

pkgdir = dirname(dirname(pathof(DistributionFits)))
testdir = joinpath(pkgdir, "test")
include(joinpath(testdir,"testutils.jl"))

function test_univariate_fits(d, D = typeof(d))
    @testset "fit moments" begin
        if !occursin("fit(::Type{D}",
            string(first(methods(fit, (Type{typeof(d)}, AbstractMoments)))))
            m = Moments(mean(d), var(d))
            d_fit = fit(D, m)
            @test d ≈ d_fit
            @test partype(d_fit) == partype(d)
        end
    end
    @testset "fit two quantiles" begin
        qpl = @qp_l(quantile(d, 0.05))
        qpu = @qp_u(quantile(d, 0.95))
        d_fit = fit(D, qpl, qpu)
        @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
        d_fit = fit(D, qpl, qpu)
        @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
        d_fit = fit(D, qpu, qpl) # sort
        @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
        @test partype(d_fit) == partype(d)
    end
    @testset "fit two quantiles, function version" begin
        P = partype(d)
        qpl = qp_l(P(quantile(d, 0.05)))
        qpu = qp_u(P(quantile(d, 0.95)))
        d_fit = fit(D, qpl, qpu)
        @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
        d_fit = fit(D, qpl, qpu)
        @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
        d_fit = fit(D, qpu, qpl) # sort
        @test quantile.(d, [qpl.p, qpu.p]) ≈ [qpl.q, qpu.q]
        @test partype(d_fit) == partype(d)
    end
    @testset "typeof mean, mode equals partype" begin
        if !(d isa Gamma && first(params(d)) < 1)
            @test mean(d) isa partype(d)
            @test mode(d) isa partype(d)
        end
    end
    @testset "quantile is of eltype" begin
        # quantile still Float64 for Normal of eltype Float32
        if d isa Normal && eltype(d) != Float64
            @test_broken quantile(d, 0.1) isa eltype(d)
        else
            @test quantile(d, 0.1) isa eltype(d)
        end
        # quantile is sample-like: stick to eltype - special of normal
        # broken, because quantile Normal{Float32} returns Float32 
        # but eltype(D{Float32}) is Float64
        if d isa Union{LogNormal, LogitNormal, Exponential, Laplace, Weibull} &&
           partype(d) != eltype(d)
            @test_broken quantile(d, 0.1f0) isa eltype(d)
        else
            @test quantile(d, 0.1f0) isa eltype(d)
        end
    end
    @testset "fit to quantilepoint and mean" begin
        if !occursin("fit_mean_quantile(::Type{D}",
            string(first(methods(fit_mean_quantile,
                (Type{typeof(d)}, partype(d), QuantilePoint)))))
            m = log(mean(d))
            qp = @qp_u(quantile(d, 0.95))
            logger = d isa Exponential ? MinLevelLogger(current_logger(), Logging.Error) :
                     current_logger()
            with_logger(logger) do
                d_fit = fit_mean_quantile(D, mean(d), qp)
                @test d_fit ≈ d
                @test partype(d_fit) == partype(d)
                d_fit = fit(D, mean(d), qp, Val(:mean))
                @test d_fit ≈ d
                @test partype(d_fit) == partype(d)
                # with lower quantile
                qp = @qp_l(quantile(d, 0.05))
                d_fit = fit_mean_quantile(D, mean(d), qp)
                @test d_fit ≈ d
                @test partype(d_fit) == partype(d)
            end
            # very close to mean can give very different results:
            # qp = @qp(mean(d)-1e-4,0.95)
            # d_fit = fit_mean_quantile(D, mean(d), qp)
            # @test mean(d_fit) ≈ mean(d) && quantile(d_fit, qp.p) ≈ qp.q
        end
    end
    @testset "fit to quantilepoint and mode" begin
        if !(d isa Gamma && first(params(d)) < 1) &&
           !(d isa Weibull)
            qp = qp_u(quantile(d, 0.95))
            d_fit = fit_mode_quantile(D, mode(d), qp)
            @test d_fit≈d atol=0.1
            d_fit = fit(D, mode(d), qp, Val(:mode))
            @test d_fit≈d atol=0.1
            @test partype(d_fit) == partype(d)
            # with lower quantile
            qp = qp_ll(quantile(d, 0.025))
            d_fit = fit(D, mode(d), qp, Val(:mode))
            @test mode(d_fit) ≈ mode(d)
            @test quantile(d_fit, qp.p)≈qp.q atol=0.01
            @test partype(d_fit) == partype(d)
        end
    end
    @testset "fit to quantilepoint and median" begin
        qp = @qp_u(quantile(d, 0.95))
        logger = d isa Exponential ? MinLevelLogger(current_logger(), Logging.Error) :
                 current_logger()
        with_logger(logger) do
            d_fit = fit(D, median(d), qp, Val(:median))
            @test d_fit ≈ d
            @test partype(d_fit) == partype(d)
        end
    end
end


const tests = [
    "weibull",
    "normal",
    "lognormal",
    "logitnormal",
    "exponential",
    "laplace",
    "gamma",
]
#tests = ["logitnormal"]

for t in tests
    @testset "Test $t" begin
        Random.seed!(345679)
        include(joinpath(testdir,"univariate","continuous","$t.jl"))
    end
end
