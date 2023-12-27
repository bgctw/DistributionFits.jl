tmpf = () -> begin
    push!(LOAD_PATH, expanduser("~/julia/devtools/")) # access local pack
    push!(LOAD_PATH, joinpath(pwd(), "test/")) # access local pack
end

using Test, SafeTestsets
const GROUP = get(ENV, "GROUP", "All") # defined in in CI.yml
@show GROUP

@time begin
    if GROUP == "All" || GROUP == "Basic"
        #@safetestset "Tests" include("test/test_optim.jl")
        @time @safetestset "test_optim" include("test_optim.jl")
        #@safetestset "Tests" include("test/fitstats.jl")
        @time @safetestset "fitstats" include("fitstats.jl")
        #@safetestset "Tests" include("test/univariate/test_univariate.jl")
        @time @safetestset "test_univariate" include("univariate/test_univariate.jl")
    end
    if GROUP == "All" || GROUP == "JET"
        #@safetestset "Tests" include("test/test_JET.jl")
        @time @safetestset "test_JET" include("test_JET.jl")
        #@safetestset "Tests" include("test/test_aqua.jl")
        @time @safetestset "test_Aqua" include("test_aqua.jl")
    end
end

