#!/usr/local/bin/gnuplot
set term wxt size 1400,800
set termoption noenhanced
set size 1,1
set title 'Tracked Signals' font ',18'
set xlabel 'GPS TOW [s]' font ',13'
set ylabel 'Number of Signals' font ',13'
set grid
set mxtics 5
set ytics 1
set yrange [0:14.5]
set datafile separator ','
set key autotitle columnhead
set key title 'Signals'
set label 'File: .\swift-gnss-20231221-133827.sbp.json' at graph 0, graph -0.06
plot for [col=6:17] 'swift-gnss-20231221-133827-trk.csv' u 2:col with linespoints
pause mouse keypress 'Press ENTER to quit gnuplot'
