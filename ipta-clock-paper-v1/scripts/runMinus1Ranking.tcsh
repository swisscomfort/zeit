#!/usr/bin/tcsh
#
awk '{if ($1 < 53780) {print $2,$3,1.0/$3/$3}}' ../finalClock/ifunc.bipm.dat > early.use
awk '{if ($1 > 53780 && $1 < 55970) {print $2,$3,1.0/$3/$3}}' ../finalClock/ifunc.bipm.dat > late.use
set earlyAll = `stats -f early.use -col 1 -sdev | grep Sdev | awk '{print $2}'`
set lateAll = `stats -f late.use -col 1 -sdev | grep Sdev | awk '{print $2}'`
set earlySumErrAll = `stats -f early.use -col 3 -sum | grep Sum | awk '{print $2}'`
set lateSumErrAll = `stats -f late.use -col 3 -sum | grep Sum | awk '{print $2}'`
set nptsEarlyAll = `wc -l early.use | tail -1 | awk '{print $1}'`
set nptsLateAll = `wc -l late.use | tail -1 | awk '{print $1}'`
set earlyWrmsStatAll = `echo $earlySumErrAll $nptsEarlyAll | awk '{print sqrt($2/$1)}'`
set lateWrmsStatAll = `echo $lateSumErrAll $nptsLateAll | awk '{print sqrt($2/$1)}'`
echo "All: $earlyAll $lateAll $earlyWrmsStatAll $lateWrmsStatAll"

foreach minusPSR (`ls ../finalClock/ifunc.bipm_minus*.dat`)
 set psr = `echo $minusPSR | awk -F "minus" '{print $2}' | sed s/".dat"/""/g`
 awk '{if ($1 < 53780) {print $2,$3,1.0/$3/$3}}' ../finalClock/ifunc.bipm_minus$psr.dat > early.use
 awk '{if ($1 > 53780 && $1 < 55970) {print $2,$3,1.0/$3/$3}}' ../finalClock/ifunc.bipm_minus$psr.dat > late.use
 set early = `stats -f early.use -col 1 -sdev | grep Sdev | awk '{print $2}'`
 set late = `stats -f late.use -col 1 -sdev | grep Sdev | awk '{print $2}'`
 set earlySumErr = `stats -f early.use -col 3 -sum | grep Sum | awk '{print $2}'` 
 set lateSumErr = `stats -f late.use -col 3 -sum | grep Sum | awk '{print $2}'`
 set nptsEarly = `wc -l early.use | tail -1 | awk '{print $1}'`
 set nptsLate = `wc -l late.use | tail -1 | awk '{print $1}'`
 set earlyWrmsStat = `echo $earlySumErr $nptsEarly | awk '{print sqrt($2/$1)}'`
 set lateWrmsStat = `echo $lateSumErr $nptsLate | awk '{print sqrt($2/$1)}'`

 set r1 = `echo $early $earlyAll | awk '{print ($1-$2)/$2}'`
 set r2 = `echo $late $lateAll | awk '{print ($1-$2)/$2}'`
 set r3 = `echo $earlyWrmsStat $earlyWrmsStatAll | awk '{print ($1-$2)/$2}'`
 set r4 = `echo $lateWrmsStat $lateWrmsStatAll | awk '{print ($1-$2)/$2}'`
 echo $psr $early $late $earlyWrmsStat $lateWrmsStat "rank: " $r1 $r2 $r3 $r4 
end
