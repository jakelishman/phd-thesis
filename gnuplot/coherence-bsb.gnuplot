load 'palette/viridis.pal'

unset colorbox

stem = 'coherence-bsb'

set term epslatex color size 14cm,4.5cm font "" 10 rounded
set output stem . '.tex'

set lmargin 5.9
set rmargin 0.2
set tmargin 0.4
set bmargin 2.2

set xrange [0:1.00623]
set yrange [0:1]

set xlabel 'Time (\si{\milli\s})' offset 0,0.8
set xtics in mirror 0.2 offset 0,0.2
set mxtics 5

set ylabel 'Probability of excitation' offset 0.5
set ytics in mirror offset 0.2
set mytics 4

unset key

plot stem.'_2_bootstrap.dat' every 2 using 1:3:4 with filledcurves ls 4 fillstyle transparent solid 0.5\
    , stem.'_2_bootstrap.dat' every 2 using 1:2 with lines ls 4 lw 2\
    , stem.'_2_points.dat' using 1:2:($2 - $3):($2 + $4) with errorbars ls 1 lw 1 ps 1 pt 2
