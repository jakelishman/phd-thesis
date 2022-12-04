reset
load 'palette/plasma.pal'

r_top = 1.11
r_bot = 1.27

array xmin = [-0.8,  -0.73, -0.495, -0.35, -0.365,  -0.18]
array xmax = [ 0.82,  0.55,  0.44,   0.49,  0.2495,  0.32]
array yshift = [0.62, 0.71]

array sample = [1, 1, 1]

# Measurements below are all in cm.
SX = 8.5
space = 0.1
gutter_l = 0.35
gutter_r = 0.05
gutter_t = 0.40
gutter_b = 0.03
plot_width = (SX - 2*space - gutter_l - gutter_r)/3
SY = space + (r_top + r_bot)*plot_width + gutter_t + gutter_b

fig_width_cm = gprintf("%5.4ecm", SX)
fig_height_cm = gprintf("%5.4ecm", SY)

stem = 'beyondld-phase'
set terminal epslatex color rounded size @fig_width_cm , @fig_height_cm font "" 10
set output stem.'.tex'

set margin 0.2

set multiplot

set size ratio -1
set style line 10 linecolor rgbcolor "#ffffff" # white
set xzeroaxis lt 1 lc 'black'
set yzeroaxis lt 1 lc 'black'
set cbrange [0:1]
unset colorbox

colour_range = 0.8
number_rows = 301

ylim(xmin, xmax, r) = 0.5 * (xmax - xmin) * r

array C[4]
C[1] = 0.0   * colour_range
C[2] = 1./3. * colour_range
C[3] = 2./3. * colour_range
C[4] = 1.0   * colour_range

set label 3 center 'One sideband' \
    at screen (gutter_l + 0.5*plot_width)/SX, screen (SY - 0.5*gutter_t)/SY
set label 4 center 'Two sidebands' \
    at screen (gutter_l + 1.5*plot_width + space)/SX, screen (SY - 0.5*gutter_t)/SY
set label 5 center 'Three sidebands' \
    at screen (gutter_l + 2.5*plot_width + 2*space)/SX, screen (SY - 0.5*gutter_t)/SY

set label 6 center rotate by 90 '$\eta = 0.1,\quad\bar n = 0.01$' \
    at screen (0.5*gutter_l)/SX, screen ((0.5*r_top + r_bot)*plot_width + space + gutter_b)/SY \
    offset -0.2, 0
set label 7 center rotate by 90 '$\eta = 0.5,\quad\bar n = 2$' \
    at screen (0.5*gutter_l)/SX, screen (0.5*r_bot*plot_width + gutter_b)/SY \
    offset -0.2, 0





cur_stem = stem.'-eta0.1-nbar0.01'

set xtics axis format '' 0.5 in offset char 0, char 3.7
set xtics add ('$-\frac12$' -0.5, '$\frac12$' 0.5)
set ytics axis format '' 0.5 offset char 0.2, char 0
set ytics add ('$\frac12$' 0.5, '$1$' 1.0)
set mxtics 4
set mytics 4

set label 1 at graph 0.80, graph 0.09 '$\langle\hat x\rangle$'
set label 2 at 0, graph 0.92 '$\langle\hat p\rangle$' offset 1, 0
do for [k=1:3] {
    set margin 0, 0, 0, 0
    set origin (gutter_l + (k-1)*(plot_width + space))/SX,\
               (r_bot*plot_width + space + gutter_b)/SY
    set size plot_width/SX, r_top*plot_width/SY
    set xrange [xmin[k]:xmax[k]]
    set yrange [(yshift[1]-1) * ylim(xmin[k], xmax[k], r_top) \
                : (yshift[1] + 1) * ylim(xmin[k], xmax[k], r_top)]

    phase_file = cur_stem . '.dat'
    contour_file = cur_stem . '-contours-' . sprintf("%d", k) . '.dat'
    plot phase_file using 1:2:(colour_range * sample[k] * $0/(number_rows - 1.)) every sample[k]:::(k-1)::(k-1) with lines ls 1 lw 3 lc palette notitle \
       , contour_file with lines ls 10 lw 3.5 notitle\
       , contour_file using 1:2:(C[1+column(-2)]) every sample[k] with lines lw 2 dt (2,1) lc palette notitle
    if (k == 1) { unset for [i=3:7] label i }
}



cur_stem = stem.'-eta0.5-nbar2'

set xtics axis format '' 0.25 in offset char 0, char 3.5
set xtics add ('$-\frac14$' -0.25, '$\frac14$' 0.25)
set ytics axis format '' 0.25 offset char 0.2, char 0
set ytics add ('$\frac14$' 0.25, '$\frac12$' 0.5, '$\frac34$' 0.75)
set mxtics 4
set mytics 4

set label 1 at graph 0.80, graph 0.07 '$\langle\hat x\rangle$'
set label 2 at 0, graph 0.93 '$\langle\hat p\rangle$' offset 1, 0
do for [k=1:3] {
    set margin 0, 0, 0, 0
    set origin (gutter_l + (k-1)*(plot_width + space))/SX, gutter_b/SY
    set size plot_width/SX, r_bot*plot_width/SY
    set xrange [xmin[k+3]:xmax[k+3]]
    set yrange [(yshift[2]-1) * ylim(xmin[k+3], xmax[k+3], r_bot) \
                : (yshift[2] + 1) * ylim(xmin[k+3], xmax[k+3], r_bot)]

    phase_file = cur_stem . '.dat'
    contour_file = cur_stem . '-contours-' . sprintf("%d", k) . '.dat'
    plot phase_file using 1:2:(colour_range * sample[k] * $0/(number_rows - 1.)) every sample[k]:::(k-1)::(k-1) with lines ls 1 lw 3 lc palette notitle \
       , contour_file with lines ls 10 lw 3.5 notitle\
       , contour_file using 1:2:(C[1+column(-2)]) every sample[k] with lines lw 2 dt (2,1) lc palette notitle
}
