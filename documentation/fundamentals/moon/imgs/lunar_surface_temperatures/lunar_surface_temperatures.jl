# load packages and themes
include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end

#::. define colormap for figures
cmap = ColorSchemes.lipari


function _default_(N=240, M=120)
    fig     = Figure(;resolution=(600,288))
    ga      = GeoAxis(fig[1,1]; 
        bottomspinevisible  = false,
        dest                = "+proj=natearth", 
        leftspinevisible    = false,
        rightspinevisible   = false,
        topspinevisible     = false,
        xgridcolor          = (:black, 0.3),
        xlabel              = "Local Time, LT [h]",
        xtickformat         = Makie.automatic,
        xticklabelpad       = 1.0,
        xticks              = ([-180,-90,0,90,180], ["0","6","12","18","24"]),
        ylabel              = "Sub-Solar Latitude, Φₛ [°]",
        ytickformat         = Makie.automatic,
    )
    xlims!(ga, -180, 180); ylims!(ga, -90, 90)
    theta   = range(-1,1,N) .* pi .* 0.995
    phi     = range(-1,1,M) .* pi/2 .* 0.96
    return fig, ga, theta, phi
end


function lunarSurfaceTemperaturesDivinerAverage(name="lunar_surface_temperature_diviner_average")
    fig, ga, theta, phi = _default_()

    N, M = length(theta), length(phi)
    T = lunar_surface_temperatures_diviner_avg(theta, phi)
    T = reshape(T,N,M)

    s = heatmap!(ga, -179..179, -89..89, T; colormap=cmap, colorrange=(50,400))
    c = contour!(ga, -179..179, -89..89, T; color=:white, levels=[100], linewidth=0.7)
    t = text!(ga, -138, 0; text="100K", align=(:center,:center), color=:white)

    Colorbar(fig[:,2], s, label="Temperature [K]")

    # save(joinpath(@__DIR__, "$(name).pdf"), fig)
    # save(joinpath(@__DIR__, "$(name).svg"), fig)
    save(joinpath(@__DIR__, "$(name).png"), fig, px_per_unit=4)

    return nothing
end


function lunarSurfaceTemperaturesDiviner(name="lunar_surface_temperature_diviner")
    fig, ga, theta, phi = _default_(720, 360)

    N, M = length(theta), length(phi)
    T = lunar_surface_temperatures_diviner(0, theta, phi)
    T = reshape(T,N,M)

    s = heatmap!(ga, -179..179, -89..89, T; colormap=cmap, colorrange=(50,400))
    c = contour!(ga, -179..179, -89..89, T; color=:white, levels=[100], linewidth=0.7)
    t = text!(ga, -138, 0; text="100K", align=(:center,:center), color=:white)

    Colorbar(fig[:,2], s, label="Temperature [K]") 

    # save(joinpath(@__DIR__, "$(name).pdf"), fig)
    # save(joinpath(@__DIR__, "$(name).svg"), fig)
    save(joinpath(@__DIR__, "$(name).png"), fig, px_per_unit=4)

    return nothing
end


function lunarSurfaceTemperaturesBUTLER(name="lunar_surface_temperature_BUTLER")
    fig, ga, theta, phi = _default_()
    T = lunar_surface_temperatures_BUTLER1997(theta, phi)
    s = heatmap!(ga, -179..179, -89..89, T; colormap=cmap, colorrange=(50,400))

    Colorbar(fig[:,2], s, label="Temperature [K]") 

    # save(joinpath(@__DIR__, "$name.pdf"), fig)
    # save(joinpath(@__DIR__, "$name.svg"), fig)
    save(joinpath(@__DIR__, "$name.png"), fig, px_per_unit=4)

    return nothing
end



function lunarSurfaceTemperaturesHURLEY(name="lunar_surface_temperature_HURLEY")
    fig, ga, theta, phi = _default_()
    T = lunar_surface_temperatures_HURLEY2015(theta, phi)

    s = heatmap!(ga, -179..179, -89..89, T; colormap=cmap, colorrange=(50,400))
    c = contour!(ga, -179..179, -89..89, T; color=:white, levels=[100], linewidth=0.7)
    t = text!(ga, -138, 0; text="100K", align=(:center,:center), color=:white)

    Colorbar(fig[:,2], s, label="Temperature [K]") 

    # save(joinpath(@__DIR__, "$(name).pdf"), fig)
    # save(joinpath(@__DIR__, "$(name).svg"), fig)
    save(joinpath(@__DIR__, "$(name).png"), fig, px_per_unit=4)

    return nothing
end



function run_all()
    lunarSurfaceTemperaturesDivinerAverage()
    lunarSurfaceTemperaturesDiviner()
    lunarSurfaceTemperaturesBUTLER()
    lunarSurfaceTemperaturesHURLEY()
end
