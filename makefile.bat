:: Copyright (c) 2012-2018 hzz

@echo off


:: compile the tex file

call makeclear

::pause

xelatex.exe --synctex=-1 exam.TEX
xelatex.exe --synctex=-1 exam.TEX
xelatex.exe --synctex=-1 exam.TEX

::call makeclear

