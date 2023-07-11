using PrettyTables

#::. main function
function maketable()
    # speed distribution, normalized
    f(v) = sqrt(1/2/pi)^3 * 4 * pi * v^2 * exp(- v^2 / 2)

    # typical speeds, normalized
    vp = sqrt(2)
    vm = sqrt(8/pi)
    vr = sqrt(3)

    # integrals for typical speeds
    dv = 1e-4
    Fvp = sum(f(vi)*dv for vi in 0:dv:vp)
    Fvm = sum(f(vi)*dv for vi in 0:dv:vm)
    Fvr = sum(f(vi)*dv for vi in 0:dv:vr)

    # integral speeds
    F = [0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 0.999]
    v = [_findv(f, F[i]; dv=dv) for i in eachindex(F)]

    # prep table data
    FF = vcat(F, [Fvp, Fvm, Fvr])
    V = vcat(v, [vp, vm, vr])
    Vvp = V./vp
    Vvm = V./vm
    Vvr = V./vr
    
    # sorting
    idx_sorted = [1,8,2,9,10,3,4,5,6,7]
    FF = FF[idx_sorted]
    V = V[idx_sorted]
    Vvp = Vvp[idx_sorted]
    Vvm = Vvm[idx_sorted]
    Vvr = Vvr[idx_sorted]

    # table
    header = [
        "\$\\velocity\$", 
        "\$\\int_0^\\velocity f(\\velocity)d\\velocity\$", 
        "\$\\velocity / \\sqrt{\\frac{\\BoltzmannConstant\\temperature}{\\mass}}\$", 
        "\$\\velocity / \\velocity_p\$", 
        "\$\\velocity / \\meanof{\\velocity}\$"]
    data = hcat(FF, V, Vvp, Vvm, Vvr)

    return pretty_table(String, data; backend=Val(:text), tf=tf_markdown, header=header, alignment=:l)
end


function _findv(f, F; dv=0.0001)
    v = 0:dv:10
    SUM = 0
    for vi in v
        SUM += f(vi) * dv
        if SUM >= F; return vi; end
    end
    return nothing
end
