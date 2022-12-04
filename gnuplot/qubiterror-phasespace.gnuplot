reset
load 'palette/plasma.pal'

stem='qubiterror-phasespace'

set term epslatex color rounded size 8.663cm,4.65cm font "" 10
set output stem . '.tex'

set multiplot layout 2,3\
              margin char 0.2, char 0.2, char 0.07, char 0.07\
              spacing char 0.75, char 0.5


set size ratio -1

set style line 10 linecolor rgbcolor "#dc322f" pt 2 # red

set xzeroaxis lt 1 lc 'black'
set yzeroaxis lt 1 lc 'black'
set xrange [-1.25:2.5]
set yrange [-1.5:1.5]

set xtics axis format '' 1 offset char 0, char 0.5
set xtics add ('$-1$' -1, '$1$' 1, '$2$' 2)
set mxtics 4
set ytics axis -3, 2 offset char 0.2, char 0
set mytics 8

set label 1 at 0, 0 "$0$" offset char -1.2, char -0.7
set label 2 at 1.85, 0.4 '$\langle\hat x\rangle$'
set label 3 at 0.15, 1.2 '$\langle\hat p\rangle$'

set cbrange [0:1.25]
unset colorbox

do for [n=1:6] {
    set label 4 at 2.42, 1.25 sprintf("%d tone%s", n, n == 1 ? "" : "s") right
    plot stem.'.dat' using 1:2:3 index (n-1) with lines ls 1 lw 3 lc palette notitle
}
