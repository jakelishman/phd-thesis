reset
load 'palette/viridis.pal'

stem = 'beyondld-fidelity'
set terminal epslatex color colortext size 8.5cm,4.923cm font "" 10
set output stem.'.tex'

set margin 6.73, 0.25, 3.3, 0.4

set logscale xy
set xrange [0.01 : 1]
set yrange [1e-12 : 1]

set xtics format ""
set xtics add ('$\frac1{100}$' 0.01, '$\frac1{10}$' 0.1, '$1$' 1)
#set xtics add ('$10^{-2}$' 0.01, '$10^{-1}$' 0.1, '$1$' 1)
#set xtics add ('$0.01$' 0.01, '$0.1$' 0.1, '$1$' 1)
set ytics format "" offset 0.5, 0
set ytics add ('$1$' 1)
do for [i=-2:-12:-2] {
    set ytics add (sprintf('$10^{%d}$', i) 10**i)
}

set xlabel 'Lamb--Dicke parameter $\eta$' offset 0,-0.3
set ylabel 'Infidelity' offset 1.65, 0

set dashtype 1 (8, 2, 2, 2)
set dashtype 2 (5, 5)
set dashtype 3 (2, 2)

noplot(x) = 1/0
set style line 9  lc rgb '#777777' lw 1.5
set style line 10 lc rgb '#cc4778'

set key bottom right samplen 4 spacing 1.1

set label 1 at 0.017, 6e-6 'One sideband' rotate by 19 tc ls 1
set label 2 at 0.04, 3e-9 'Two sidebands' rotate by 34 tc ls 4
set label 3 at 0.105, 4e-11 'Three sidebands' rotate by 40 tc ls 7

set label 4 at 0.011, 5e-9 '${\propto}\mkern 1mu\eta^4$' tc ls 9
set label 5 at 0.0333, 5e-12 '${\propto}\mkern 1mu\eta^8$' tc ls 9
set label 6 at 0.0722, 5e-12 '${\propto}\mkern 1mu\eta^{10}$' tc ls 9

plot 0.8*x**4 with lines ls 9 notitle\
   , 5*x**8 with lines ls 9 notitle\
   , 2*x**10 with lines ls 9 notitle\
   , for [n=0:2] stem.'-1.dat'\
        using 1:(column(n+2)) with lines ls 1 lw 2 dashtype n+1 notitle\
   , for [n=0:2] stem.'-2.dat'\
        using 1:(column(n+2)) with lines ls 4 lw 2 dashtype n+1 notitle\
   , for [n=0:2] stem.'-3.dat'\
        using 1:(column(n+2)) with lines ls 7 lw 2 dashtype n+1 notitle\
   , for [n=0:2] noplot(x) with lines ls 10 lw 2 dashtype n+1\
        title sprintf('{\figureversion{tabular}$\lvert%d\rangle$\hspace*{0.5em}}', n)
