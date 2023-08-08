
TABLE = joinpath(@__DIR__, "_photorates_HUEBNER1992.qmd")

function parsetable(name::String="photorates_HUEBNER1992")
    #::. read qmd table
    lines = readlines(TABLE)
    N = length(lines)

    #::. custom table header

    #::. find start of data
    Ndata = 1
    for i in 3:N; if lines[i][1:2] == "+="; Ndata = i; break; end; end

    #::. open tex file
    fid = open(joinpath(@__DIR__, "$name.tex"), "w+")

    #::. write table start
    write(fid, "\\documentclass[a4paper, 10pt]{article}\n\\usepackage{booktabs}\n\\usepackage[lmargin=10mm, rmargin=10mm]{geometry}\n\\usepackage[version=4]{mhchem}\n\\usepackage{tabularx}\n\\usepackage{siunitx}\n\\begin{document}\n\n")
    write(fid, "\\begin{table}\n\t\\centering\n\t\\caption{}\n\t\\begin{tabularx}{0.99\\textwidth}{lX rrrr}\n\t\t\\toprule\n")
    write(fid, "\t\t & Reaction & \\multicolumn{2}{c}{Quiet Sun} & \\multicolumn{2}{c}{Active Sun} \\\\\n")
    write(fid, "\t\t & & Ionization Rate & Excess Energy & Ionization Rate & Excess Energy \\\\\n")
    write(fid, "\t\t & & \$\\left[10^{-7}\\si{\\second\\tothe{-1}}\\right]\$ & \$\\left[\\si{\\electronvolt}\\right]\$ &  \$\\left[10^{-7}\\si{\\second\\tothe{-1}}\\right]\$ & \$\\left[\\si{\\electronvolt}\\right]\$\\\\\n")
    write(fid, "\t\t\\midrule\n")

    #::. write data
    for i in Ndata+1:N
        # break at end of table
        if isempty(lines[i]); break; end

        # handle midrule
        if lines[i][1:2] == "+-" && !isempty(lines[i+1])
            write(fid, "\t\t\\midrule\n")
            continue
        elseif isempty(lines[i+1])
            write(fid, "\t\t\\bottomrule\n")
            continue
        end

        # skip emtpy lines
        if lines[i][1:8] == "|    |  "; continue; end

        # handle data
        #M = length(lines[i])
        write(fid, "\t\t")
        s = replace(lines[i][3:end-1], 
            "|" => "&", 
            "\\nu " => "\$\\nu\$ ", 
            "</br>" => "")
        for _ in 1:10; s = replace(s, "  " => " "); end
        write(fid, s)
        write(fid, "\\\\\n")
    end

    #::. write table end
    write(fid, "\t\\end{tabularx}\n\t\\label{tab:photorates_HUEBNER1992}\n\\end{table}\n\\end{document}")
    
    #::. close tex file
    close(fid)
end