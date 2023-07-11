include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))


#::. functions
function mbd(name="mbd"; txt=true)

    # prep figure
    fig = Figure()
    ax = Axis(fig[1,1];
        xlabel="Normalized Velocity [-]",
        xticks=-6:2:6,
        ylabel="Probability Density [-]")

    # distributions
    x1, x2 = -4:0.01:5, 0:0.01:5
    mbd1d  = sqrt(1/2/pi) .* exp.(-x1.^2 ./ 2)
    mbd3d  = 4*pi*(1/2/pi)^1.5 .* x2.^2 .* exp.(-x2.^2 ./ 2)
    mbd1d2 = 2*sqrt(1/2/pi) .* exp.(-x2.^2 ./ 2)

    
    # plot distributions
    lines!(ax, x1, mbd1d; color=TUMBlueDark)
    lines!(ax, x2, mbd1d2; color=TUMBlueLight)
    lines!(ax, x2, mbd3d; color=TUMBlack)

    # typical speeds (3d)
    vp = sqrt(2);            fvp = 4*pi*(1/2/pi)^1.5*vp^2*exp(-vp^2/2)
    vmean = 2/sqrt(pi) * vp; fvmean = 4*pi*(1/2/pi)^1.5*vmean^2*exp(-vmean^2/2)
    vrms = sqrt(1.5) * vp;   fvrms = 4*pi*(1/2/pi)^1.5*vrms^2*exp(-vrms^2/2)

    # plot typical speeds (3d)
    scatter!(ax, [vp, vmean, vrms], [fvp, fvmean, fvrms]; 
        color=TUMBlack, markersize=10, strokewidth=2, strokecolor=:white)

    if txt
        ALGN, FS = (:left, :center), 10
        text!(ax, vp*1.1, fvp*1.03; text="most probable", align=ALGN, fontsize=FS)
        text!(ax, vmean*1.1, fvmean*1.005; text="mean", align=ALGN, fontsize=FS)
        text!(ax, vrms*1.1, fvrms*1.01; text="root mean squared", align=ALGN, fontsize=FS)
    end

    lines!(ax, [vp,vp], [0,fvp]; color=TUMBlack, linestyle=:dash)
    lines!(ax, [vmean,vmean], [0,fvmean]; color=TUMBlack, linestyle=:dash)
    lines!(ax, [vrms,vrms], [0,fvrms]; color=TUMBlack, linestyle=:dash)

    # add legend
    lx = LineElement(color=TUMBlueDark, linestyle=:solid, linewidth=3)
    lz = LineElement(color=TUMBlueLight, linestyle=:solid, linewidth=3)
    lv = LineElement(color=TUMBlack, linestyle=:solid, linewidth=3)
    axislegend(ax, 
        [lx,lz,lv], 
        ["1D-MBD", "1D-MBD, one-directional", "3D-MBD, speed"], 
        framevisible=false,
        position=:lt)

    # save figure
    save(joinpath(@__DIR__, "$name.pdf"), fig)
    save(joinpath(@__DIR__, "$name.svg"), fig)
    save(joinpath(@__DIR__, "$name.png"), fig, px_per_unit=4)
end


function run_all()
    mbd()
    mbd("mbd_notext"; txt=false)
end
