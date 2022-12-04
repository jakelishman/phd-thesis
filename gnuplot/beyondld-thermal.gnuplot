reset
load 'palette/inferno.pal'
set palette negative

stem = 'beyondld-thermal'
set terminal epslatex color colortext size 13.9cm,4.7cm font "" 10\
    header '\newcommand*\hhl[1]{\colorbox{white}{#1}}'
set output stem.'.tex'

set xrange [-2 : 0]
set yrange [log10(0.6) : 2]
set logscale zcb
unset key

set xtics scale 0,0 format "" in mirror (-2 0, -1 0, 0 0)
do for [n=2:9] {
    set xtics add (log10(n)-2 1, log10(n)-1 1)
}

set ytics scale 0,0 format ""
set y2tics in scale 0,0 format "" (0 0, 1 0, 2 0)
do for [n=2:9] {
    set y2tics add (log10(n)-1 1, log10(n) 1, log10(n)+1 1)
}

set tics front

set multiplot

gutter_l = 0.072
gutter_r = 0
gutter_t = 0.22
gutter_b = 0.09

cbox_height = 0.07
cbox_v_gap = 0.04

space = 0.03
plot_width = (1 - (gutter_l + gutter_r + 2*space))/3

cbox_gutter_l = gutter_l + 0.405
cbox_gutter_r = 0.855 - gutter_r

set cbrange [1e-8 : 1e-1]
set colorbox horizontal user origin screen cbox_gutter_l, screen gutter_b\
    size screen (cbox_gutter_r - cbox_gutter_l), screen cbox_height
set cbtics format ""

cbox_h_centre = cbox_gutter_l + 0.5*(cbox_gutter_r - cbox_gutter_l)
cbox_v_centre = gutter_b + 0.5*cbox_height
set label 1 at screen cbox_gutter_l, screen cbox_v_centre right '${\le}10^{-8}$' offset -0.4,-0.05
set label 2 at screen cbox_gutter_r, screen cbox_v_centre left '${\ge}10^{-1}$' offset 0.5,-0.05
set label 3 at screen cbox_h_centre, screen gutter_b center "Infidelity" offset 0,-0.7

set bmargin at screen gutter_b + cbox_height + cbox_v_gap
set tmargin at screen (1 - gutter_t)

set label 5 at graph 0, graph 1 left '\strut$\frac1{100}$' offset 0,1
set label 6 at graph 0.5, graph 1 center '\strut$\frac1{10}$' offset 0,1
set label 7 at graph 1, graph 1 right '\strut$1$' offset 0,1

set ytics add ('$1$' 0 0, '$10$' 1 0, '$100$' 2 0) offset 0.5,0

set label 8 at graph 1, graph 1 '\hhl{(a)}' front offset -3,-0.95

set style line 1 linecolor 'white' lw 2 dt (5,5)
set style line 2 linecolor 'white' lw 2

set key at screen gutter_l, screen gutter_b + 0.09 left top Left samplen 4.5 width -1

cbtic_length = 0.031
tic_length = 0.0445

cbox_top = cbox_v_centre + 0.5*cbox_height + 0.0015
cbox_bot = cbox_v_centre - 0.5*cbox_height - 0.0015
do for [major=1:4] { do for [side=0:1] {
    tag_base = 600 + 20*major + 10*side
    h_loc = cbox_gutter_r + 1.001*(major - 1.)*(cbox_gutter_l - cbox_gutter_r)/7.
    set arrow tag_base lc rgbcolor 'white' lw 1.6\
        from screen h_loc, screen cbox_bot + side*(cbox_top - cbox_bot)\
        length graph cbtic_length angle 90 + 180*side nohead front
    do for [minor=2:9] {
        tag_base = 600 + 20*major + 10*side + minor
        h_loc = cbox_gutter_r + 1.001*(major - log10(minor))*(cbox_gutter_l - cbox_gutter_r)/7.
        set arrow tag_base lc rgbcolor 'white' lw 1.6\
            from screen h_loc, screen cbox_bot + side*(cbox_top - cbox_bot)\
            length graph cbtic_length/2. angle 90 + 180*side nohead front } } }

# x-axis tics
do for [side=0:1] { do for [major=1:2] {
    tag_base = 100 + 200*side + 10*major
    if (major == 1) {
        set arrow tag_base+1 from -major, graph 1.0046*side-0.0023 \
            length graph tic_length angle 90+180*side nohead front }
    do for [minor=2:7] {
        set arrow tag_base+minor from log10(minor)-major, graph 1.0046*side-0.0023\
            length graph tic_length/2 angle 90+180*side nohead front } } }
# y-axis tics
do for [side=0:1] { do for [major=0:2] {
    tag_base = 200*side + 10*major
    if (major < 2) {
        set arrow tag_base+1 from graph 1.0034*side-0.0017, first major \
            length graph tic_length angle 180*side nohead front }
    do for [minor=2:9] {
        if (major == 0 && minor < 7) { continue }
        set arrow tag_base+minor from graph 1.0034*side-0.0017, first log10(minor)+major-1 \
            length graph tic_length/2 angle 180*side nohead front } } }



# x-axis tics
do for [side=0:1] { do for [major=0:2] {
    tag_base = 100 + 200*side + 10*major
    if (major == 1) {
        cc = 'white'
        set arrow tag_base+1 lc rgbcolor cc }
    do for [minor=2:9] {
        if (side == 0 && major > 1 && minor <= 3) { cc = 'black' } else { cc = 'white'}
        set arrow tag_base+minor lc rgbcolor cc } } }
# y-axis tics
do for [side=0:1] { do for [major=0:2] {
    tag_base = 200*side + 10*major
    if (major < 2) {
        if (side == 0) { cc = 'black' } else { cc = 'white' }
        set arrow tag_base+1 lc rgbcolor cc }
    do for [minor=2:9] {
        if (major == 0 && minor < 7) { continue }
        if (side == 0 && major < 2) { cc = 'black' } else { cc = 'white'}
        set arrow tag_base+minor lc rgbcolor cc } } }
set ylabel 'Thermal occupation $\bar n$' offset 1.3,0
set lmargin at screen gutter_l
set rmargin at screen (gutter_l+plot_width)
plot stem.'.dat' index 0 with image notitle\
   , stem.'-contour-0.dat' every :::0::0 with lines ls 1 notitle\
   , stem.'-contour-0.dat' every :::2::2 with lines ls 2 notitle\
   , 1/0 with lines ls 2 lc 'black' title '$10^{-3}$' \
   , 1/0 with lines ls 1 lc 'black' title '$10^{-5}$'
do for [i=1:3] {unset label i}
unset key



# x-axis tics
do for [side=0:1] { do for [major=1:2] {
    tag_base = 100 + 200*side + 10*major
    if (major == 1) {
        if (side == 0) { cc = 'black' } else { cc = 'white' }
        set arrow tag_base+1 lc rgbcolor cc }
    do for [minor=2:9] {
        if (side == 0 && major == 2) { cc = 'black' } else { cc = 'white'}
        set arrow tag_base+minor lc rgbcolor cc } } }
set x2label 'Lamb--Dicke parameter $\eta$' offset 0,1.4
# y-axis tics
do for [side=0:1] { do for [major=0:2] {
    tag_base = 200*side + 10*major
    if (major < 2) {
        if (side == 0) { cc = 'black' } else { cc = 'white' }
        set arrow tag_base+1 lc rgbcolor cc }
    do for [minor=2:9] {
        if (major == 0 && minor < 7) { continue }
        if (side == 0) { cc = 'black' } else { cc = 'white'}
        set arrow tag_base+minor lc rgbcolor cc } } }
set label 8 '\hhl{(b)}'
unset ylabel
unset ytics
set ytics scale 0 format ""
set lmargin at screen (gutter_l+plot_width+space)
set rmargin at screen (gutter_l+2*plot_width+space)
plot stem.'.dat' index 1 with image \
   , stem.'-contour-1.dat' every :::0::0 with lines ls 1 notitle\
   , stem.'-contour-1.dat' every :::2::2 with lines ls 2 notitle



# x-axis tics
do for [side=0:1] { do for [major=1:2] {
    tag_base = 100 + 200*side + 10*major
    if (major == 1) {
        if (side == 0) { cc = 'black' } else { cc = 'white' }
        set arrow tag_base+1 lc rgbcolor cc }
    do for [minor=2:9] {
        if ((side == 0 && (major > 1 || minor == 2)) || (side == 1 && major == 2 && minor < 4)) { cc = 'black' } else { cc = 'white'}
        set arrow tag_base+minor lc rgbcolor cc } } }
# y-axis tics
do for [side=0:1] { do for [major=0:2] {
    if (side == 0) { cc = 'black' } else { cc = 'white' }
    tag_base = 200*side + 10*major
    if (major < 2) {
        set arrow tag_base+1 lc rgbcolor cc }
    do for [minor=2:9] {
        if (major == 0 && minor < 7) { continue }
        set arrow tag_base+minor lc rgbcolor cc } } }
set label 8 '\hhl{(c)}'
unset xlabel
unset x2label
set ytics scale 0 format ""
set lmargin at screen (gutter_l+2*plot_width+2*space)
set rmargin at screen (1 - gutter_r)
plot stem.'.dat' index 2 with image \
   , stem.'-contour-2.dat' every :::0::0 with lines ls 1 notitle\
   , stem.'-contour-2.dat' every :::2::2 with lines ls 2 notitle
