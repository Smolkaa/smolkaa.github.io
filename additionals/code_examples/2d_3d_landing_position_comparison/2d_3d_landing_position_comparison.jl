path_to_exess = joinpath(@__DIR__, "..", "..", "..", "..", "exess.jl", "src", "ExESS.jl")
include(path_to_exess)
using .ExESS
using LinearAlgebra

x0 = GlobalSphericalPosition(LUNAR_RADIUS, 0, 0)
v0 = LocalCartesianVelocity(250.0, 100.0, 100.0)

x_landing_2d = landing_position(x0, v0)

traj = trajectory(x0, v0, ddx_gravity)
x_landing_3d = GlobalSphericalPosition(GlobalCartesianPosition(traj[end][4:6]))

function compare_2d_3d(vel, elev; N=10)
    Nv, Ne = length(vel), length(elev)
    e = zeros(Nv, Ne)
    for i in eachindex(vel), j in eachindex(elev)        
        for _ in 1:N
            lon, lat = rand(2) .* [2pi, pi] .- [pi, pi/2]
            x0 = GlobalCartesianPosition(LUNAR_RADIUS .* [
                    cos(lon)*cos(lat), 
                    sin(lon)*cos(lat), 
                    sin(lat)])

            az = rand()*2pi
            v0 = GlobalCartesianVelocity(x0, LocalCartesianVelocity(vel[i] .* [
                    cos(az) * cos(elev[j]), 
                    sin(az) * cos(elev[j]), 
                    sin(elev[j])]))

            x_landing_2d = GlobalCartesianPosition(landing_position(x0, v0))
            traj = trajectory(x0, v0, ddx_gravity; reltol=1e-6)
            x_landing_3d = GlobalCartesianPosition(traj[end][4:6])

            e[i,j] += norm(vec(x_landing_2d) - vec(x_landing_3d)) / N / LUNAR_RADIUS
        end
    end
    return e
end

vel = 250:250:2000
elev = deg2rad.(10:10:80)
e = compare_2d_3d(vel, elev)

function plot_compare_2d_3d(v, elev, e)
    fig = Figure(; resolution=(600,400))
    ax = Axis(fig[1,1];
        xlabel="Velocity [m/s]",
        ylabel="Elevation Angle [rad]")

    hm = heatmap!(ax, v, rad2deg.(elev), e .* 1e5, colormap=lipari)
    Colorbar(fig[1,2], hm, label="Absolute Error, [10⁻⁵ Lunar Radius]")
    save(joinpath(@__DIR__, "compare_2d_3d.png"), fig, px_per_unit=2)

    return nothing
end

vel = 100:100:2000
elev = deg2rad.(5:5:85)
e = compare_2d_3d(vel, elev; N=100)
# plot_compare_2d_3d(vel, elev, e)