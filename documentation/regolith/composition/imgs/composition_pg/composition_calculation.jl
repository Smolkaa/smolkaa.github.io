AP   = [60.3, 16.9, 6.5, 5.1, 4.7, 4.4, 1.1, 0.4]

MP   = [43.2, 21.2, 7.8, 5.5, 8.4, 11.0, 2.4, 0.4] # (1, 2, 5, 6, 4, 3, 7, 8)


AP_scaled = AP ./ sum(AP)
MP_scaled = MP ./ sum(MP)

AP_out = 0 .- 10*accumulate(+, vcat(0, AP_scaled))
MP_out = 0 .- 10*accumulate(+, vcat(0, reverse(sort(MP_scaled))))

println(AP_out |> Vector{Float16})
println(MP_out |> Vector{Float16})


# minerals
m_m = [60.083, 79.865, 101.961, 71.844, 40.304, 56.077, 61.979]
m_O = 15.999
mp_m = [.454, .039, .149, .141, .092, .118, .006]


w_o = [2, 2, 3, 1, 1, 1, 1] .* m_O ./ m_m

println(10 .* w_o .* mp_m |> Vector{Float16})



#::.

ATOMS = ["O", "Si", "Al", "Mg", "Ca", "Fe", "Ti", "Na"]
ATOMIC_MASSES = [15.999, 28.085, 26.982, 24.305, 40.078, 55.845, 47.867, 22.990]

AP_MARIA     = [60.3, 16.9,  6.5, 5.1, 4.7, 4.4, 1.1,  0.4]
AP_HIGHLANDS = [61.1, 16.3, 10.1, 4.0, 6.1, 1.8, 0.15, 0.4]

MP_MARIA = ATOMIC_MASSES .* AP_MARIA ./ sum(ATOMIC_MASSES .* AP_MARIA)
MP_HIGHLANDS = ATOMIC_MASSES .* AP_HIGHLANDS ./ sum(ATOMIC_MASSES .* AP_HIGHLANDS)



OXIDES = ["SiO2", "Al2O3", "FeO", "CaO", "MgO", "TiO2", "Na2O"]
OXIDE_MASSES = [60.083, 101.961, 71.844, 56.077, 40.304, 79.865, 61.979 ]