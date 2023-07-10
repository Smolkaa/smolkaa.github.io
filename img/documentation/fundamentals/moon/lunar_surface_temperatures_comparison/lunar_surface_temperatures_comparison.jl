# load packages and themes
include(joinpath(@__DIR__, "..","..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    include(joinpath(@__DIR__, "..","..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end

using Statistics, StatsBase


#::. functions
function comparison_rms(N=18, name="temperature_comparison_rms")
    grid = ExESS.GlobalHEALPix2DGrid(1.0,150)

    #::. temperatures
    T_diviner = lunar_surface_temperatures_diviner_avg(grid)
    T_B = lunar_surface_temperatures_BUTLER1997(grid)
    T_H = lunar_surface_temperatures_HURLEY2015(grid)

    #::. calculate absoluate temperature differences
    dTB = T_B .- T_diviner
    dTH = T_H .- T_diviner

    #::. 
    eB, eH = Float32[], Float32[]
    eBd, eHd = Float32[], Float32[]
    eBn, eHn = Float32[], Float32[]
    for i in 1:N
        dTBlat, dTHlat = Float32[], Float32[]
        dTBlatd, dTHlatd = Float32[], Float32[]
        dTBlatn, dTHlatn = Float32[], Float32[]
        for j in eachindex(dTB)
            if (i-1)*pi/2/N < abs(grid.coords[j].phi) < i*pi/2/N; push!(dTBlat, dTB[j]) 
                push!(dTHlat, dTH[j]) 
                if -pi/2 + 0.1 < grid.coords[j].theta < pi/2 - 0.1; push!(dTBlatd, dTB[j]); push!(dTHlatd, dTH[j]); end # day
                if !(-pi/2 + 0.1 < grid.coords[j].theta < pi/2 - 0.1); push!(dTBlatn, dTB[j]); push!(dTHlatn, dTH[j]); end # night
            end
        end
        push!(eB, sqrt(mean(dTBlat.^2)))  
        push!(eBd, sqrt(mean(dTBlatd.^2)))
        push!(eBn, sqrt(mean(dTBlatn.^2)))
        push!(eH, sqrt(mean(dTHlat.^2)))  
        push!(eHd, sqrt(mean(dTHlatd.^2)))
        push!(eHn, sqrt(mean(dTHlatn.^2)))
    end

    #::. prep figures
    fig = Figure(;)
    ax = Axis(fig[1,1];
        xlabel="Latitude [°]",
        xticks=0:20:90,
        ylabel="RMS Temperature Differences [K]",
        yticks=0:20:70,)
    ylims!(0, 70)

    #::. plots
    lines!(ax, range(0,80,N), eB;  color=TUMBlack, linestyle=:dash)
    lines!(ax, range(0,80,N), eBd; color=TUMBlack, linestyle=:dash)
    lines!(ax, range(0,80,N), eBn; color=TUMBlack, linestyle=:dash)
    lines!(ax, range(0,80,N), eH;  color=TUMBlack)
    lines!(ax, range(0,80,N), eHd; color=TUMBlack)
    lines!(ax, range(0,80,N), eHn; color=TUMBlack)

    scatter!(ax, range(0,80,N), eB;  color=TUMBlack, strokecolor=TUMBlack, strokewidth=0.7)
    scatter!(ax, range(0,80,N), eBd; color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:rect)
    scatter!(ax, range(0,80,N), eBn; color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:diamond)
    scatter!(ax, range(0,80,N), eH;  color=TUMBlack, strokewidth=0.7)
    scatter!(ax, range(0,80,N), eHd; color=:white, strokewidth=0.7, marker=:rect)
    scatter!(ax, range(0,80,N), eHn; color=:white, strokewidth=0.7, marker=:diamond)

    #::. legend
    l1 = LineElement(color=TUMBlack, linestyle=:dash, linewidth=2)
    l2 = LineElement(color=TUMBlack, linestyle=:solid, linewidth=2)
    m1 = MarkerElement(color=TUMBlack, strokecolor=TUMBlack, strokewidth=0.7, marker=:circle,)
    m2 = MarkerElement(color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:rect,)
    m3 = MarkerElement(color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:diamond,)
    axislegend(ax,  
        [ m1, l2, m2, l1, m3],
        [ "Global", "Hurley et al. 2015", "Dayside", "Butler et al. 1997", "Nightside", ];
        position=:lt,
        nbanks=2,
        framevisible=false,
    )

    #::. save figure
    save(joinpath(@__DIR__, "$(name).pdf"), fig)
    save(joinpath(@__DIR__, "$(name).svg"), fig)
    save(joinpath(@__DIR__, "$(name).png"), fig, px_per_unit=4)

    return nothing
end

function comparison_mean(N=18, name="temperature_comparison_mean")
    grid = ExESS.GlobalHEALPix2DGrid(1.0,150)

    #::. temperatures
    T_diviner = lunar_surface_temperatures_diviner_avg(grid)
    T_B = lunar_surface_temperatures_BUTLER1997(grid)
    T_H = lunar_surface_temperatures_HURLEY2015(grid)

    #::. calculate absoluate temperature differences
    dTB = T_B .- T_diviner
    dTH = T_H .- T_diviner

    #::.
    eB, eH = Float32[], Float32[]
    eBd, eHd = Float32[], Float32[]
    eBn, eHn = Float32[], Float32[]
    for i in 1:N
        dTBlat, dTHlat = Float32[], Float32[]
        dTBlatd, dTHlatd = Float32[], Float32[]
        dTBlatn, dTHlatn = Float32[], Float32[]
        for j in eachindex(dTB)
            if (i-1)*pi/2/N < abs(grid.coords[j].phi) < i*pi/2/N; push!(dTBlat, dTB[j]) 
                push!(dTHlat, dTH[j]) 
                if -pi/2 + 0.1 < grid.coords[j].theta < pi/2 - 0.1; push!(dTBlatd, dTB[j]); push!(dTHlatd, dTH[j]); end # day
                if !(-pi/2 + 0.1 < grid.coords[j].theta < pi/2 - 0.1); push!(dTBlatn, dTB[j]); push!(dTHlatn, dTH[j]); end # night
            end
        end
        push!(eB, mean(dTBlat))   
        push!(eBd, mean(dTBlatd)) 
        push!(eBn, mean(dTBlatn)) 
        push!(eH, mean(dTHlat))   
        push!(eHd, mean(dTHlatd)) 
        push!(eHn, mean(dTHlatn)) 
    end

    #::. prep figures
    fig = Figure(;)
    ax = Axis(fig[1,1];
        xlabel="Latitude [°]",
        xticks=0:20:90,
        ylabel="Mean Temperature Differences [K]")

    #::. plots
    lines!(ax, range(0,80,N), eB;  color=TUMBlack, linestyle=:dash, )
    lines!(ax, range(0,80,N), eBd; color=TUMBlack, linestyle=:dash, )
    lines!(ax, range(0,80,N), eBn; color=TUMBlack, linestyle=:dash, )
    lines!(ax, range(0,80,N), eH;  color=TUMBlack)
    lines!(ax, range(0,80,N), eHd; color=TUMBlack)
    lines!(ax, range(0,80,N), eHn; color=TUMBlack)

    scatter!(ax, range(0,80,N), eB;  color=TUMBlack, strokecolor=TUMBlack, strokewidth=0.7)
    scatter!(ax, range(0,80,N), eBd; color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:rect)
    scatter!(ax, range(0,80,N), eBn; color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:diamond)
    scatter!(ax, range(0,80,N), eH;  color=TUMBlack, strokewidth=0.7)
    scatter!(ax, range(0,80,N), eHd; color=:white, strokewidth=0.7, marker=:rect)
    scatter!(ax, range(0,80,N), eHn; color=:white, strokewidth=0.7, marker=:diamond)

    #::. legend
    l1 = LineElement(color=TUMBlack, linestyle=:dash, linewidth=2)
    l2 = LineElement(color=TUMBlack, linestyle=:solid, linewidth=2)
    m1 = MarkerElement(color=TUMBlack, strokecolor=TUMBlack, strokewidth=0.7, marker=:circle,)
    m2 = MarkerElement(color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:rect,)
    m3 = MarkerElement(color=:white, strokecolor=TUMBlack, strokewidth=0.7, marker=:diamond,)
    axislegend(ax,  
    [ m1, l2, m2, l1, m3],
        [ "Global", "Hurley et al. 2015", "Dayside", "Butler et al. 1997", "Nightside", ];
        position=:lt,
        nbanks=2,
        framevisible=false
    )

    #::. save figure
    save(joinpath(@__DIR__, "$(name).pdf"), fig)
    save(joinpath(@__DIR__, "$(name).svg"), fig)
    save(joinpath(@__DIR__, "$(name).png"), fig, px_per_unit=4)

    return nothing
end

function run_all()
    comparison_rms()
    comparison_mean()
end
