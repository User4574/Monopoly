#!/usr/bin/gnuplot

reset

set terminal svg size 350,262 fname 'Verdana, Helvetica, Arial, sans-serif' fsize '10'
set output 'monopoly.bottom.svg'

unset key

plot 'monopoly.bottom.dat' with linespoints ls 1
