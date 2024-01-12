"""
    fit_mean_Σ(::Type{<:Distribution}, mean, Σ)

Fit a Distribution to mean and uncertainty quantificator Σ. 

The meaning of `Σ` depends on the type of distribution:
- `MvLogNormal`: the Covariancematrix of the associated normal distribution
- `LogNormal`: the scale parameter, i.e. the standard deviation at log-scale, `σ`
"""
function fit_mean_Σ(::Type{MvLogNormal}, mean::AbstractVector{T1}, Σ::AbstractMatrix{T2}) where {T1 <:Real,T2 <:Real}
    _T = promote_type(T1, T2)
    fit_mean_Σ(MvLogNormal{_T}, mean, Σ)
end
function fit_mean_Σ(::Type{MvLogNormal{T}}, mean::AbstractVector{T1}, Σ::AbstractMatrix{T2}) where {T, T1 <:Real,T2 <:Real}
    meanT = T1 == T ? mean : begin
        meanT = similar(mean, T)
        meanT .= mean
    end
    ΣT = T2 == T ? Σ : begin
        ΣT = similar(Σ, T)
        ΣT .= Σ
    end
    σ2 = diag(ΣT)
    μ = log.(meanT) .- σ2 ./ 2
    MvLogNormal(μ, ΣT)
end