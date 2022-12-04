reset
load 'qubiterror-tonelinestyles.gnuconf'

stem='qubiterror-results'

set term epslatex color size 8.663cm,6cm font "" 10
set output stem . '.tex'

set multiplot
set logscale xy

set xlabel 'Detuning magnitude $\lvert\vec\delta\rvert/\epsilon_1$' offset 0,0.5
set xtics in mirror
set format x "$10^{%T}$"

set ylabel 'Gate infidelity' offset char 1.4, 0
set ytics in mirror offset char 0.5, 0
set format y "$10^{%T}$"

set lmargin 6.0
set rmargin 0.1
set tmargin 0.1
set bmargin 2.6

set key bottom right reverse width -1

set angle degrees

ang = 25
set label 1 "Standard gate" at 2.76e-2, 1.6e-3 rotate by ang offset char -0.75*sin(ang), char 0.75*cos(ang)

# x values multiplied by 4 because the thesis defines base detuning differently to the paper (thesis uses the more natural definition)
set xrange [1.2e-3:1.6e-1]
set yrange [1e-7:2e-1]
plot for [i=3:7] stem.'-infidelity.dat' using (4 * column(1)):i with lines ls (i - 1)\
                                        title sprintf('%d tones', i-1),\
     stem.'-infidelity.dat' using (4 * column(1)):2 with lines ls 1 notitle


unset label 1
set size 0.3, 0.25
set origin 0.24, 0.71
set margin 0,0,0,0
clear

unset logscale
unset key
set xrange [0:1]
set yrange [0:1]
set xlabel 'Gate time' offset 0,1.2
set ylabel 'Amplitude' offset 1.4,0.15
set format xy
set xtics in mirror 1 offset 0,0.3
set mxtics 4
set ytics in mirror 1 offset 0.5,0
set mytics 4

plot for [i=2:6] stem.'-amplitude.dat' using 1:i with lines ls i
unset multiplot
