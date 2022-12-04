load 'palette/viridis.pal'

stem = 'coherence-phase'

set term epslatex color size 14cm,4.5cm font "" 10 rounded
set output stem . '-2-3.tex'

set lmargin 5.7
set rmargin 0.9
set bmargin 2.2
set tmargin 0.4

set multiplot layout 1, 2

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

f(x) = 0.5 * (1 + cos(pi*x))
g(x) = (1./9.) * (3 + 4*cos(pi*x) + 2*cos(2*pi*x))

set label 1 center at 1, 0.8 '$\ket{g,1} + \ket{g,2}$'
set label 2 center at 1, 0.8 offset 0,-1.5 '$R_3 = \num{1.090(12)}$'
plot stem.'.dat' index 0 using 1:2:($2 - $3):($2 + $4) with errorbars ls 1 lw 1 ps 1 pt 2\
   , f(x) with lines ls 7 lw 2

unset ylabel
set label 1 center at 1, 0.8 '$\ket{g,0} + \ket{g,1} + \ket{g,2}$'
set label 2 center at 1, 0.8 offset 0,-1.5 '$R_3 = \num{1.54(2)}$'
plot stem.'.dat' index 1 using 1:2:($2 - $3):($2 + $4) with errorbars ls 1 lw 1 ps 1 pt 2\
   , g(x) with lines ls 7 lw 2
