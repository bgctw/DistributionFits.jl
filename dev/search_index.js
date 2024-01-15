var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/#AbstractMoments","page":"API","title":"AbstractMoments","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"The concept of first and higher order moments is captured by its own type. This allows dispatching the fit method.","category":"page"},{"location":"api/","page":"API","title":"API","text":"AbstractMoments\nmoments","category":"page"},{"location":"api/#DistributionFits.AbstractMoments","page":"API","title":"DistributionFits.AbstractMoments","text":"AbstractMoments{N}\n\nA representation of statistical moments of a distribution\n\nThe following functions are supported\n\nn_moments(m): get the number of recorded moments\n\nThe following getters return a single moment or  throw an error if the moment has not been recorded (>N)\n\nmean(m): get the first momemnt, i.e. the mean\nvar(m): get the second moment, i.e. the variance\nskewness(m): get the third moment, i.e. the skewness\nkurtosis(m): get the fourth moment, i.e.  the kurtosis\ngetindex(m,i): get the ith moment, i.e. indexing m[i]\n\nThe basic implementation Moments is immutable and convert(AbstractArray, m::Moments) returns an SArray{N,T}.\n\nExamples\n\nm = Moments(1,0.2);\nn_moments(m) == 2\nvar(m) == m[2]\n\nkurtosis(m) # throws error because its above 2nd moment\n\n\n\n\n\n","category":"type"},{"location":"api/#DistributionFits.moments","page":"API","title":"DistributionFits.moments","text":"moments(D, ::Val{N} = Val(2))\n\nGet the first N moments of a distribution.\n\nProduces an object of type AbstractMoments.\n\nExamples\n\nmoments(LogNormal(), Val(4))  # first four moments \nmoments(Normal())  # mean and variance\n\n\n\n\n\n","category":"function"},{"location":"api/#QuantilePoint","page":"API","title":"QuantilePoint","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"The concept of a pair (p,q), i.e. a probability in [0,1] and associated quantile is captured by its own type. This allows dispatching the fit method.","category":"page"},{"location":"api/","page":"API","title":"API","text":"QuantilePoint","category":"page"},{"location":"api/#DistributionFits.QuantilePoint","page":"API","title":"DistributionFits.QuantilePoint","text":"QuantilePoint\n\nA representation of a pair (p,q), i.e. (percentile,quantile).\n\nNotes\n\nSeveral macros help to construct QuantilePoints\n\n@qp(q,p)    quantile at specified p: QuantilePoint(q,p)\n\nFor Float64-based percentiles there are shortcuts\n\n@qp_ll(q0_025)  quantile at very low p: QuantilePoint(q0_025,0.025) \n@qp_l(q0_05)    quantile at low p: QuantilePoint(q0_05,0.05) \n@qp_m(median)   quantile at median: QuantilePoint(median,0.5) \n@qp_u(q0_95)    quantile at high p: QuantilePoint(q0_95,0.95)  \n@qp_uu(q0_975)  quantile at very high p: QuantilePoint(q0_975,0.975) \n\nFor constructing QuantilePoints with type of percentiles other than Float64,  use the corresponding functions, that create a percentiles of the type of given quantile. E.g. for a Float32-based QuantilePoint at very low percentile\n\nqp_ll(0.2f0) constructs a QuantilePoint(0.2f0,0.025f0) \n\nThere are macros/functions for some commonly used sets of QuantilePoints: 90% and 95% confidence intervals:\n\n@qs_cf90(q0_05,q0_95)  \n@qs_cf95(q0_025,q0_975) -> Set([QuantilePoint(q0_025,0.025),QuantilePoint(q0_975,0.975)]))\n\n\n\n\n\n","category":"type"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"CurrentModule = DistributionFits","category":"page"},{"location":"z_autodocs/#DistributionFits","page":"DistributionFits","title":"DistributionFits","text":"","category":"section"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"Documentation for DistributionFits.","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"[comment]: # (```@autodocs)","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"[comment]: # (Modules = [DistributionFits])","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"[comment]: # (```)","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"taken care of in index.md called only internally from fit, documented in docstring via \",\"","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"fit_median_quantile\nfit_mean_quantile\nfit_mode_quantile","category":"page"},{"location":"z_autodocs/#DistributionFits.fit_median_quantile","page":"DistributionFits","title":"DistributionFits.fit_median_quantile","text":"fit(D, val, qp, ::Val{stats} = Val(:mean))\n\nFit a statistical distribution to a quantile and given statistics\n\nArguments\n\nD: The type of distribution to fit\nval: The value of statistics\nqp: QuantilePoint(q,p)\nstats Which statistics to fit: defaults to Val(:mean).   Alternatives are: Val(:mode), Val(:median)\n\nExamples\n\nd = fit(LogNormal, 5.0, @qp_uu(14));\n(mean(d),quantile(d, 0.975)) .≈ (5,14)\n\nd = fit(LogNormal, 5.0, @qp_uu(14), Val(:mode));\n(mode(d),quantile(d, 0.975)) .≈ (5,14)\n\n\n\n\n\n","category":"function"},{"location":"z_autodocs/#DistributionFits.fit_mean_quantile","page":"DistributionFits","title":"DistributionFits.fit_mean_quantile","text":"fit(D, val, qp, ::Val{stats} = Val(:mean))\n\nFit a statistical distribution to a quantile and given statistics\n\nArguments\n\nD: The type of distribution to fit\nval: The value of statistics\nqp: QuantilePoint(q,p)\nstats Which statistics to fit: defaults to Val(:mean).   Alternatives are: Val(:mode), Val(:median)\n\nExamples\n\nd = fit(LogNormal, 5.0, @qp_uu(14));\n(mean(d),quantile(d, 0.975)) .≈ (5,14)\n\nd = fit(LogNormal, 5.0, @qp_uu(14), Val(:mode));\n(mode(d),quantile(d, 0.975)) .≈ (5,14)\n\n\n\n\n\n","category":"function"},{"location":"z_autodocs/#DistributionFits.fit_mode_quantile","page":"DistributionFits","title":"DistributionFits.fit_mode_quantile","text":"fit(D, val, qp, ::Val{stats} = Val(:mean))\n\nFit a statistical distribution to a quantile and given statistics\n\nArguments\n\nD: The type of distribution to fit\nval: The value of statistics\nqp: QuantilePoint(q,p)\nstats Which statistics to fit: defaults to Val(:mean).   Alternatives are: Val(:mode), Val(:median)\n\nExamples\n\nd = fit(LogNormal, 5.0, @qp_uu(14));\n(mean(d),quantile(d, 0.975)) .≈ (5,14)\n\nd = fit(LogNormal, 5.0, @qp_uu(14), Val(:mode));\n(mode(d),quantile(d, 0.975)) .≈ (5,14)\n\n\n\n\n\n","category":"function"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"internals","category":"page"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"meanFunOfProb\nofLogitNormalModeUpper","category":"page"},{"location":"z_autodocs/#DistributionFits.meanFunOfProb","page":"DistributionFits","title":"DistributionFits.meanFunOfProb","text":"compute mean over a function(uniformly distributed probabilities)\n\nused to estimate moments of logitnorm\n\n\n\n\n\n","category":"function"},{"location":"z_autodocs/#DistributionFits.ofLogitNormalModeUpper","page":"DistributionFits","title":"DistributionFits.ofLogitNormalModeUpper","text":"objective function used by matchModeUpper(LogitNormal,...)\n\n\n\n\n\n","category":"function"},{"location":"z_autodocs/","page":"DistributionFits","title":"DistributionFits","text":"[comment]: # (fit(Type{LogNormal}, Any, AbstractΣstar))","category":"page"},{"location":"mvlognormal/","page":"MvLogNormal","title":"MvLogNormal","text":"CurrentModule = DistributionFits","category":"page"},{"location":"mvlognormal/#Multivariate-LogNormal-distribution","page":"MvLogNormal","title":"Multivariate LogNormal distribution","text":"","category":"section"},{"location":"mvlognormal/","page":"MvLogNormal","title":"MvLogNormal","text":"Can be fitted to a given mean, provided the Covariance of the underlying normal distribution.","category":"page"},{"location":"mvlognormal/","page":"MvLogNormal","title":"MvLogNormal","text":"Σ = hcat([0.6,0.02],[0.02,0.7])\nμ = [1.2,1.3]\nd = MvLogNormal(μ, Σ)\nd2 = fit_mean_Σ(MvLogNormal, mean(d), Σ)\nisapprox(d2, d, rtol = 1e6)","category":"page"},{"location":"gamma/","page":"Gamma","title":"Gamma","text":"CurrentModule = DistributionFits","category":"page"},{"location":"gamma/#Gamma-distribution","page":"Gamma","title":"Gamma distribution","text":"","category":"section"},{"location":"gamma/","page":"Gamma","title":"Gamma","text":"The Gamma distribution has a scale and a shape parameter. It can be fitted using two quantiles.","category":"page"},{"location":"gamma/","page":"Gamma","title":"Gamma","text":"d = fit(Gamma, @qp_m(0.5), @qp_uu(5));\nmedian(d) ≈ 0.5 && quantile(d, 0.975) ≈ 5","category":"page"},{"location":"gamma/","page":"Gamma","title":"Gamma","text":"Fitting by mean or mode is not yet implemented.","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"CurrentModule = DistributionFits","category":"page"},{"location":"logitnormal/#LogitNormal-distribution","page":"LogitNormal","title":"LogitNormal distribution","text":"","category":"section"},{"location":"logitnormal/#Aggregate-statistics","page":"LogitNormal","title":"Aggregate statistics","text":"","category":"section"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"The logitnormal distribution has no analytical formula for mean, variance nor its mode. This package estimates those by numerically integrating the  distribution.","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"d = fit(LogitNormal, 0.8, @qp_u(0.9), Val(:mode))\nmean(d), var(d)\nmode(d) ≈ 0.8","category":"page"},{"location":"logitnormal/#Specifying-a-logitnormal-distribution-by-mode-and-peakedness","page":"LogitNormal","title":"Specifying a logitnormal distribution by mode and peakedness","text":"","category":"section"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"It is sometimes difficult to specify a precise upper quantile, because the logitnormal distribution is already constrained in (0,1). However, user might have an idea of the spread, or the inverse: peakedness,  of the distribution.","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"With increasing spread, the logitnormal distribution becomes bimodal. The following function estimates the most spread, i.e most flat distribution that has a single mode at the given location.","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"fit_mode_flat","category":"page"},{"location":"logitnormal/#DistributionFits.fit_mode_flat","page":"LogitNormal","title":"DistributionFits.fit_mode_flat","text":"fit_mode_flat(::Type{LogitNormal}, mode::T; peakedness = 1.0)\n\nFind the maximum-spread logitnormal distribution that has a single mode at given location.\n\nMore peaked distributions with given single mode can be obtained by increasing argument peakedness. They will have a spread by originally inferred σ² devidied  by peakedness.\n\nExamples\n\nm = 0.6\nd = fit_mode_flat(LogitNormal, m; peakedness = 1.5)\nmode(d) ≈ m\n\n\n\n\n\n","category":"function"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"The found maximum spread parameter, σ, is divided by the peakedness argument to specify distributions given the mode that are more peaked.","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"using DistributionFits,Optim\nusing StatsPlots # do not forget to add to docs environment\npeakedness_vec = 1:0.5:2\nm = 0.6\np = plot(\n    legend = :topleft, ylab=\"probability density\", legendtitle = \"peakedness\",\n    palette = :Dark2_3,)\nfor peakedness in peakedness_vec\n    d = fit_mode_flat(LogitNormal, m; peakedness)\n    plot!(p, d, label = peakedness)\nend\n#savefig(p, \"logitnormal_peakedness.svg\")\n#![](logitnormal_peakedness.svg)","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"p # hide","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"A shifted and scaled version of this distribution can be used as a moother alternative to the Bounded uniform distribution.","category":"page"},{"location":"logitnormal/","page":"LogitNormal","title":"LogitNormal","text":"shifloNormal","category":"page"},{"location":"logitnormal/#DistributionFits.shifloNormal","page":"LogitNormal","title":"DistributionFits.shifloNormal","text":"shifloNormal(lower,upper)\n\nGet a Shifted Flat LogitNormal distribution that is most spread with an extent between lower and upper.  This is a more smooth alternative to the bounded uniform distribution.\n\n\n\n\n\n","category":"function"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"CurrentModule = DistributionFits","category":"page"},{"location":"lognormal/#LogNormal-distribution","page":"LogNormal","title":"LogNormal distribution","text":"","category":"section"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"The LogNormal distribution can be characterized by the exponent of its parameters:","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"exp(μ): the median\nexp(σ): the multiplicative standard deviation sigma^*.","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"Function σstar returns the multiplicative standard deviation.","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"A distribution can be specified by taking the log of median and sigma^*","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"d = LogNormal(log(2), log(1.2))\nσstar(d) == 1.2","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"Alternatively the distribution can be specified by its mean and either ","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"Multiplicative standard deviation,sigma^*, using type AbstractΣstar\nStandard deviation at log-scale, sigma, or\nrelative error, cv. ","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"d = fit(LogNormal, 2, Σstar(1.2))\n(mean(d), σstar(d)) == (2, 1.2)","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"d = fit_mean_Σ(LogNormal, 2, 1.2)\n(mean(d),  d.σ) == (2, 1.2)","category":"page"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"d = fit_mean_relerror(LogNormal, 2, 0.2)\n(mean(d), std(d)/mean(d)) .≈ (2, 0.2)","category":"page"},{"location":"lognormal/#Detailed-API","page":"LogNormal","title":"Detailed API","text":"","category":"section"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"σstar(::LogNormal)","category":"page"},{"location":"lognormal/#DistributionFits.σstar-Tuple{LogNormal}","page":"LogNormal","title":"DistributionFits.σstar","text":"σstar(d)\n\nGet the multiplicative standard deviation of LogNormal distribution d.\n\nArguments\n\nd: The type of distribution to fit\n\nExamples\n\nd = LogNormal(2,log(1.2))\nσstar(d) == 1.2\n\n\n\n\n\n","category":"method"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"fit(d::Type{LogNormal}, mean, σstar::AbstractΣstar)","category":"page"},{"location":"lognormal/#StatsAPI.fit-Tuple{Type{LogNormal}, Any, AbstractΣstar}","page":"LogNormal","title":"StatsAPI.fit","text":"fit(D, mean, σstar::AbstractΣstar)\nfit_mean_Σ(D, mean, σ::Real)\n\nFit a statistical distribution of type D to mean and multiplicative  standard deviation, σstar, or scale parameter at log-scale: σ.\n\nArguments\n\nD: The type of distribution to fit\nmean: The moments of the distribution\nσstar::AbstractΣstar: The multiplicative standard deviation\nσ: The standard-deviation parameter at log-scale\n\nThe first version uses type AbstractΣstar to distinguish from  other methods of function fit. \n\nExamples\n\nd = fit(LogNormal, 2, Σstar(1.1));\n(mean(d), σstar(d)) == (2, 1.1)\n\n\n\n\n\n","category":"method"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"AbstractΣstar","category":"page"},{"location":"lognormal/#DistributionFits.AbstractΣstar","page":"LogNormal","title":"DistributionFits.AbstractΣstar","text":"Σstar <: AbstractΣstar\n\nRepresent the multiplicative standard deviation of a LogNormal distribution.\n\nSupports dispatch of fit. Invoking the type as a function returns its single value.\n\nExamples\n\na = Σstar(4.2)\na() == 4.2\n\n\n\n\n\n","category":"type"},{"location":"lognormal/","page":"LogNormal","title":"LogNormal","text":"fit_mean_relerror","category":"page"},{"location":"lognormal/#DistributionFits.fit_mean_relerror","page":"LogNormal","title":"DistributionFits.fit_mean_relerror","text":"fit_mean_relerror(D, mean, relerror)\n\nFit a distribution of type D to mean and relative error.\n\nArguments\n\nD: The type of distribution to fit\nmean: The first moment of the distribution\nrelerror: The relative error, i.e. the coefficient of variation\n\nExamples\n\nd = fit_mean_relerror(LogNormal, 10.0, 0.03);\n(mean(d), std(d)/mean(d)) .≈ (10.0, 0.03)\n\n\n\n\n\n","category":"function"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"CurrentModule = DistributionFits","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"partype/#Creating-Distributions-with-specific-parameter-types","page":"Parameter type","title":"Creating Distributions with specific parameter types","text":"","category":"section"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"Default type of distribution parameters is Float64. Many Distributions of Distributions.jl support also other Number types, such as duals numbers or Float32 for type parameters.","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"The fit function allow to specify the concrete parametric types of the resulting fitted distribution. Note the Float32 parametric type in the following example.","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"d = fit(LogNormal{Float32}, @qp_ll(1.0), @qp_uu(8))\npartype(d) == Float32","category":"page"},{"location":"partype/#Inferring-the-parametric-type-from-other-arguments.","page":"Parameter type","title":"Inferring the parametric type from other arguments.","text":"","category":"section"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"If the parametric type is omitted, default Float64 is assumed, or inferred from other parameters of the fitting function. Since quantiles and median are rather sample-like measures than paraemter-like measures, they do not influence the inferred parameter type.","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"d = fit(LogitNormal, 0.3f0, @qp_u(0.8f0), Val(:median)) #f0 indicates Float32 literals\npartype(d) == Float64","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"Parameter type, however, can be inferred from provided moments, mean, and mode.","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"d = fit(Exponential, Moments(3f0))  #f0 indicates Float32 literals\npartype(d) == Float32","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"d = fit(LogNormal, 3f0, @qp_uu(8))\npartype(d) == Float32","category":"page"},{"location":"partype/","page":"Parameter type","title":"Parameter type","text":"d = fit(LogNormal, 3f0, @qp_uu(8), Val(:mode))\npartype(d) == Float32","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = DistributionFits","category":"page"},{"location":"#DistributionFits","page":"Home","title":"DistributionFits","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Package DistributionFits allows fitting a distribution to a given set of aggregate statistics.","category":"page"},{"location":"","page":"Home","title":"Home","text":"to specified moments","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"","page":"Home","title":"Home","text":"d = fit(LogNormal, Moments(3.0,4.0))\n(mean(d), var(d)) .≈ (3.0, 4.0)","category":"page"},{"location":"","page":"Home","title":"Home","text":"mean and upper quantile point","category":"page"},{"location":"","page":"Home","title":"Home","text":"d = fit(LogNormal, 3.0, @qp_uu(8))\n(mean(d), quantile(d, 0.975)) .≈ (3.0, 8.0)","category":"page"},{"location":"","page":"Home","title":"Home","text":"to mode and upper quantile point","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"","page":"Home","title":"Home","text":"d = fit(LogNormal, 3.0, @qp_uu(8), Val(:mode))\n(mode(d), quantile(d, 0.975)) .≈ (3.0, 8.0)","category":"page"},{"location":"","page":"Home","title":"Home","text":"to median and upper quantile point","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"","page":"Home","title":"Home","text":"d = fit(LogitNormal, 0.3, @qp_u(0.8), Val(:median))\n(median(d), quantile(d, 0.95)) .≈ (0.3, 0.8)","category":"page"},{"location":"","page":"Home","title":"Home","text":"to two quantiles, i.e confidence range","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"","page":"Home","title":"Home","text":"d = fit(Normal, @qp_ll(1.0), @qp_uu(8))\n(quantile(d, 0.025), quantile(d, 0.975)) .≈ (1.0, 8.0)","category":"page"},{"location":"","page":"Home","title":"Home","text":"approximate a different distribution by matching moments","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = :(using Statistics,DistributionFits,Optim)","category":"page"},{"location":"","page":"Home","title":"Home","text":"dn = Normal(3,2)\nd = fit(LogNormal, moments(dn))\n(mean(d), var(d)) .≈ (3.0, 4.0)","category":"page"},{"location":"#Fit-to-statistical-moments","page":"Home","title":"Fit to statistical moments","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"fit(::Type{D}, ::AbstractMoments) where {D<:Distribution}","category":"page"},{"location":"#StatsAPI.fit-Union{Tuple{D}, Tuple{Type{D}, AbstractMoments}} where D<:Distribution","page":"Home","title":"StatsAPI.fit","text":"fit(D, m)\n\nFit a statistical distribution of type D to given moments m.\n\nArguments\n\nD: The type of distribution to fit\nm: The moments of the distribution\n\nNotes\n\nThis can be used to approximate one distribution by another.\n\nSee also AbstractMoments, moments. \n\nExamples\n\nd = fit(LogNormal, Moments(3.2,4.6));\n(mean(d), var(d)) .≈ (3.2,4.6)\n\nd = fit(LogNormal, moments(Normal(3,1.2)));\n(mean(d), std(d)) .≈ (3,1.2)\n\n# using StatsPlots\nplot(d, label = \"lognormal\", ylab=\"probability density\")\nplot!(Normal(3,1.2), label = \"normal\")\n\n\n\n\n\n","category":"method"},{"location":"#Fit-to-several-quantile-points","page":"Home","title":"Fit to several quantile points","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"fit(::Type{D}, ::QuantilePoint, ::QuantilePoint) where {D<:Distribution}","category":"page"},{"location":"#StatsAPI.fit-Union{Tuple{D}, Tuple{Type{D}, QuantilePoint, QuantilePoint}} where D<:Distribution","page":"Home","title":"StatsAPI.fit","text":"fit(D, lower::QuantilePoint, upper::QuantilePoint)\n\nFit a statistical distribution to a set of quantiles \n\nArguments\n\nD: The type of the distribution to fit\nlower:  lower QuantilePoint (p,q)\nupper:  upper QuantilePoint (p,q)\n\nExamples\n\nd = fit(LogNormal, @qp_m(3), @qp_uu(5));\nquantile.(d, [0.5, 0.975]) ≈ [3,5]\n\n\n\n\n\n","category":"method"},{"location":"#Fit-to-mean,-mode,-median-and-a-quantile-point","page":"Home","title":"Fit to mean, mode, median and a quantile point","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"fit(::Type{D}, ::Any, ::QuantilePoint, ::Val{stats} = Val(:mean)) where {D<:Distribution, stats}","category":"page"},{"location":"#StatsAPI.fit-Union{Tuple{stats}, Tuple{D}, Tuple{Type{D}, Any, QuantilePoint}, Tuple{Type{D}, Any, QuantilePoint, Val{stats}}} where {D<:Distribution, stats}","page":"Home","title":"StatsAPI.fit","text":"fit(D, val, qp, ::Val{stats} = Val(:mean))\n\nFit a statistical distribution to a quantile and given statistics\n\nArguments\n\nD: The type of distribution to fit\nval: The value of statistics\nqp: QuantilePoint(q,p)\nstats Which statistics to fit: defaults to Val(:mean).   Alternatives are: Val(:mode), Val(:median)\n\nExamples\n\nd = fit(LogNormal, 5.0, @qp_uu(14));\n(mean(d),quantile(d, 0.975)) .≈ (5,14)\n\nd = fit(LogNormal, 5.0, @qp_uu(14), Val(:mode));\n(mode(d),quantile(d, 0.975)) .≈ (5,14)\n\n\n\n\n\n","category":"method"},{"location":"#Fit-to-mean-and-uncertainty-parameter","page":"Home","title":"Fit to mean and uncertainty parameter","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"For bayesian inversion it is often required to specify a distribution given the expected value (the predction of the population value) and a description of  uncertainty of an observation.","category":"page"},{"location":"","page":"Home","title":"Home","text":"fit_mean_Σ","category":"page"},{"location":"#DistributionFits.fit_mean_Σ","page":"Home","title":"DistributionFits.fit_mean_Σ","text":"fit_mean_Σ(::Type{<:Distribution}, mean, Σ)\n\nFit a Distribution to mean and uncertainty quantificator Σ. \n\nThe meaning of Σ depends on the type of distribution:\n\nMvLogNormal, MvNormal: the Covariancematrix of the associated normal distribution\nLogNormal, Normal: the scale parameter, i.e. the standard deviation at log-scale, σ\n\n\n\n\n\n","category":"function"},{"location":"#Currently-supported-distributions","page":"Home","title":"Currently supported distributions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Univariate continuous","category":"page"},{"location":"","page":"Home","title":"Home","text":"Normal\nLogNormal distribution\nLogitNormal distribution\nExponential\nLaplace\nWeibull distribution\nGamma distribution","category":"page"},{"location":"#Implementing-support-for-another-distribution","page":"Home","title":"Implementing support for another distribution","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In order to use the fitting framework for a distribution MyDist,  one needs to implement the following four methods.","category":"page"},{"location":"","page":"Home","title":"Home","text":"fit(::Type{MyDist}, m::AbstractMoments)\n\nfit_mean_quantile(::Type{MyDist}, mean, qp::QuantilePoint)\n\nfit_mode_quantile(::Type{MyDist}, mode, qp::QuantilePoint)\n\nfit(::Type{MyDist}, lower::QuantilePoint, upper::QuantilePoint)","category":"page"},{"location":"","page":"Home","title":"Home","text":"The default method for fit with stats = :median already works based on the methods for  two quantile points. If the general method on two quantile points cannot be specified,  one can alternatively implement method:","category":"page"},{"location":"","page":"Home","title":"Home","text":"fit_median_quantile(::Type{MyDist}, median, qp::QuantilePoint)","category":"page"},{"location":"set_optimize/","page":"Dependencies","title":"Dependencies","text":"CurrentModule = DistributionFits","category":"page"},{"location":"set_optimize/#Setting-the-optimize-configuration","page":"Dependencies","title":"Setting the optimize configuration","text":"","category":"section"},{"location":"set_optimize/","page":"Dependencies","title":"Dependencies","text":"AbstractDistributionFitOptimizer","category":"page"},{"location":"set_optimize/#DistributionFits.AbstractDistributionFitOptimizer","page":"Dependencies","title":"DistributionFits.AbstractDistributionFitOptimizer","text":"AbstractDistributionFitOptimizer\nOptimOptimizer <: AbstractDistributionFitOptimizer\nset_optimizer(::AbstractDistributionFitOptimizer)\n\nDistributionFits.jl uses the following interface to opimize an univariate  function f on bounded interval [lower,upper]:\n\noptimize(f, ::AbstractDistributionFitOptimizer, lower, upper)\n\nReturning an object with fields minimizer and converged.\n\nDistributionFits.set_optimizer(::AbstractDistributionFitOptimizer)  sets the specific AbstractDistributionFitOptimizer that is used  throughout the package for calling the optimize function.  Specializing this function with a concrete type, allows using different optimization packages. \n\nBy default, when the Optim.jl  package is in scope, the OptimOptimizer is set, which implements the interface by using Optim's  optimize function.\n\nHence, the module using DistributionFits.jl has to either\n\nexplicitly invoke using Optim, or\ncall set_optimizer with the concrete subtype of AbstractDistributionFitOptimizer for which the corresponding optimize method is implemented. \n\nDevelopers implementing usage of a different specific optimizer see code in  ext/DistributionFitsOptimExt.\n\n\n\n\n\n","category":"type"},{"location":"weibull/","page":"Weibull","title":"Weibull","text":"CurrentModule = DistributionFits","category":"page"},{"location":"weibull/#Weibull-distribution","page":"Weibull","title":"Weibull distribution","text":"","category":"section"},{"location":"weibull/","page":"Weibull","title":"Weibull","text":"The Weibull distribution has a scale and a shape parameter. It can be fitted using two quantiles.","category":"page"},{"location":"weibull/","page":"Weibull","title":"Weibull","text":"d = fit(Weibull, @qp_m(0.5), @qp_uu(5));\nmedian(d) == 0.5 && quantile(d, 0.975) ≈ 5","category":"page"},{"location":"weibull/","page":"Weibull","title":"Weibull","text":"Fitting by mean or mode is not yet implemented.","category":"page"}]
}
