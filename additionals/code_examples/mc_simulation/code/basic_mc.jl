"""
    runMonteCarlo(step::Function, N::Int)

Runs a basic Monte Carlo simulation by calling the `step` function a total of `N` 
times and storing the results in an array.

# Arguments
- `step::Function`: A function that returns a result to be stored in the simulation results array.
- `N::Integer`: The number of times to call the `step` function.

# Returns
- An array containing the results of the Monte Carlo simulation.
"""
function runMonteCarlo(step::Function, N::Integer)
    results = []
    for i in 1:N
        push!(results, step())
    end
    return results
end



using Printf, DelimitedFiles
"""
    runMonteCarlo_save2file(step::Function, N::Integer)

Runs a basic Monte Carlo simulation by calling the `step` function a total of `N` 
times and storing the individual results in a file.

# Arguments
- `step::Function`: A function that returns a result to be stored in the simulation results array.
- `N::Integer`: The number of times to call the `step` function.

# Returns
- nothing
"""
function runMonteCarlo_save2file(step::Function, N::Integer)
    for i in 1:N
        result = step()
        writedlm(joinpath(@__DIR__, "out", @sprintf("%05i.csv", i)), result)
    end
    return nothing
end





#::. TESTING
using Statistics
function step()
    x, y = rand(2)
    return x^2 + y^2 <= 1 ? 1 : 0
end
res = runMonteCarlo(step, 100)
mean(res)
runMonteCarlo_save2file(step, 100)


#::. PLOTTING
using CairoMakie
include(joinpath(@__DIR__, "..","..","..","..","resources","julia","theme.jl"))
function plotMC(N::Integer)
    fig = Figure()
    ax = Axis(fig[1,1];
        aspect=DataAspect())
    for _ in 1:N
        x, y = rand(2)*2 .- 1
        if x^2 + y^2 <= 1
            scatter!(ax, x, y, color=:green)
        else
            scatter!(ax, x, y, color=:red)
        end
    end
    xlims!(ax, (-1,1))
    ylims!(ax, (-1,1))
    save(joinpath(@__DIR__, "..", "img", "mc", @sprintf("%07i.png", N)), fig, px_per_unit=4)
    return nothing
end
plotMC.([100,1_000,10_000,100_000])