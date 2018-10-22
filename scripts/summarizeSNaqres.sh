#!/bin/bash

#loop through output files, and parse out analysis name, hmax, CPUtime, Nruns, Nfail, fabs, frel, xabs, xrel, seed, and under3450
#Write header line to csv
echo "analysis,h,CPUtime,Nruns,Nfail,fabs,frel,xabs,xrel,seed,under3450" > resultsSummary.csv

for outPath in out/*.out; do
	#get name from filename, parse out unnecessary bits
	analysis=` basename $outPath | sed 's/_snaq//' | sed 's/.out//'`
	logPath=`echo $outPath | sed 's/out/log/g'`

	#Time
	#cut off unnecessary bits from time
	outTime=`grep -oE 'Elapsed time: ([0-9.])+' $outPath | sed 's/.*: //'`

	#Hmax
	#trim non-numerics from hmax
	outHMAX=`grep 'hmax =' $logPath | sed 's/[^0-9]//g'`

	#Nruns: number of runs
	outNruns=`grep 'FINISHED' $logPath | wc -l`
	
	#Nfail: tuning parameter, "max number of failed proposals"
	outNfail=`grep -oE 'failed proposals = [0-9]+' $logPath | sed 's/.*= //'`

	#fabs
	outFabs=`grep -oE 'ftolAbs=[0-9e.-]+' $logPath | sed 's/.*=//'`

	#frel: "ftolRel"
	outFrel=`grep -oE 'ftolRel=[0-9e.-]+' $logPath | sed 's/.*=//'`

	#xabs: "xtolAbs"
	outXtolAbs=`grep -oE 'xtolAbs=[0-9e.-]+' $logPath | sed 's/.*=//'`

	#xrel: "xtolRel"
	outXtolRel=`grep -oE 'xtolRel=[0-9e.-]+[0-9]' $logPath | sed 's/.*=//'`

	#seed: "main seed"
	outSeed=`grep 'main seed' $logPath | grep -oE '[0-9]+'`
	
#under3450
	#start a tally then iterate through each run
	outUnder3450=0
	#get only the numbers
	loglike=`grep -oE 'loglik [0-9]+' $outPath|sed 's/loglik //g'`
	for score in $loglike;do
		#test whether it is equal to or smaller than 3449
		if(($score<=3449));then
			outUnder3450=$(($outUnder3450+1))
		fi
	done
	
	#construct line for output, then write it
	newLine="$analysis,$outHMAX,$outTime,$outNruns,$outNfail,$outFabs,$outFrel,$outXtolAbs,$outXtolRel,$outSeed,$outUnder3450"
	echo $newLine >> resultsSummary.csv
done