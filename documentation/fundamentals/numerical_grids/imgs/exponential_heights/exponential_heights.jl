#::. load packages and themes
include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end

#::. define relevant exponential function
z_by_zmax(k; c=1, N=10) = (exp(c/N)^(k-0.5) - 1) / (exp(c)-1)


#::. plotting function
function plot_exponential_heights(N::Vector{<:Real})
    fig = Figure()
    ax = Axis(fig[1,1],
        rightspinevisible = false,
        topspinevisible = false,
        xgridvisible = false,
        xlabel = "Number of grid points",
        xticks = (collect(1:length(N)), string.(N)),
        xtrimspine = true,
        ygridvisible = false,
        yticks = ([0,1], ["Bottom", "Top"]),
        ytrimspine = true,)

    #::. plot exponential heights
    for i in eachindex(N)
        n = N[i]
        z_lines = z_by_zmax.(1+0.5:n+0.5; c=2, N=n)
        lines!(ax, repeat([i], n+1), vcat(0, z_lines); color=:black)

        z_scatter = z_by_zmax.(1:n; c=2, N=n)
        scatter!(ax, repeat([i], n), z_scatter; color=:black, markersize=12)

        # add horizontal lines
        lines!(ax, [i-0.2, i+0.2], [0,0]; color=:black)
        for j in 1:n
            lines!(ax, [i-0.2, i+0.2], [z_lines[j], z_lines[j]]; color=:black)
        end
    end

    #::. save figure
    save(joinpath(@__DIR__, "exponential_heights.svg"), fig)
    save(joinpath(@__DIR__, "exponential_heights.pdf"), fig)
    save(joinpath(@__DIR__, "exponential_heights.png"), fig, px_per_unit=4)
end


function plot_slope_factor()
    fig = Figure()
    ax = Axis(fig[1,1],
        rightspinevisible = false,
        topspinevisible = false,
        xgridvisible = false,
        xlabel = "Grid element index",
        xticks = ([0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], ["0", "1", "", "", "", "", "", "", "", "", "N"]),
        xtrimspine = true,
        ygridvisible = false,
        yticks = ([0,1], ["Bottom", "Top"]),
        ytrimspine = true,)

    #::. plot slope factor
    N = 10
    scatterlines!(ax, collect(0:N)/N, vcat(0,z_by_zmax.(1.5:N+0.5; c=1, N=N)); color=:black, label="c =  1/N", marker=:circle)
    scatterlines!(ax, collect(0:N)/N, vcat(0,z_by_zmax.(1.5:N+0.5; c=2, N=N)); color=:black, label="c =  2/N", marker=:rect)
    scatterlines!(ax, collect(0:N)/N, vcat(0,z_by_zmax.(1.5:N+0.5; c=5, N=N)); color=:black, label="c =  5/N", marker=:diamond)
    scatterlines!(ax, collect(0:N)/N, vcat(0,z_by_zmax.(1.5:N+0.5; c=10, N=N)); color=:black, label="c = 10/N", marker=:xcross)

    #::. add legend
    axislegend(ax; position=:lt)

    #::. save figure
    save(joinpath(@__DIR__, "slope_factor.svg"), fig)
    save(joinpath(@__DIR__, "slope_factor.pdf"), fig)
    save(joinpath(@__DIR__, "slope_factor.png"), fig, px_per_unit=4)
end

plot_exponential_heights([2,5,10,20,50])
plot_slope_factor()