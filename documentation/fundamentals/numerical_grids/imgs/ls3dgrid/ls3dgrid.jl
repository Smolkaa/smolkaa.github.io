# load packages and themes
includet(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    includet(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
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
    x, y, z = X[:,1], X[:,2], X[:,3]

    # grid points
    scatter!(ax, x, y, z; color=:black, markersize=6)

    # lines
    for x in range(xrange[1], xrange[2], N_x+1), z in vcat(0, grid.z)
        lines!(ax, [x, x], [yrange[1], yrange[2]], [z, z]; color=(:black, 0.5))
    end
    for x in range(xrange[1], xrange[2], N_x+1), y in range(yrange[1], yrange[2], N_y+1)
        lines!(ax, [x, x], [y, y], [zrange[1], zrange[2]]; color=(:black, 0.5))
    end
    for y in range(yrange[1], yrange[2], N_y+1), z in vcat(0, grid.z)
        lines!(ax, [xrange[1], xrange[2]], [y, y], [z, z]; color=(:black, 0.5))
    end

    # brackets
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
    grid = LocalStructured3DGrid_exp(xrange, yrange, zrange, N_x, N_y, N_z; c=c)
    X = hcat(vec.(grid.coords)...)'
    x, y, z = X[:,1], X[:,2], X[:,3]

    # grid points
    scatter!(ax, x, y, z; color=:black, markersize=6)

    # lines
    for x in range(xrange[1], xrange[2], N_x+1), z in vcat(0, grid.z)
        lines!(ax, [x, x], [yrange[1], yrange[2]], [z, z]; color=(:black, 0.5))
    end
    for x in range(xrange[1], xrange[2], N_x+1), y in range(yrange[1], yrange[2], N_y+1)
        lines!(ax, [x, x], [y, y], [zrange[1], zrange[2]]; color=(:black, 0.5))
    end
    for y in range(yrange[1], yrange[2], N_y+1), z in vcat(0, grid.z)
        lines!(ax, [xrange[1], xrange[2]], [y, y], [z, z]; color=(:black, 0.5))
    end

    # brackets
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