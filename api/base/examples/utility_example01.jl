@testset verbose=true "api/base/examples/utility_example01.jl" begin

    masses = amu2kg.([AMU_H, AMU_H2, AMU_OH, AMU_H2O])
    v_esc = escape_velocity_r_m(LUNAR_RADIUS, LUNAR_MASS)
    E_kin(m::Real; v=v_esc) = 0.5 * m * v_esc^2
    E = J2eV.(E_kin.(masses))
    @test !isnothing(E)

end

nothing