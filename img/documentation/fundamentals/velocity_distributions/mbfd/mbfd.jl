include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

#::. functions
function mbfd(name="mbfd"; txt=true)

    # prep figure
    fig = Figure()
    ax = Axis(fig[1,1];
        xlabel="Normalized Velocity [-]",
        xticks=-6:2:6,
        ylabel="Probability Density [-]")

    # distributions
    x1, x2 = -4:0.01:5, 0:0.01:5
    mbfdx  = sqrt(1/2/pi) * exp.(- x1.^2 ./ 2)
    mbfdz  = x2 .* exp.(- x2.^2 ./ 2)
    mbfdv  = x2.^3 ./ 2 .* exp.(- x2.^2 ./ 2)

    
    # plot distributions
    lines!(ax, x1, mbfdx; color=TUMBlueDark)
    lines!(ax, x2, mbfdz; color=TUMBlueLight)
    lines!(ax, x2, mbfdv; color=TUMBlack)

    # typical speeds (3d)
    vp = sqrt(3);         fvp = vp^3/2*exp(-vp^2/2)
    vmean = sqrt(9*pi/8); fvmean = vmean^3/2*exp(-vmean^2/2)
    vrms = sqrt(2);       fvrms = vrms^3/2*exp(-vrms^2/2)

    # plot typical speeds (3d)
    scatter!(ax, [vp, vmean, vrms], [fvp, fvmean, fvrms]; 
        color=TUMBlack, markersize=10, strokewidth=2, strokecolor=:white)

    if txt
        ALGN, FS = (:left, :center), 10
        text!(ax, vp*1.1, fvp*1.03; text="most probable", align=ALGN, fontsize=FS)
        text!(ax, vmean*1.1, fvmean*1.005; text="mean", align=ALGN, fontsize=FS)
        text!(ax, vrms*0.9, fvrms*1.0; text="root mean squared", align=(:right, :center), fontsize=FS)
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
        ["1D-MBFD", "1D-MBFD, flux", "3D-MBFD, speed"], 
        framevisible=false,
        position=:lt)

    # save figure
    save(joinpath(@__DIR__, "$name.pdf"), fig)
    save(joinpath(@__DIR__, "$name.svg"), fig)
    save(joinpath(@__DIR__, "$name.png"), fig, px_per_unit=4)
end


function run_all()
    mbfd()
    mbfd("mbfd_notext"; txt=false)
end
