#!/bin/bash

# COPY CG PROB FILES
TRGDIR=~/Dropbox/SharedFolderTRDFO/reports/r02-2019-trdfo-benchmark/data/cg-probs
CGDIR=~/git/MB/df-tr-bconstrained/trust_region_test
MACH=xe-snopt
# MACH=bport

cp ${CGDIR}/prob-soln-iters-${MACH}-prob1-MATLAB.tex ${TRGDIR}/prob01
cp ${CGDIR}/prob-soln-iters-${MACH}-prob2-MATLAB.tex ${TRGDIR}/prob02
cp ${CGDIR}/prob-soln-iters-${MACH}-prob3-MATLAB.tex ${TRGDIR}/prob03
cp ${CGDIR}/prob-soln-iters-${MACH}-prob4-MATLAB.tex ${TRGDIR}/prob04
cp ${CGDIR}/prob-soln-iters-${MACH}-prob5-MATLAB.tex ${TRGDIR}/prob05
cp ${CGDIR}/prob-soln-iters-${MACH}-prob6-MATLAB.tex ${TRGDIR}/prob06
cp ${CGDIR}/prob-soln-iters-${MACH}-prob7-MATLAB.tex ${TRGDIR}/prob07
cp ${CGDIR}/prob-soln-iters-${MACH}-prob8-MATLAB.tex ${TRGDIR}/prob08
cp ${CGDIR}/prob-soln-iters-${MACH}-prob9-MATLAB.tex ${TRGDIR}/prob09
cp ${CGDIR}/prob-soln-iters-${MACH}-prob10-MATLAB.tex ${TRGDIR}/prob10
cp ${CGDIR}/prob-soln-iters-${MACH}-prob11-MATLAB.tex ${TRGDIR}/prob11
