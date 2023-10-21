#::. load packages
if !isdefined(Main, :CairoMakie);   using CairoMakie;   end
if !isdefined(Main, :GeoMakie);     using GeoMakie;     end
if !isdefined(Main, :ColorSchemes); using ColorSchemes; end
CairoMakie.activate!()

#::. load colors
include(joinpath(@__DIR__, "colors.jl"))

#::. define font paths
JM_REG  = joinpath(@__DIR__, "JuliaMono-Regular.ttf")
JM_BOLD = joinpath(@__DIR__, "JuliaMono-Bold.ttf")

#::. define sizes
const FONTSIZE_SMALL  = 14
const FONTSIZE_MAIN   = 16
const FONTSIZE_BIG    = 18

#:: define (default) theme
default = Theme(
	font        = JM_REG,
	fontsize    = FONTSIZE_MAIN,
	resolution  = (600,400),

	Axis = (
		backgroundcolor = :white,
	    titlefont       = JM_BOLD, 
		titlesize       = FONTSIZE_BIG,
		xlabelfont      = JM_REG,
		xticklabelfont  = JM_REG,
		ylabelfont      = JM_REG,
		yticklabelfont  = JM_REG,
	),

	Axis3 = (
		backgroundcolor = :white,
	    titlefont       = JM_BOLD, 
		titlesize       = FONTSIZE_BIG,
		xlabelfont      = JM_REG,
		xticklabelfont  = JM_REG,
		ylabelfont      = JM_REG,
		yticklabelfont  = JM_REG,
	),

	Colorbar = (
		labelfont       = JM_REG,
		labelsize       = FONTSIZE_MAIN,
		ticklabelfont   = JM_REG,
		ticklabelsize   = FONTSIZE_SMALL,
	),

	Label = (
		font = JM_REG,
	),

	Legend = (
		labelsize = FONTSIZE_SMALL,
		labelfont = JM_REG,
	    titlefont = JM_BOLD, 
	),

	Lines = (
		color = TUMBlack,
		linewidth = 1.5,
	),

	Text = (
		font = JM_REG,
	),

	Scatter = (
        markersize = 8,
	),
)

#::. set default theme
set_theme!(default)


#::. preformat GeoMakie.GeoAxis
function MyGeoAxis(fig; kwargs...) 
    return GeoAxis(fig; 
        bottomspinevisible  = false,
        dest                = "+proj=natearth2", 
        leftspinevisible    = false,
        rightspinevisible   = false,
        topspinevisible     = false,
        xgridcolor          = (:black, 0.3),
        xtickformat         = Makie.automatic,
        yticks              = [-60,-30,0,30,60,90],
        kwargs...
    )
end

function MyLTGeoAxis(fig; kwargs...)
    return MyGeoAxis(fig;
        xlabel          = "Local Time [h]",
        xticklabelpad   = 0.1,
        xticks          = ([-180,-90,0,90,180], ["0","6","12","18","24"]),
        ylabel          = "Latitude [°]",
        kwargs...
    )
end


#::. GeoAxis Night-Shade
function night_shade(ax; N=10, color=(:gray, 0.3), kwargs...)
    for i in 1:N, j in [-1, 1]
        points = Point2f[
            (j*90,-30 + (i-1)*60/N), 
            (j*180,-30 + (i-1)*60/N), 
            (j*180,-30 + i*60/N), 
            (j*90,-30 + i*60/N)
        ]
        poly!(ax, points; color=color, kwargs...)
    end
end