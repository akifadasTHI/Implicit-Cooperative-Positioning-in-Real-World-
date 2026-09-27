#!/usr/local/bin/gnuplot
set term wxt size 1400,800
set termoption noenhanced
set size 1,1
set title 'Tracked SBAS Satellites' font ',18'
set xlabel 'GPS TOW [s]' font ',13'
set ylabel 'CNo [dB-Hz]' font ',13'
set grid
set mxtics 5
set ytics 5
set mytics 5
set yrange [0:62]
set ytics nomirror
set y2range [110:174]
set y2tics 5
set y2label 'Satellite ID' font ',13'
set datafile separator ','
set key autotitle columnhead
set key outside
set label 'File: .\swift-gnss-20231221-133903.sbp.json' at graph 0, graph -0.06
plot 'swift-gnss-20231221-133903-trk.csv' u 2:415 with lines axes x1y1, \
     'swift-gnss-20231221-133903-trk.csv' u 2:414 with lines axes x1y2
pause mouse keypress 'Press ENTER to quit gnuplot'
