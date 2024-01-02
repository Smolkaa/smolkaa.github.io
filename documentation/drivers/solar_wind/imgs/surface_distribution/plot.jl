#::. load packages and themes
include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end


#::.
function plot_surface_distribution()

    lng, lat = deg2rad.(-90:1:90), deg2rad.(-89:1:89)
    p = [pos_pdf(SolarWindSurfaceDistribution(LUNAR_RADIUS), lng[i], lat[j]) for i in eachindex(lng), j in eachindex(lat)]

    fig = Figure(;resolution=(600,300))
    ax = MyLTGeoAxis(fig[1,1];
        xlabel = "Local Time, LT [h]",
        ylabel = "Sub-Solar Latitude, Φₛ [°]")
    
    hm = heatmap!(ax, rad2deg.(lng), rad2deg.(lat), p .* 100; colormap=ColorSchemes.lipari, colorrange=(0,25))

    # Colorbar(fig[0,:], hm; vertical=false, ticklabelalign=(:right,:center), ticklabelpad=5.0, label="Probability [%]")
    Colorbar(fig[:,2], hm; ticklabelalign=(:right,:center), ticklabelpad=5.0, label="Probability [%]")

    save(joinpath(@__DIR__,"surface_distribution.pdf"), fig)
    save(joinpath(@__DIR__,"surface_distribution.png"), fig)
end