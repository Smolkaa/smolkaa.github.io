using PrettyTables

#::. main function
function maketable()
    # speed distribution, normalized
    f(v) = 1/2 * v^3 * exp(- v^2 / 2)

    # typical speeds, normalized
    vp = sqrt(3)
    vm = sqrt(9*pi/8)
    vr = sqrt(2)

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
    idx_sorted = [1,10,8,2,9,3,4,5,6,7]
    FF = FF[idx_sorted]
    V = V[idx_sorted]
    Vvp = Vvp[idx_sorted]
    Vvm = Vvm[idx_sorted]
    Vvr = Vvr[idx_sorted]

    Vstr = [
        raw"$\velocity_{25}$",
        raw"$\velocity_\text{rms}$",
        raw"$\velocity_p$",
        raw"$\velocity_{50}$",
        raw"$\meanof{\velocity}$",
        raw"$\velocity_{75}$",
        raw"$\velocity_{90}$",
        raw"$\velocity_{95}$",
        raw"$\velocity_{99}$",
        raw"$\velocity_{99.9}$",
    ]

    # additional columns for analytically exact values
    Vvp_extra = ["",raw"$\approx\sqrt{2/3}$","","",raw"$\approx\sqrt{3\pi/8}$","", "", "", "", ""]
    Vvm_extra = ["", raw"$\approx\sqrt{16/9\pi}$", raw"$\approx\sqrt{8/3\pi}$","", "", "", "", "", "", ""]
    Vvr_extra = ["","",raw"$\approx\sqrt{3/2}$","",raw"$\approx\sqrt{9\pi/16\pi}$","", "", "", "", ""]

    # table
    header = [
        raw"$\velocity$", 
        raw"$\int_0^\velocity f(\velocity)d\velocity$", 
        raw"$\velocity / \sqrt{\frac{\BoltzmannConstant\temperature}{\mass}}$", 
        raw"$\velocity / \velocity_p$", "",
        raw"$\velocity / \meanof{\velocity}$", "", 
        raw"$\velocity / \velocity_\text{rms}$", ""]
    data = hcat(Vstr, FF, V, Vvp, Vvp_extra, Vvm, Vvm_extra, Vvr, Vvr_extra)

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

function writetable()
    fid = open("raw_mbfd_typical_speeds.md", "w")
    write(fid, replace(maketable(), "\\\\"=>"\\"))
    close(fid)
end