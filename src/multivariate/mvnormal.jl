function fit_mean_Σ(::Type{MvNormal}, mean::AbstractVector{T1}, Σ::AbstractMatrix{T2}) where {T1 <:Real,T2 <:Real}
    _T = promote_type(T1, T2)
    fit_mean_Σ(MvNormal{_T}, mean, Σ)
end
function fit_mean_Σ(::Type{MvNormal{T}}, mean::AbstractVector{T1}, Σ::AbstractMatrix{T2}) where {T, T1 <:Real,T2 <:Real}
    meanT = T1 == T ? mean : begin
        meanT = similar(mean, T)
        meanT .= mean
    end
    ΣT = T2 == T ? Σ : begin
        ΣT = similar(Σ, T)
        ΣT .= Σ
    end
    MvNormal(meanT, ΣT)
end