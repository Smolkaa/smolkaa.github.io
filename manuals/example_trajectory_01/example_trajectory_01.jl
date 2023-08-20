@testset verbose=true "manuals/example_trajectory_01/example_trajectory_01.jl" begin

    x0 = GlobalCartesianPosition(LUNAR_RADIUS, 0, 0)
    v0 = GlobalCartesianVelocity(100.0, 0, 0)
    ddx = ddx_lunar_gravity
    traj = trajectory(x0, v0, ddx)
    @test !isnothing(traj)

end

nothing