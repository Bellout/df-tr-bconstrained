#!/bin/bash

# COPY CG PROB FILES
TRGDIR=~/Dropbox/SharedFolderTRDFO/reports/r02-2019-trdfo-benchmark/data/cg-probs
FODIR=~/git/MB/FOEx/FOEx/cmake-build-debug/dbg/tr_dfo
MACH=xe-snopt
# MACH=bport-snopt

cp  ${FODIR}/prob1/prob-soln-iters-${MACH}-prob1_FOCPP.txt  ${TRGDIR}/prob01/prob-soln-iters-${MACH}-prob1-FOCPP.tex
cp  ${FODIR}/prob2/prob-soln-iters-${MACH}-prob2_FOCPP.txt  ${TRGDIR}/prob02/prob-soln-iters-${MACH}-prob2-FOCPP.tex
cp  ${FODIR}/prob3/prob-soln-iters-${MACH}-prob3_FOCPP.txt  ${TRGDIR}/prob03/prob-soln-iters-${MACH}-prob3-FOCPP.tex
cp  ${FODIR}/prob4/prob-soln-iters-${MACH}-prob4_FOCPP.txt  ${TRGDIR}/prob04/prob-soln-iters-${MACH}-prob4-FOCPP.tex
cp  ${FODIR}/prob5/prob-soln-iters-${MACH}-prob5_FOCPP.txt  ${TRGDIR}/prob05/prob-soln-iters-${MACH}-prob5-FOCPP.tex
cp  ${FODIR}/prob6/prob-soln-iters-${MACH}-prob6_FOCPP.txt  ${TRGDIR}/prob06/prob-soln-iters-${MACH}-prob6-FOCPP.tex
cp  ${FODIR}/prob7/prob-soln-iters-${MACH}-prob7_FOCPP.txt  ${TRGDIR}/prob07/prob-soln-iters-${MACH}-prob7-FOCPP.tex
cp  ${FODIR}/prob8/prob-soln-iters-${MACH}-prob8_FOCPP.txt  ${TRGDIR}/prob08/prob-soln-iters-${MACH}-prob8-FOCPP.tex
cp  ${FODIR}/prob9/prob-soln-iters-${MACH}-prob9_FOCPP.txt  ${TRGDIR}/prob09/prob-soln-iters-${MACH}-prob9-FOCPP.tex
cp ${FODIR}/prob10/prob-soln-iters-${MACH}-prob10_FOCPP.txt ${TRGDIR}/prob10/prob-soln-iters-${MACH}-prob10-FOCPP.tex
cp ${FODIR}/prob11/prob-soln-iters-${MACH}-prob11_FOCPP.txt ${TRGDIR}/prob11/prob-soln-iters-${MACH}-prob11-FOCPP.tex
