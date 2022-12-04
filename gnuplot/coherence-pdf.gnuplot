load 'palette/viridis.pal'

unset colorbox

stem = 'coherence-pdf'

set term epslatex color size 8.66cm,4.5cm font "" 10
set output stem . '.tex'

set margin 5.7, 0.25, 3, 0.4

set xrange [1.53:1.95]
set yrange [0:1]

set xlabel 'Coherence certifier $R_3$'
set xtics in mirror 0.1
set xtics add ('$\frac{47}{27}$' 47./27)
set mxtics 5

set ylabel 'Normalised \textsc{pdf}' offset 1,0
set ytics in mirror
set mytics 4

set key samplen 1.5 at 1.95, 0.96

set arrow 1 nohead from 47./27,0 to 47./27,1 lc rgb 000000 lw 1 dt (10, 10)

set label 1 at 1.648, 0.2 '\textcolor{vir1}{Unbiased}' rotate by 64
set label 2 at 1.815, 0.51 '\textcolor{vir6}{Na\"ive}' rotate by -63

plot stem.'.dat' every :::0::0 using 1:2 with lines ls 1 lw 3\
        title 'Gaussian \textsc{pdf}'\
    , stem.'.dat' every :::0::0 using 1:3 with points ls 4 lw 1 ps 1 pt 1\
        title 'Simulated \textsc{pdf}'\
    , stem.'.dat' every :::1 using 1:2 with lines ls 6 lw 3 notitle\
    , stem.'.dat' every :::1 using 1:3 with points ls 8 lw 1 ps 1 pt 1 notitle
