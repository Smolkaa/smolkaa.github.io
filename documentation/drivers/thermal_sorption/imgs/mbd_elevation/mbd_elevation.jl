# load packages and themes
include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end

using LinearAlgebra
using Makie.StructArrays


function get_data(N=100)
    # get velocity distribution
    # mbf = MaxwellBoltzmannFluxVelocityDistribution()
    mb = MaxwellBoltzmannVelocityDistribution()

    # create and norm sampels 
    samples = [sample(mb, 1, amu2kg(1)) for _ in 1:N]
    samples_normed = samples ./ max(norm.(samples)...)

    # 3D -> 2D
    S = [[sqrt(s[1]^2 + s[2]^2), abs.(s[3])] for s in samples_normed]

    # filter outliers
    S_filtered = []
    for i in eachindex(S)
        if norm(S[i]) < 0.8
            push!(S_filtered, S[i])
        end
    end

    return S_filtered
end


function plot_data(s)
    # figure & axis setup
    fig = Figure(; resolution=(600,500), figure_padding=(-25,10,10,-10))
    ax = Axis(fig[1,1]; aspect=DataAspect())
    hidedecorations!(ax)
    hidespines!(ax)

    # turn data to points for plotting recipe
    points = hcat(s...)'
    P = [Point2f(points[i,1], points[i,2]) for i in 1:size(points)[1]]

    # create colormap (white background)
    cmap = to_colormap(ColorSchemes.dense)
    cmap[1] = RGBAf(1, 1, 1, 1)

    # plot data
    ds = datashader!(ax, P; async=false, colormap=cmap)

    lines!(ax, 0.8.*[0,0.84147], 0.8.*[0,0.540302]; color=:black) # MB
    lines!(ax, 0.4*cos.(0:0.01:(pi-2)/2), 0.4*sin.(0:0.01:(pi-2)/2); color=:black)
    # lines!(ax, [0,0.70711], [0,0.70711]; color=:black)  # MBF
    # lines!(ax, 0.4*cos.(0:0.01:pi/4), 0.4*sin.(0:0.01:pi/4); color=:black)

    save(joinpath(@__DIR__, "mbd_elevation.png"), fig, px_per_unit=8)
end

plot_data(get_data(100_000))