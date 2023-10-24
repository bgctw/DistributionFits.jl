# estimate the mean by numerical integration over uniform percentiles
function estimateMean(d::ContinuousUnivariateDistribution; kwargs...)
    meanFunOfProb(d; kwargs..., fun = (d, p) -> quantile(d, p))
end

# estimate variance by numerical integration over uniform percentiles
function estimateVariance(d::ContinuousUnivariateDistribution; mean = missing, kwargs...)
    m = ismissing(mean) ? Distributions.mean(d) : mean
    function squaredDiff(d, p)
        t = quantile(d, p) - m
        t * t
    end
    meanFunOfProb(d; kwargs..., fun = squaredDiff)
end

"""
compute mean over a function(uniformly distributed probabilities)
    
used to estimate moments of logitnorm
"""
function meanFunOfProb(d::ContinuousUnivariateDistribution;
    relPrec = 1e-4,
    maxCnt = 2^18,
    fun = (d, p) -> quantile.(d, p))
    δ = 1 / 32 # start with 31 points (32 intervals between 0 and 1)
    p = δ:δ:(1 - δ)
    # for K=1/δ intervals, there are (K-1) points at c_i
    # The first points at δ represents interval (δ/2,3/2δ)
    # The following picture shows points and intervals for K = 4
    #---|---|---|---#
    # |---|---|---| #
    # we need to add points for δ/4 and 1-δ/4 representing the edges
    # but their weight is only half, because they represents half an inverval
    #m = sum(c_i*δ) + el*(δ/2) + er*(δ/2) = (sum(c_i) + er/2 + el/2)*δ
    s = sum(fun.(d, p))   # sum at points c_i
    el = fun(d, δ / 4)  # 
    er = fun(d, 1 - δ / 4)
    m = (s + el / 2 + er / 2) * δ
    relErr = 1
    while 1 / δ < maxCnt
        mPrev = m
        δ = δ / 2
        # to double the number of reference points, half the interval
        # for each second point we already computed fun
        # only need to add the new points to the sum of central points
        p = δ:(δ * 2):(1 - δ) # points at the center of current intervals
        s += sum(fun.(d, p))
        el = fun(d, δ / 4)
        er = fun(d, 1 - δ / 4)
        m = (s + el / 2 + er / 2) * δ
        relErr = abs(m - mPrev) / m
        #println("cnt=$(1/δ), m=$m, mPrev=$mPrev, relErr=$relErr")
        #if the estimate did not change much, can return
        relErr <= relPrec && break
    end
    relErr > relPrec &&
        @warn "Returning meanFunOfProb results of low relative precision of $relErr"
    m
end
