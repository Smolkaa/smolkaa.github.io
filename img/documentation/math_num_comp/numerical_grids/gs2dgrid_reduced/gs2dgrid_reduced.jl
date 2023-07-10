# load packages and themes
includet(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    includet(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end


#::. functions
function gs2dgrid_reduced_2d(N_phi=10)
    grid = GlobalStructured2DGrid_Reduced(Float32,1,N_phi)
    Xs = vcat(vec.(coords(grid))'...)

    # setup figure
    fig = Figure(;resolution=(600,300))
    ax = Axis(fig[1,1];
        xautolimitmargin=(0,0),
        xlabel="Azimuth",
        yautolimitmargin=(0,0),
        ylabel="Elevation",)
    hidedecorations!(ax; label=false)
    ylims!(ax, -90, 90)

    # grid points
    scatter!(ax, rad2deg.(Xs[:,2]), rad2deg.(Xs[:,3]), markersize=3, color=:black)

    # custom grid lines
    for phi in unique(rad2deg.(Xs[:,3]))
        if phi < -85; continue; end
        lines!(ax, [-180, 180], [phi, phi] .- 90/N_phi; color=(:black, 0.3), linewidth=0.5)
    end
    for i in eachindex(grid.N_theta)
        N_theta = grid.N_theta[i]
        dtheta = 360/N_theta
        for theta in range(-180, 180, step=dtheta)
            lines!(ax, [theta, theta], [-90 + (i-1)*180/length(grid.N_theta),-90 + i*180/length(grid.N_theta)]; color=(:black, 0.3), linewidth=0.5)
        end
    end

    # save figure
    save(joinpath(@__DIR__, "gs2dgrid_reduced_2d.pdf"), fig)
    save(joinpath(@__DIR__, "gs2dgrid_reduced_2d.png"), fig, px_per_unit=4)
    nothing
end

function gs2dgrid_reduced_proj(N_phi=10)
    grid = GlobalStructured2DGrid_Reduced(Float32,1,N_phi)
    Xs = vcat(vec.(coords(grid))'...)

    # setup figure
    fig = Figure(;resolution=(600,300))
    ax = MyLTGeoAxis(fig[1,1]; 
        xlabel="Azimuth",
        xticks=[0],
        ylabel="Elevation",) 
    hidedecorations!(ax; label=false);

    # grid points
    scatter!(ax, rad2deg.(Xs[:,2]), rad2deg.(Xs[:,3]), markersize=3, color=:black)

    # custom grid lines
    for phi in unique(rad2deg.(Xs[:,3]))
        if phi < -85; continue; end
        lines!(ax, [-180, 180], [phi, phi] .- 90/N_phi; color=(:black, 0.3), linewidth=0.5)
    end
    for i in eachindex(grid.N_theta)
        N_theta = grid.N_theta[i]
        dtheta = 360/N_theta
        for theta in range(-180, 180, step=dtheta)
            lines!(ax, [theta, theta], [-90 + (i-1)*180/length(grid.N_theta),-90 + i*180/length(grid.N_theta)]; color=(:black, 0.3), linewidth=0.5)
        end
    end

    # save figure
    save(joinpath(@__DIR__, "gs2dgrid_reduced_proj.pdf"), fig)
    save(joinpath(@__DIR__, "gs2dgrid_reduced_proj.svg"), fig)
    save(joinpath(@__DIR__, "gs2dgrid_reduced_proj.png"), fig, px_per_unit=4)
    nothing
end

function gs2dgrid_reduced_3d(N_phi=10;)
    grid = GlobalStructured2DGrid_Reduced(Float32,1,N_phi)
    Xs = vcat(vec.(coords(grid))'...)
    Xc = vcat(vec.(coords(GlobalCartesianPosition, grid))'...)

    #
    fig = Figure(;resolution=(400,400))
    ax = Axis3(fig[1,1];
        aspect=:data,
        azimuth=-0.3pi,
        elevation=0.4,
        xlabeloffset=0,
        ylabeloffset=0,
        zlabeloffset=0,)
    hidedecorations!(ax; label=false)

    # filter
    x, y, z = Float64[], Float64[], Float64[]
    for i in eachindex(Xc[:,1])
        if Xc[i,1] < 0; continue; end
        push!(x, Xc[i,1])
        push!(y, Xc[i,2])
        push!(z, Xc[i,3])
    end
    scatter!(ax, x, y, z, markersize=4, color=:black)

    # custom grid lines
    for phi in unique(rad2deg.(Xs[:,3]))
        phi -= 90/N_phi
        x = [cosd(phi) * cos(x) for x in range(-pi/2,pi/2,100)]
        y = [cosd(phi) * sin(x) for x in range(-pi/2,pi/2,100)]
        z = [sind(phi) * ones(100)...]
        lines!(ax, x, y, z; color=(:black, 0.3), linewidth=0.5)
    end
    for i in eachindex(grid.N_theta)
        N_theta = grid.N_theta[i]
        dtheta = 360/N_theta
        for theta in range(-180, 180, step=dtheta)
            if abs(theta) >= 90; continue; end
            phi0, phi1 = -90 + (i-1)*180/length(grid.N_theta), -90 + i*180/length(grid.N_theta)
            
            x = [cosd(theta) * cosd(x) for x in range(phi0,phi1,100)]
            y = [sind(theta) * cosd(x) for x in range(phi0,phi1,100)]
            z = [sind(x) for x in range(phi0,phi1,100)]

            lines!(ax, x, y, z; color=(:black, 0.3), linewidth=0.5)
        end
    end

    # save figure
    save(joinpath(@__DIR__, "gs2dgrid_reduced_3d.pdf"), fig)
    save(joinpath(@__DIR__, "gs2dgrid_reduced_3d.svg"), fig)
    save(joinpath(@__DIR__, "gs2dgrid_reduced_3d.png"), fig, px_per_unit=4)

    nothing
end

#::. call all functions
function run_all(N=10)
    gs2dgrid_reduced_2d(N)
    gs2dgrid_reduced_proj(N)
    gs2dgrid_reduced_3d(N)
end