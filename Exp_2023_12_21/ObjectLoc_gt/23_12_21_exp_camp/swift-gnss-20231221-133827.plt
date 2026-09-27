#!/usr/local/bin/gnuplot
set term wxt size 1400,800
set termoption noenhanced
set size 1,1
set title 'Navigation Data' font ',18'
set xlabel 'GPS TOW [s]' font ',13'
set ylabel 'Data' font ',13'
set grid
set mxtics 5
set mytics 2
set datafile separator ','
set key autotitle columnhead
set key outside
set key title 'Data'
set label 'File: .\swift-gnss-20231221-133827.sbp.json' at graph 0, graph -0.06
plot for [col=3:7] 'swift-gnss-20231221-133827.csv' u 2:col with linespoints, \
     for [col=10:32] 'swift-gnss-20231221-133827.csv' u 2:col with linespoints
pause mouse keypress 'Press ENTER to quit gnuplot'
