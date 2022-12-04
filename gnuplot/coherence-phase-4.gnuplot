load 'palette/viridis.pal'

stem = 'coherence-phase'

set term epslatex color size 8.66cm,4.5cm font "" 10 rounded
set output stem . '-4.tex'

set lmargin 5.7
set rmargin 0.9
set bmargin 2.2
set tmargin 0.4

set xrange [0:2]
set yrange [0:1]

set xlabel 'Evolution phase' offset 0,0.8
set xtics format '' 0.5 in mirror 1 offset 0,0.3
set xtics add ('$0$' 0, '$\pi$' 1, '$2\pi$' 2)
set mxtics 4

set ylabel 'Probability of excitation' offset 0.7
set ytics in mirror offset 0.2
set mytics 4

set bars 0.7

unset key

set label 1 center at 1, 0.8 '$\ket{g,0} + \ket{g,1} + \ket{g,2} +\ket{g,3}$'
set label 2 center at 1, 0.8 offset 0,-1.5 '$R_3 = \num{1.35(3)}$'

f(x) = 0.125 * (2 + 3*cos(pi*x) + 2*cos(2*pi*x) + cos(3*pi*x))

plot stem.'-4-approximate.dat' every 2 using 1:($2 - $3):($2 + $4) with filledcurves ls 4 fillstyle transparent solid 0.5\
   , stem.'-4-approximate.dat' every 2 using 1:2 with lines ls 4 lw 2 dt (5, 5)\
   , f(x) with lines ls 7 lw 2\
   , stem.'.dat' index 2 using 1:2:($2 - $3):($2 + $4) with errorbars ls 1 lw 1 ps 1 pt 2
