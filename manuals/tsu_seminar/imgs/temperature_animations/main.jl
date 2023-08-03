# load packages and themes
using Printf

include(joinpath(@__DIR__, "..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end

#::. define colormap for figures
cmap = lipari

#::. functions
function _default_(N=240, M=120)
    fig     = Figure(;resolution=(600,285))
    ga      = MyLTGeoAxis(fig[1,1];)
    xlims!(ga, -180, 180); ylims!(ga, -90, 90)
    theta   = range(-1,1,N) .* pi .* 0.995
    phi     = range(-1,1,M) .* pi/2 .* 0.96
    return fig, ga, theta, phi
end

function anim_raw_diviner(steps=18)
    fig, ga, theta, phi = _default_(720, 360)

    N, M = length(theta), length(phi)
    T = lunar_surface_temperatures_diviner(0, theta, phi)
    T = reshape(T,N,M)
    s = heatmap!(ga, -179..179, -89..89, T; colormap=cmap, colorrange=(50,400))
    Colorbar(fig[:,2], s, label="Temperature [K]") 

    for step in 1:steps
        T = lunar_surface_temperatures_diviner((step-1)*2*pi/steps, theta, phi)
        T = reshape(T,N,M)
        s[3] = T
        
    save(joinpath(@__DIR__, "anim_raw_diviner", @sprintf "%02i.png" step), fig, px_per_unit=4)
    end
    # save(joinpath(@__DIR__, "anim_raw_diviner.png"), fig, px_per_unit=4)
    return nothing
end