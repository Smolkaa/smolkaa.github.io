# load packages and themes
includet(joinpath(@__DIR__, "..","..","..","..","..","resources","julia","theme.jl"))

if !isdefined(Main, :ExESS)
    includet(joinpath(@__DIR__, "..","..","..","..","..","..","exess.jl","src","ExESS.jl"))
    using .ExESS
end

#::. additional packages
using DataFrames, CSV

#::. define path
DATA_PATH = joinpath(@__DIR__, "..", "..", "data", "ladee_data_derived")

#::. postprocessing functions
function get_file_names()
    dirs = readdir(DATA_PATH)
    dirs = filter(x -> occursin("20", x), dirs)
    files = String[]
    for dir in dirs
        new_files = readdir(joinpath(DATA_PATH, dir))
        new_files = filter(x -> occursin(r"csv$", x), new_files)
        files = vcat(files, joinpath.(dir, new_files))
    end
    return files
end
function get_file_names(element::String)
    files = get_file_names()
    files = filter(x -> occursin(lowercase(element), x), files)
    return files
end

function load_data(file::String)
    df = DataFrame(CSV.File(joinpath(DATA_PATH, "$file")))
    return df
end

function load_all_data(element::String)
    files = get_file_names(element)
    df = DataFrame()
    for file in files
        df = vcat(df, load_data(file))
    end
    return df
end

function find_max(df::DataFrame)
    idxs = Int64[]
    for (idx, val) in enumerate(df[:,14])
        if !isnan(val); push!(idxs, idx); end
    end
    n = df[idxs,14]
    val, idx = findmax(n)
    return val, df[idx, 13], df[idx,12]
end


#::. plotting functions
function plot_lat(element::String; kwargs...)
    df = load_all_data(element)
    plot_lat(df, element; kwargs...)
    return nothing
end
function plot_lat(df::DataFrame, element::String; stdfilter=1.0, cmap=reverse(ColorSchemes.deep))
    idxs = df[:,15] ./ df[:,14] .< stdfilter

    #::. figure and axis setup
    fig = Figure(resolution=(1000,230))
    ax = MyLTGeoAxis(fig[1, 1];
        xlabelpadding=30,
        xticks=([-180, -90, 0, 90, 180], ["","","","","",]),
        yticks=[-30,-15,0,15,30])
    ylims!(ax, -30, 30)
    night_shade(ax)

    #::. data
    sc = scatter!(ax, df[idxs, 13]/24*360 .- 180, df[idxs, 12];
        color=df[idxs, 14],
        colormap=cmap,
        colorrange=(0, 2e4),
        markersize=2)

    #::. plot maximum
    nmax, lonmax, latmax = find_max(df[idxs,:])
    scatter!(ax, lonmax/24*360 .- 180, latmax; color="red", markersize=10, marker=:utriangle)
    text!(ax, lonmax/24*360 .- 180, latmax; text="$(round((nmax/1e3); digits=1))", halign=:left, valign=:bottom, color="red")

    #::. colorbar
    Colorbar(fig[1,2], sc;
        label="$element Abundance [10³/cm³]",
        ticks=([0,5000,10000,15000,20000], ["0", "5", "10", "15", "20"]),
        highclip=cmap[end] |> RGB{Colors.N0f8})
    

    #::. custom x-axis labels
    ax2 = MyLTGeoAxis(fig[1, 1];
        spinewidth = 0,
        xticks=([-180, -90, 0, 90, 180], ["","","","","",]),
        yticks=[-30,-15,0,15,30])
    ylims!(ax2, -40, 30)
    hidedecorations!(ax2)
    text!(ax2, -140, -30; text= "0")
    text!(ax2,  -63, -30; text= "6")
    text!(ax2,   11, -30; text="12")
    text!(ax2,   89, -30; text="18")
    text!(ax2,  165, -30; text="24")

    #::. save figure
    save(joinpath(@__DIR__, "ladee_n0_$(element)_proj.pdf"), fig)
    # save(joinpath(@__DIR__, "ladee_n0_$(element)_proj.svg"), fig) # too big!
    save(joinpath(@__DIR__, "ladee_n0_$(element)_proj.png"), fig, px_per_unit=4)
    return nothing
end


#::.
get_all() = load_all_data("He"), load_all_data("Ne"), load_all_data("Ar")
function run_all(dfHe, dfNe, dfAr; T=250, kwargs...)
    dfHe_p, dfNe_p, dfAr_p = copy(dfHe), copy(dfNe), copy(dfAr)
    dfHe_p[:,14] .= projection_CHAMBERLAIN1963.(dfHe_p[:, 14], LUNAR_RADIUS .+ dfHe_p[:, 10]*1e3, LUNAR_RADIUS, T, amu2kg(4))
    dfNe_p[:,14] .= projection_CHAMBERLAIN1963.(dfNe_p[:, 14], LUNAR_RADIUS .+ dfNe_p[:, 10]*1e3, LUNAR_RADIUS, T, amu2kg(20))
    dfAr_p[:,14] .= projection_CHAMBERLAIN1963.(dfAr_p[:, 14], LUNAR_RADIUS .+ dfAr_p[:, 10]*1e3, LUNAR_RADIUS, T, amu2kg(40))
    plot_lat(dfHe_p, "He"; kwargs...)
    plot_lat(dfNe_p, "Ne"; kwargs...)
    plot_lat(dfAr_p, "Ar"; kwargs...)
end
