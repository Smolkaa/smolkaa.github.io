using DelimitedFiles, Statistics
include(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

#::. utility functions
function read_table(path::String=joinpath(@__DIR__, "photoionization_rates_BOCHSLER2013.csv"))
    table = readdlm(path, ',', Float64, '\n', header=true)
    return table[1], table[2]
end

function photoionization_rates_BOCHSLER2013(N::Integer)
    tab, _ = read_table()
    t, k = tab[:,3], tab[:,N]
    return t, k
end
 
function photoionization_rates_BOCHSLER2013(elem::Symbol)
    N = elem == :H ? 4 :
        elem == :He ? 5 :
        elem == :O ? 6 :
        elem == :Ne ? 7 : error("Element not supported")
    return photoionization_rates_BOCHSLER2013(N)
end

H_photoionization_rates_BOCHSLER2013() = photoionization_rates_BOCHSLER2013(4)
He_photoionization_rates_BOCHSLER2013() = photoionization_rates_BOCHSLER2013(5)
O_photoionization_rates_BOCHSLER2013() = photoionization_rates_BOCHSLER2013(6)
Ne_photoionization_rates_BOCHSLER2013() = photoionization_rates_BOCHSLER2013(7)


#::. postprocessing functions

function smoothing(k::AbstractVector; n=5)
    return [mean(k[max(1,i-n):min(length(k),i+n)]) for i in 1+n:length(k)-n]
end


#::. plotting functions
function plot_k_all(name::String="photoionization_rates_BOCHSLER2013"; n=5)
    t, kH  = photoionization_rates_BOCHSLER2013(:H)
    _, kHe = photoionization_rates_BOCHSLER2013(:He)
    _, kO  = photoionization_rates_BOCHSLER2013(:O)
    _, kNe = photoionization_rates_BOCHSLER2013(:Ne)

    t_smooth = t[1+n:end-n]
    kH_smooth = smoothing(kH; n=n)
    kHe_smooth = smoothing(kHe; n=n)
    kO_smooth = smoothing(kO; n=n)
    kNe_smooth = smoothing(kNe; n=n)

    kH_smooth_max = findmax(kH_smooth)
    kHe_smooth_max = findmax(kHe_smooth)
    kO_smooth_max = findmax(kO_smooth)
    kNe_smooth_max = findmax(kNe_smooth)

    kH_smooth_min = findmin(kH_smooth)
    kHe_smooth_min = findmin(kHe_smooth)
    kO_smooth_min = findmin(kO_smooth)
    kNe_smooth_min = findmin(kNe_smooth)

    #
    fig = Figure(resolution=(1200,600), fontsize=16)

    ax1 = Axis(fig[1,1]; yticks=[1.0, 1.3, 1.6]); hidexdecorations!(ax1; grid=false);
    scatter!(ax1, t, kH; color=TUMBlueLighter, markersize=2.5)
    lines!(ax1, t_smooth, kH_smooth; color=TUMBlack)
    scatter!(ax1, t_smooth[kH_smooth_max[2]], kH_smooth_max[1]; color=TUMBlack)
    hlines!(ax1, kH_smooth_max[1]; xmax=13/40, color=TUMBlack, linestyle=:dash)
    scatter!(ax1, t_smooth[kH_smooth_min[2]], kH_smooth_min[1]; color=TUMBlack)
    hlines!(ax1, kH_smooth_min[1]; xmax=0.83, color=TUMBlack, linestyle=:dash)
    Label(fig[1,1], "Hydrogen", justification=:right, tellheight=false, tellwidth=false, halign=:right, valign=:top, padding=(10,10,10,5), fontsize=FONTSIZE_BIG)

    ax2 = Axis(fig[2,1]; xlabel="Year", yticks=[1.0, 1.5, 2.0])
    scatter!(ax2, t, kHe; color=TUMBlueLighter, markersize=2.5)
    lines!(ax2, t_smooth, kHe_smooth; color=TUMBlack)
    scatter!(ax2, t_smooth[kHe_smooth_max[2]], kHe_smooth_max[1]; color=TUMBlack)
    hlines!(ax2, kHe_smooth_max[1]; xmax=13/40, color=TUMBlack, linestyle=:dash)
    scatter!(ax2, t_smooth[kHe_smooth_min[2]], kHe_smooth_min[1]; color=TUMBlack)
    hlines!(ax2, kHe_smooth_min[1]; xmax=0.83, color=TUMBlack, linestyle=:dash)
    Label(fig[2,1], "Helium", justification=:right, tellheight=false, tellwidth=false, halign=:right, valign=:top, padding=(10,10,10,5), fontsize=FONTSIZE_BIG)

    ax3 = Axis(fig[1,2]; yticks=([3, 5, 7], ["3.0","5.0","7.0"])); hidexdecorations!(ax3; grid=false);
    scatter!(ax3, t, kO; color=TUMBlueLighter, markersize=2.5)
    lines!(ax3, t_smooth, kO_smooth; color=TUMBlack)
    scatter!(ax3, t_smooth[kO_smooth_max[2]], kO_smooth_max[1]; color=TUMBlack)
    hlines!(ax3, kO_smooth_max[1]; xmax=13/40, color=TUMBlack, linestyle=:dash)
    scatter!(ax3, t_smooth[kO_smooth_min[2]], kO_smooth_min[1]; color=TUMBlack)
    hlines!(ax3, kO_smooth_min[1]; xmax=0.83, color=TUMBlack, linestyle=:dash)
    Label(fig[1,2], "Oxygen", justification=:right, tellheight=false, tellwidth=false, halign=:right, valign=:top, padding=(10,10,10,5), fontsize=FONTSIZE_BIG)

    ax4 = Axis(fig[2,2]; xlabel="Year", yticks=([2.0, 4.0, 6.0],["2.0","4.0","6.0"]))
    ld = scatter!(ax4, t, kNe; color=TUMBlueLighter, markersize=2.5)
    ly = lines!(ax4, t_smooth, kNe_smooth; color=TUMBlack)
    scatter!(ax4, t_smooth[kNe_smooth_max[2]], kNe_smooth_max[1]; color=TUMBlack)
    lmax = hlines!(ax4, kNe_smooth_max[1]; xmax=13/40, color=TUMBlack, linestyle=:dash)
    scatter!(ax4, t_smooth[kNe_smooth_min[2]], kNe_smooth_min[1]; color=TUMBlack)
    lmin = hlines!(ax4, kNe_smooth_min[1]; xmax=0.83, color=TUMBlack, linestyle=:dash)
    Label(fig[2,2], "Neon", justification=:right, tellheight=false, tellwidth=false, halign=:right, valign=:top, padding=(10,10,10,5), fontsize=FONTSIZE_BIG)

    Label(fig[:,0], "Photoionization Rate [10⁻⁷ s⁻¹]", rotation=pi/2)


    da = MarkerElement(color=TUMBlueLighter, marker=:circle, markersize=12)
    ya = LineElement(color=TUMBlack, linestyle=:solid, linewidth=3)
    mm = LineElement(color=TUMBlack, linestyle=:dash, linewidth=2)
    Legend(fig[0,:], [da,ya,mm], ["day average", "year average", "maximum/minimum year averages"]; orientation=:horizontal)

    save(joinpath(@__DIR__, "$name.pdf"), fig)
    save(joinpath(@__DIR__, "$name.png"), fig, px_per_unit=4)
end

function plot_all()
    plot_k_all(; n=182)
end