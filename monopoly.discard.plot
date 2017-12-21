#!/usr/bin/gnuplot

reset

set terminal svg size 350,262 fname 'Verdana, Helvetica, Arial, sans-serif' fsize '10'
set output 'monopoly.discard.svg'

unset key

plot 'monopoly.discard.dat' with linespoints ls 1
