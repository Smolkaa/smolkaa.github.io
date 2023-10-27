# load packages and themes
include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end


#::. functions
function ls3dgrid(;xrange=(0,10), yrange=(0,10), zrange=(0,10), N_x=5, N_y=5, N_z=5)
    # prepare figure & axis
    fig = Figure(; resolution=(450,400))
    ax = Axis3(fig[1,1];
        aspect = :data)
    hidedecorations!(ax)
    hidespines!(ax)
    xlims!(ax, -2, 10)
    ylims!(ax, -2, 10)

    # create grid and get grid points
    grid = LocalStructured3DGrid(xrange, yrange, zrange, N_x, N_y, N_z)
    X = hcat(vec.(grid.coords)...)'

    # grid points
    scatter!(ax, X[:,1], X[:,2], X[:,3]; color=:black, markersize=6)

    # lines
    # for x in range(xrange[1], xrange[2], N_x+1), z in vcat(0, grid.z)
    for x in range(xrange[1], xrange[2], N_x+1), z in range(zrange[1], zrange[2], N_z+1)
        lines!(ax, [x, x], [yrange[1], yrange[2]], [z, z]; color=(:black, 0.5))
    end
    for x in range(xrange[1], xrange[2], N_x+1), y in range(yrange[1], yrange[2], N_y+1)
        lines!(ax, [x, x], [y, y], [zrange[1], zrange[2]]; color=(:black, 0.5))
    end
    # for y in range(yrange[1], yrange[2], N_y+1), z in vcat(0, grid.z)
    for y in range(yrange[1], yrange[2], N_y+1), z in range(zrange[1], zrange[2], N_z+1)
        lines!(ax, [xrange[1], xrange[2]], [y, y], [z, z]; color=(:black, 0.5))
    end

    # brackets (only work with default values for xrange, yrange, zrange)
    bracket!(ax, Point3f(0,0,0), Point3f(10,0,0); orientation=:down, offset=10, text=L"N_x=%$N_x")
    bracket!(ax, Point3f(0,0,0), Point3f(0,10,0); orientation=:down, offset=10, text=L"N_y=%$N_y")
    bracket!(ax, Point3f(10,0,0), Point3f(25.5,18,0); orientation=:down, offset=10, text=L"N_z=%$N_z")

    # save figure
    save(joinpath(@__DIR__, "ls3dgrid.pdf"), fig)
    save(joinpath(@__DIR__, "ls3dgrid.svg"), fig)
    save(joinpath(@__DIR__, "ls3dgrid.png"), fig, px_per_unit=4)
end
function ls3dgrid_exp(;xrange=(0,10), yrange=(0,10), zrange=(0,10), N_x=5, N_y=5, N_z=5, c=2)
    # prepare figure & axis
    fig = Figure(; resolution=(450,400))
    ax = Axis3(fig[1,1];
        aspect = :data)
    hidedecorations!(ax)
    hidespines!(ax)
    xlims!(ax, -2, 10)
    ylims!(ax, -2, 10)

    # create grid and get grid points
    grid = LocalStructured3DGrid_Exponential(xrange, yrange, zrange, N_x, N_y, N_z; c=c)
    X = hcat(vec.(grid.coords)...)'

    # grid points
    scatter!(ax, X[:,1], X[:,2], X[:,3]; color=:black, markersize=6)

    # lines
    # for x in range(xrange[1], xrange[2], N_x+1), z in vcat(0, grid.z)
    for x in range(xrange[1], xrange[2], N_x+1), k in 1:N_z+1
        Z = unique(X[:,3] |> Vector{Float16})
        z = k == 1 ? zrange[1] : k == N_z+1 ? zrange[2] : (Z[k-1] + Z[k])/2
        lines!(ax, [x, x], [yrange[1], yrange[2]], [z, z]; color=(:black, 0.5))
    end
    for x in range(xrange[1], xrange[2], N_x+1), y in range(yrange[1], yrange[2], N_y+1)
        lines!(ax, [x, x], [y, y], [zrange[1], zrange[2]]; color=(:black, 0.5))
    end
    # for y in range(yrange[1], yrange[2], N_y+1), z in vcat(0, grid.z)
    for y in range(yrange[1], yrange[2], N_y+1), k in 1:N_z+1
        Z = unique(X[:,3] |> Vector{Float16})
        z = k == 1 ? zrange[1] : k == N_z+1 ? zrange[2] : (Z[k-1] + Z[k])/2
        lines!(ax, [xrange[1], xrange[2]], [y, y], [z, z]; color=(:black, 0.5))
    end

    # brackets (only work with default values for xrange, yrange, zrange)
    bracket!(ax, Point3f(0,0,0), Point3f(10,0,0); orientation=:down, offset=10, text=L"N_x=%$N_x")
    bracket!(ax, Point3f(0,0,0), Point3f(0,10,0); orientation=:down, offset=10, text=L"N_y=%$N_y")
    bracket!(ax, Point3f(10,0,0), Point3f(25.5,18,0); orientation=:down, offset=10, text=L"N_z=%$N_z")

    # save figure
    save(joinpath(@__DIR__, "ls3dgrid_exp.pdf"), fig)
    save(joinpath(@__DIR__, "ls3dgrid_exp.svg"), fig)
    save(joinpath(@__DIR__, "ls3dgrid_exp.png"), fig, px_per_unit=4)
end

ls3dgrid(; N_x=5, N_y=2, N_z=7)
ls3dgrid_exp(; N_x=5, N_y=2, N_z=7)