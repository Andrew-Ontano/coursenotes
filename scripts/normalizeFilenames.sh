#!/bin/bash

#Additional testcases added: "timetest_snaq.log & timetest100_snaq.log"
#These test-cases allow readability for output formats that do not automatically append numbers, and allow for the overflow past 2 digits

#Move down to the target directory
cd log

#Matching regex for zero or one non-zero decimal places
#Using 0-9 results in double-appended 0 on subsequent runs of the script to the testcase "timetest_snaq.log"
regex='timetest?([1-9])_snaq.log'
for i in timetest*_snaq.log;do
	#if file matches regex, replace name with appended filename
	if [[ $i = $regex ]];then
		tempName=`echo $i | sed 's/timetest/timetest0/'`
		mv $i $tempName
	fi
done

#Repeat process for output files

#Move down to the target directory
cd ../out

#Matching regex for zero or one non-zero decimal places
#Using 0-9 results in double-appended 0 on subsequent runs of the script to the testcase "timetest_snaq.log"
regex='timetest?([1-9])_snaq.out'
for i in timetest*_snaq.out;do
	#if file matches regex, replace name with appended filename
	if [[ $i = $regex ]];then
		tempName=`echo $i | sed 's/timetest/timetest0/'`
		mv $i $tempName
	fi
done
