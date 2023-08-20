using Test

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..", "exess.jl", "src", "ExESS.jl"))
    using .ExESS
end


@testset verbose=true "DOCUMENTATION EXAMPLES TEST ============================" begin

    include(joinpath(@__DIR__, "api", "base", "examples", "utility_example01.jl"))

    include(joinpath(@__DIR__, "manuals", "example_trajectory_01", "example_trajectory_01.jl"))
end

nothing