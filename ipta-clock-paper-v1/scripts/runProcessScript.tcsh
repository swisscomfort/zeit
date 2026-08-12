#!/usr/bin/tcsh
#    
# Script to process the IPTA data sets to produce the data used by
# the frequentist processing in the IPTA clock project
#
# This script makes use of     
# - inputParFiles
# - inputTimFiles
#    
# G. Hobbs: 27th Oct 2017
#
#
    
set SCRIPT_DIR = `pwd`
    
set psr = $1
if ($psr =~ "") then
 echo "Must give a pulsar name on the command line"
 exit
endif
echo "Processing $psr"
    
# Jump to required part of the script
# step1: check that we have the required software
# step2: process EPTA data
# step3: process PPTA data
# step4: process NANOGrav data
# step5: sort out bands    
# step6: DM correction
# step7/step8: spectral modelling
# step9: tidy up

#goto step6
# Check that we have the required software
step1:

echo "Checking software"
set have = `which tcsh | tail -1 | grep "Command not found" | wc -l`
if ($have =~ "1") then
 echo "Sorry: this is a tcsh script. Please install tcsh"
 exit
endif
#
set have = `which tempo2 | tail -1 | grep "Command not found" | wc -l`
if ($have =~ "1") then
 echo "Sorry: we require tempo2. Please install"
 exit
endif
#
set have = `tempo2 -gr efacEquad |& grep -i "failed while resolving" | wc -l`
if ($have =~ "1") then
 echo "Sorry: we require the efacEquad plugin to tempo2. Please install"
 exit
endif
#
set have = `tempo2 -gr plk |& grep -i "failed while resolving" | wc -l`
if ($have =~ "1") then
 echo "Sorry: we require the plk plugin to tempo2. Please install"
 exit
endif
#
set have = `tempo2 -gr averageData |& grep -i "failed while resolving" | wc -l`
if ($have =~ "1") then
 echo "Sorry: we require the averageData plugin to tempo2. Please install"
 exit
endif
#
set t2ver = `tempo2 -v | tail -1 | awk '{print $1}'`
if ($t2ver !~ "2017.03.1") then
 echo "Warning: this pipeline was developed with tempo2 version 2017.03.1. Your version is $t2ver."
endif
echo "Completed checking software"

step2:
cd ../tempFiles

set nfiles = `ls | wc -l`
if ($nfiles !~ "0") then
 echo "Temporary file directory is not empty. Please clean it."
 exit
endif
date > $psr.log
whoami >> $psr.log
uname -a >> $psr.log
echo -n "Tempo2 version " >> $psr.log    
tempo2 -v >> $psr.log    
   
#
# EPTA data processing
#
# Do we want to do any EPTA processing
   set eptaFiles = `grep $psr $SCRIPT_DIR/inputTimFiles | grep EPTA | awk '{print $3}' | wc -l`
if ($eptaFiles =~ "0") then
 echo "No EPTA processing"
 echo "No EPTA processing" >> $psr.log
else     
 echo "Have EPTA data for processing"
 echo "Have EPTA data for processing" >> $psr.log
 set eptaFileName = `grep $psr $SCRIPT_DIR/inputTimFiles | grep EPTA | awk '{print $3}'`
 echo "FORMAT 1" > epta.tim
#
# Remove early or late data
# Change "g" to "eff"
    #
if ($psr =~ "J1713+0747") then    
 grep -v FORMAT $SCRIPT_DIR/../$eptaFileName | awk '{if ($5 == "g") {$5="eff"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta EPTA -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930 && ($3 < 54745 || $3 > 54822)) {print $0}}' >> epta.tim
else if ($psr =~ "J0030+0451") then
    # Remove two very early data points
 grep -v FORMAT $SCRIPT_DIR/../$eptaFileName | awk '{if ($5 == "g") {$5="eff"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta EPTA -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 51280 && $3 < 55930) {print $0}}' >> epta.tim
else if ($psr =~ "J1012+5307") then
 # The IPTA data release is wrong for WSRT.P1.328.C data    
 grep -v FORMAT $SCRIPT_DIR/../$eptaFileName | awk '{if ($5 == "g") {$5="eff"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta EPTA -telID",$5}}' | sort -k3g | grep "sys " | sed s/"0.001-sys"/"0.001 -sys"/g | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' >> epta.tim
else
 grep -v FORMAT $SCRIPT_DIR/../$eptaFileName | awk '{if ($5 == "g") {$5="eff"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta EPTA -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' >> epta.tim
endif
    
 set parFileName = `grep $psr $SCRIPT_DIR/inputParFiles | awk '{print $2}'`    
 cat $SCRIPT_DIR/../$parFileName | grep -v START | grep -v FINISH | grep -v FD | grep -v JUMP | grep -v EFAC | grep -v EQUAD | grep -v DM2 | awk '{if ($1 == "DMOFF") {print $1,$2,$3} else if ($1 == "DMMODEL") {print "DMMODEL DM 0"} else {print $1,$2}}' > {$psr}_epta.par

 awk '{if (length($5) > 0) {print $5}}' epta.tim | sort | uniq > epta.tels
    
 rm epta.efacEquad.dat
 touch epta.efacEquad.dat
 foreach tel (`cat epta.tels`)
  echo "FORMAT 1" > epta.$tel.tim
  grep "\-telID $tel" epta.tim >> epta.$tel.tim
  # Divide into systems
  foreach sys (`awk -F "\-sys" '{print $2}' epta.$tel.tim | awk '{if (length($1) > 0) {print $1}}' | sort | uniq`)
    echo "FORMAT 1" > epta.$tel.sys_$sys.tim

    grep "\-sys $sys " epta.$tel.tim >> epta.$tel.sys_$sys.tim

    set largeError = `sort -k4g epta.$tel.sys_$sys.tim | awk '{print $4}' | tail -1`
    set stepEquad = `echo $largeError | awk '{print $1/100.0}'`
    echo $largeError
    tempo2 -gr efacEquad -plot -f {$psr}_epta.par epta.$tel.sys_$sys.tim -nofit -fit f0 -fit f1 -flag -sys -maxEquad $largeError -stepEquad $stepEquad
     cat efacEquad_output.dat >> epta.efacEquad.dat	
   end
  end

  cat {$psr}_epta.par epta.efacEquad.dat > {$psr}_epta_wEfac_Equad.par    

  # Add band jumps
  \rm temp/epta*bands*.tim    
  foreach tim (`ls epta*.sys_*.tim | grep -v bands`)    
   set bname = `echo $tim | sed s/".tim"/".bands.tim"/g`
   echo "FORMAT 1" > $bname
   grep -v FORMAT $tim | awk '{if ($2 < 500) {print $0,"-nband b1"} else if ($2 < 1000) {print $0,"-nband b2"} else if ($2 < 1500) {print $0,"-nband b3"} else if ($2 < 2000) {print $0,"-nband b4"} else if ($2 < 2500) {print $0,"-nband b5"} else if ($2 < 3000) {print $0,"-nband b6"} else if ($2 < 3500) {print $0,"-nband b7"} else {print $0,"-nband b8"}}' >> $bname
  end
  #
  # inspect each one 
  #
  foreach tim (`ls epta*.sys_*.bands.tim`)
   tempo2 -gr plk -f {$psr}_epta_wEfac_Equad.par $tim -nofit
  end

# End check for EPTA processing
endif


step3:
cd ../tempFiles
#
# PPTA data processing
#
# Do we want to do any PPTA processing?
  set pptaFiles = `grep $psr $SCRIPT_DIR/inputTimFiles | grep PPTA | awk '{print $3}' | wc -l`
if ($pptaFiles =~ "0") then
  echo "No PPTA processing"
  echo "No PPTA processing" >> $psr.log
else     
  echo "Have PPTA data for processing"
  echo "Have PPTA data for processing" >> $psr.log
  set pptaFileName = `grep $psr $SCRIPT_DIR/inputTimFiles | grep PPTA | awk '{print $3}'`
  set parFileName = `grep $psr $SCRIPT_DIR/inputParFiles | awk '{print $2}'`    

  # Should we just take the Reardon data set?
  if ($psr =~ "J0711-6830" || $psr =~ "J0437-4715" || $psr =~ "J1045-4509" || $psr =~ "J1603-7202" || $psr =~ "J1732-5049" || $psr =~ "J1824-2452A" || $psr =~ "J2129-5721") then
    cat $SCRIPT_DIR/../$parFileName | sed s/"-f "/"-sys "/g > $psr.par
    grep EFAC $SCRIPT_DIR/../$pptaFileName | sed s/"-f "/"-sys "/g | grep -v "#" >> $psr.par
    grep EQUAD $SCRIPT_DIR/../$pptaFileName | sed s/"-f "/"-sys "/g | grep -v "#" >> $psr.par
    echo "FORMAT 1" > $psr.tim	
    grep -v FORMAT $SCRIPT_DIR/../$pptaFileName | grep -v EFAC | grep -v EQUAD  | awk '{if ($5 == "7") {$5="PKS"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta PPTA -telID",$5}}' | sed s/"-f "/"-sys "/g | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' >> $psr.tim
    set nModel = `echo $parFileName | sed s/".par"/".split.model"/`
    cp $SCRIPT_DIR/../$nModel $psr.model	
	# Add bands
    echo "FORMAT 1" > $psr.withbands.tim
    grep -v FORMAT $psr.tim | awk '{if ($2 < 500) {print $0,"-nband b1"} else if ($2 < 1000) {print $0,"-nband b2"} else if ($2 < 1500) {print $0,"-nband b3"} else if ($2 < 2000) {print $0,"-nband b4"} else if ($2 < 2500) {print $0,"-nband b5"} else if ($2 < 3000) {print $0,"-nband b6"} else if ($2 < 3500) {print $0,"-nband b7"} else {print $0,"-nband b8"}}' >> $psr.withbands.tim

    tempo2 -gr plk -f $psr.par $psr.withbands.tim -dcf $psr.model
    #
    # REMOVE BAND 1 AND BAND 2 FOR FINAL PROCESSING *****
    #
    sort -k3n $psr.withbands.tim > $psr.sort.tim    
    grep -v "\-nband b1" $psr.sort.tim | grep -v "\nband b2" > $psr.use.tim    
    # Remove relevant jumps
    cp $psr.par $psr.jumpRemoval.par
    foreach sys (`grep "\-nband b1" $psr.sort.tim | awk -F "-sys" '{print $2}' | awk '{print $1}' | sort | uniq`)
      grep -v "JUMP \-sys $sys " $psr.jumpRemoval.par > tt
      mv tt $psr.jumpRemoval.par   
     end
     foreach sys (`grep "\-nband b2" $psr.sort.tim | awk -F "-sys" '{print $2}' | awk '{print $1}' | sort | uniq`)
      grep -v "JUMP \-sys $sys " $psr.jumpRemoval.par > tt
      mv tt $psr.jumpRemoval.par   
     end

    # Turn off DM and JUMP fitting    
    awk '{if ($1 == "JUMP") {print $1,$2,$3,$4,0} else if ($1 == "DM" || $1 == "DM1" || $1 == "DMMODEL") {print $1,$2,0} else {print $0}}' $psr.jumpRemoval.par > $psr.use.par

    tempo2 -gr plk -f $psr.use.par $psr.use.tim -fit f0 -fit f1 -dcf $psr.model

    if ($psr =~ "J0711-6830"  || $psr =~ "J1732-5049" || $psr =~ "J1824-2452A" || $psr =~ "J2129-5721") then
     step_repeat1:
     tempo2 -gr spectralModel -f $psr.use.par $psr.use.tim -nofit -fit f0 -fit f1 
     echo "Repeat process (n = no, y = repeat, i = iterate using new model)"
     set next = $<
     if ($next =~ "y") then
      goto step_repeat1
     endif
     step_repeat2:
     if ($next =~ "i") then
      tempo2 -gr spectralModel -f $psr.use.par $psr.use.tim -nofit -fit f0 -fit f1 -dcf $psr.model
      echo "Repeat process (n = no, y = repeat, i = iterate using new model)"
      set next = $<
      if ($next =~ "y") then
       goto step_repeat1
      else
       goto step_repeat2
      endif
     endif

    else if ($psr =~ "J0437-4715" || $psr =~ "J1045-4509" || $psr =~ "J1603-7202") then # Just take Daniel's noise models
     # Do nothing	
    else
      echo "NOT SURE WHAT TO DO WITH THIS PULSAR"
      exit
    endif

    cp $psr.use.par $psr.finalFit.par

    goto step9
    #
    #

  else 
   echo "FORMAT 1" > ppta.tim
 #
 # Remove early or late data
 # Change "7" to "pks"
 #
 # Check if -sys flags are present
 if ($psr =~ "J1909-3744") then    
  grep -v FORMAT $SCRIPT_DIR/../$pptaFileName | awk '{if ($5 == "7") {$5="PKS"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta PPTA -telID",$5}}' | sed s/"-f "/"-sys "/g | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' >> ppta.tim
 else if ($psr =~ "J1713+0747") then    
  grep -v FORMAT $SCRIPT_DIR/../$pptaFileName | awk '{if ($5 == "7") {$5="PKS"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta PPTA -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930 && ($3 < 54745 || $3 > 54822)) {print $0}}' >> ppta.tim
 else if ($psr =~ "J1857+0943" || $psr =~ "J1744-1134" || $psr =~ "J0613-0200" || $psr =~ "J1600-3053" || $psr =~ "J1730-2304" || $psr =~ "J2145-0750" || $psr =~ "J2124-3358" || $psr =~ "J1643-1224" || $psr =~ "J1022+1001" || $psr =~ "J1024-0719") then
  grep -v FORMAT $SCRIPT_DIR/../$pptaFileName | awk '{if ($5 == "7") {$5="PKS"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta PPTA -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' >> ppta.tim
 else
   echo "Must choose how to process PPTA data for this pulsar"
   exit
 endif
 # Check for -sys flags
set noSys = `grep -v "\-sys" ppta.tim | wc -l`
if ($noSys =~ "1") then
# Check noSys = 1    
else
 echo "PPTA data have some lines without -sys parameters. Please fix"
 exit
endif    
 # Remove systems that we don't like
 grep -v "PKS.50CM.PDFB3.50CM " ppta.tim | grep -v "MULTI_APSR " | grep -v "MULTI_CASPSR " | grep -v "50CM.CPSR2.40CM " > tt
 mv tt ppta.tim   
 if ($psr =~ "J1744-1134" || $psr =~ "J1600-3053" || $psr =~ "J2145-0750") then
  # These data points add nothing as they have a jump and a small data span
  grep -v "PKS.H-OH.fptm1.20cm_legacy " ppta.tim > tt
  mv tt ppta.tim  
 else if ($psr =~ "J1730-2304") then
  grep -v "PKS.H-OH.CPSR2m.20CM " ppta.tim | grep -v "PKS.H-OH.CPSR2n.20CM " > tt
  mv tt ppta.tim      
 else if ($psr =~ "J1643-1224" || $psr =~ "J1022+1001" || $psr =~ "J1024-0719") then
  grep -v "PKS.H-OH.CPSR2m.20CM " ppta.tim | grep -v "PKS.H-OH.CPSR2n.20CM " | grep -v "PKS.H-OH.cpsr2m.20cm_legacy " | grep -v "PKS.H-OH.cpsr2n.20cm_legacy " > tt
  mv tt ppta.tim      
 else if ($psr =~ "J0613-0200") then
  grep -v "PKS.50cm.cpsr2.20cm_legacy " ppta.tim | grep -v "PKS.H-OH.CPSR2m.20CM " | grep -v "PKS.H-OH.CPSR2n.20CM " | grep -v "PKS.H-OH.cpsr2n.20cm_legacy " | grep -v "PKS.H-OH.cpsr2m.20cm_legacy " > tt
  mv tt ppta.tim          
 else if ($psr =~ "J2124-3358") then
  grep -v "PKS.H-OH.AFB.20cm_legacy " ppta.tim | grep -v "PKS.H-OH.CPSR2m.20CM " | grep -v "PKS.H-OH.CPSR2n.20CM " > tt
  mv tt ppta.tim      
 endif   
 if ($psr =~ "J1713+0747") then
  grep -v "PKS.MULTI.APSR.20CM " ppta.tim | grep -v "PKS.H-OH.CPSR2n.20CM" | grep -v "PKS.H-OH.CSPSR2m.20CM" | grep -v "PKS.50CM.PDFB3.50CM" | grep -v "PKS.H-OH.CPSR2m.20CM" > tt
  mv tt ppta.tim  
 endif   
 awk '{if (length($5) > 0) {print $5}}' ppta.tim | sort | uniq > ppta.tels
    
 set parFileName = `grep $psr $SCRIPT_DIR/inputParFiles | awk '{print $2}'`    
echo "ABC"
 cat $SCRIPT_DIR/../$parFileName | grep -v START | grep -v FINISH | grep -v FD | grep -v JUMP | grep -v EFAC | grep -v EQUAD | grep -v DM2 | awk '{if ($1 == "DMOFF") {print $1,$2,$3} else if ($1 == "DMMODEL") {print "DMMODEL DM 0"} else {print $1,$2}}' > {$psr}_ppta.par
echo "DEF"
 rm ppta.efacEquad.dat
 touch ppta.efacEquad.dat
 foreach tel (`cat ppta.tels`)
  echo "FORMAT 1" > ppta.$tel.tim
  grep "\-telID $tel" ppta.tim >> ppta.$tel.tim
  # Divide into systems
  foreach sys (`awk -F "\-sys" '{print $2}' ppta.$tel.tim | awk '{if (length($1) > 0) {print $1}}' | sort | uniq`)
   echo "FORMAT 1" > ppta.$tel.sys_$sys.tim

   grep "\-sys $sys " ppta.$tel.tim >> ppta.$tel.sys_$sys.tim

   set largeError = `sort -k4g ppta.$tel.sys_$sys.tim | awk '{print $4}' | tail -1`
   set stepEquad = `echo $largeError | awk '{print $1/100.0}'`
   echo $largeError
   tempo2 -gr efacEquad -plot -f {$psr}_ppta.par ppta.$tel.sys_$sys.tim -nofit -fit f0 -fit f1 -flag -sys -maxEquad $largeError -stepEquad $stepEquad
   # Some error bars get significantly smaller with the EFAC/EQUAD plugin for 1730.
   if ($sys =~ "PKS.H-OH.PDFB1.20CM" && $psr =~ "J1730-2304") then
    echo "T2EFAC 1" > efacEquad_output.dat
   else if ($sys =~ "PKS.MULTI.AFB.20cm_legacy" && $psr =~ "J1730-2304") then
    echo "T2EFAC 1" > efacEquad_output.dat
   else if ($sys =~ "PKS.MULTI.cpsr2n.20cm_legacy" && $psr =~ "J1730-2304") then
    echo "T2EFAC 1" > efacEquad_output.dat
   endif
   cat efacEquad_output.dat >> ppta.efacEquad.dat	
  end
 end
 echo "DOWN HERE"
 cat {$psr}_ppta.par ppta.efacEquad.dat > {$psr}_ppta_wEfac_Equad.par
 # Add band jumps
 \rm ppta*bands*.tim    
 foreach tim (`ls ppta*.sys_*.tim | grep -v bands`)    
  set bname = `echo $tim | sed s/".tim"/".bands.tim"/g`
  echo "FORMAT 1" > $bname
  grep -v FORMAT $tim | awk '{if ($2 < 500) {print $0,"-nband b1"} else if ($2 < 1000) {print $0,"-nband b2"} else if ($2 < 1500) {print $0,"-nband b3"} else if ($2 < 2000) {print $0,"-nband b4"} else if ($2 < 2500) {print $0,"-nband b5"} else if ($2 < 3000) {print $0,"-nband b6"} else if ($2 < 3500) {print $0,"-nband b7"} else {print $0,"-nband b8"}}' >> $bname
 end
 echo "INSPECTING"
 #
 # inspect each one
 #
 foreach tim (`ls ppta*.sys_*.bands.tim`)
  tempo2 -gr plk -f {$psr}_ppta_wEfac_Equad.par $tim -nofit
 end
    
# End processing of PPTA data
 endif
endif


step4:
cd ../tempFiles
# Do we want to do any NANOGRav early processing?
  set nanoFiles = `grep $psr $SCRIPT_DIR/inputTimFiles | grep "NANO_EARLY" | awk '{print $3}' | wc -l`
if ($nanoFiles =~ "0") then
 echo "No NANOGrav early processing"
 echo "No NANOGrav early processing" >> $psr.log
else     
 echo "Have NANOGrav early data for processing"
 echo "Have NANOGrav early data for processing" >> $psr.log
 set nanoFileName = `grep $psr $SCRIPT_DIR/inputTimFiles | grep "NANO_EARLY" | awk '{print $3}'`
 echo "FORMAT 1" > earlyNano.tim
 if ($psr =~ "J1713+0747") then
  grep -v FORMAT $SCRIPT_DIR/../$nanoFileName | awk '{if ($5 == "1") {$5="gbt"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta NANO -telID",$5}}' | sed s/"group"/"sys"/g | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930 && ($3 < 54745 || $3 > 54822)) {print $0}}' >> earlyNANO.tim
  else
   echo "Do not know what to do with this pulsar?"
   exit
 endif
 set parFileName = `grep $psr $SCRIPT_DIR/inputParFiles | awk '{print $2}'`    
 cat $SCRIPT_DIR/../$parFileName | grep -v START | grep -v FINISH | grep -v FD | grep -v JUMP | grep -v EFAC | grep -v EQUAD | grep -v DM2 | awk '{if ($1 == "DMOFF") {print $1,$2,$3} else if ($1 == "DMMODEL") {print "DMMODEL DM 0"} else {print $1,$2}}' > {$psr}_earlyNANO.par

 awk '{if (length($5) > 0) {print $5}}' earlyNANO.tim | sort | uniq > earlyNANO.tels
 foreach tel (`cat earlyNano.tels`)
  echo "FORMAT 1" > earlyNano.$tel.tim
  grep "\-telID $tel" earlyNano.tim >> earlyNano.$tel.tim
  # Divide into systems
  foreach sys (`awk -F "\-sys" '{print $2}' earlyNano.$tel.tim | awk '{if (length($1) > 0) {print $1}}' | sort | uniq`)
   echo "FORMAT 1" > earlyNano.$tel.sys_$sys.tim
   grep "\-sys $sys " earlyNano.$tel.tim >> earlyNano.$tel.sys_$sys.tim
  end
 end
# Add band jumps
 \rm earlyNano*bands*.tim    
 foreach tim (`ls earlyNano*.sys_*.tim | grep -v bands`)    
  set bname = `echo $tim | sed s/".tim"/".bands.tim"/g`
  echo "FORMAT 1" > $bname
  grep -v FORMAT $tim | awk '{if ($2 < 500) {print $0,"-nband b1"} else if ($2 < 1000) {print $0,"-nband b2"} else if ($2 < 1500) {print $0,"-nband b3"} else if ($2 < 2000) {print $0,"-nband b4"} else if ($2 < 2500) {print $0,"-nband b5"} else if ($2 < 3000) {print $0,"-nband b6"} else if ($2 < 3500) {print $0,"-nband b7"} else {print $0,"-nband b8"}}' >> $bname
 end
 rm earlyNano.efacEquad.dat
 touch earlyNano.efacEquad.dat
 foreach tim (`ls earlyNano*.bands.tim`)
   set largeError = `sort -k4g $tim | awk '{print $4*2}' | tail -1`
   set stepEquad = `echo $largeError | awk '{print $1/500.0}'`
   echo $largeError
   tempo2 -gr efacEquad -plot -f {$psr}_earlyNano.par $tim -nofit -fit f0 -fit f1 -flag -sys -maxEquad $largeError -stepEquad $stepEquad
   cat efacEquad_output.dat >> earlyNano.efacEquad.dat
 end

 cat {$psr}_earlyNano.par earlyNano.efacEquad.dat > {$psr}_earlyNano_wEfac_Equad.par


 #
 # Inspect the data
 #   
 foreach tim (`ls earlyNano*.sys_*.bands.tim`)
  tempo2 -gr plk -f {$psr}_earlyNANO_wEfac_Equad.par $tim -nofit
 end
endif

step4.5:
cd ../tempFiles    
# NANOGrav processing recent   
# Do we want to do any NANOGrav recent processing?
  set nanoFiles = `grep $psr $SCRIPT_DIR/inputTimFiles | grep "NANO_RECENT" | awk '{print $3}' | wc -l`
if ($nanoFiles =~ "0") then
 echo "No NANOGrav recent processing"
 echo "No NANOGrav recent processing" >> $psr.log
else
 echo "Have NANOGrav recent data for processing"
 echo "Have NANOGrav recent data for processing" >> $psr.log


# Recent processing
 set nanoFileName = `grep $psr $SCRIPT_DIR/inputTimFiles | grep "NANO_RECENT" | awk '{print $3}'`
 echo "FORMAT 1" > recentNano.tim
 if ($psr =~ "J1713+0747") then
  grep -v FORMAT $SCRIPT_DIR/../$nanoFileName | awk '{if ($5 == "1") {$5="gbt"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta NANO -telID",$5}}' | sed s/"group"/"sys"/g | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930 && ($3 < 54745 || $3 > 54822)) {print $0}}' >> recentNANO.tim
  else if ($psr =~ "J1853+1303" || $psr =~ "J1955+2908") then
# Only 1 observation of ASP.S
   grep -v FORMAT $SCRIPT_DIR/../$nanoFileName | awk '{if ($5 == "1") {$5="gbt"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta NANO -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' | grep -v ao.ASP.S >> recentNANO.tim
  else
   grep -v FORMAT $SCRIPT_DIR/../$nanoFileName | awk '{if ($5 == "1") {$5="gbt"} {print $0}}' | awk '{if ($1 != "C") {print $0,"-npta NANO -telID",$5}}' | sort -k3g | grep "sys " | awk '{if ($3 > 49400 && $3 < 55930) {print $0}}' >> recentNANO.tim
  endif
    
 set parFileName = `grep $psr $SCRIPT_DIR/inputParFiles | awk '{print $2}'`    
 cat $SCRIPT_DIR/../$parFileName | grep -v START | grep -v FINISH | grep -v FD | grep -v JUMP | grep -v EFAC | grep -v EQUAD | grep -v DM2 | awk '{if ($1 == "DMOFF") {print $1,$2,$3} else if ($1 == "DMMODEL") {print "DMMODEL DM 0"} else {print $1,$2}}' > {$psr}_recentNANO.par

 awk '{if (length($5) > 0) {print $5}}' recentNANO.tim | sort | uniq > recentNANO.tels
 foreach tel (`cat recentNano.tels`)
  echo "FORMAT 1" > recentNano.$tel.tim
  grep "\-telID $tel" recentNano.tim >> recentNano.$tel.tim
  # Divide into systems
  foreach sys (`awk -F "\-sys" '{print $2}' recentNano.$tel.tim | awk '{if (length($1) > 0) {print $1}}' | sort | uniq`)
   echo "FORMAT 1" > recentNano.$tel.sys_$sys.tim
   grep "\-sys $sys " recentNano.$tel.tim >> recentNano.$tel.sys_$sys.tim
  end
 end
# Add band jumps
 \rm recentNano*bands*.tim    
 foreach tim (`ls recentNano*.sys_*.tim | grep -v bands`)    
  set bname = `echo $tim | sed s/".tim"/".bands.tim"/g`
  echo "FORMAT 1" > $bname
  grep -v FORMAT $tim | awk '{if ($2 < 500) {print $0,"-nband b1"} else if ($2 < 1000) {print $0,"-nband b2"} else if ($2 < 1500) {print $0,"-nband b3"} else if ($2 < 2000) {print $0,"-nband b4"} else if ($2 < 2500) {print $0,"-nband b5"} else if ($2 < 3000) {print $0,"-nband b6"} else if ($2 < 3500) {print $0,"-nband b7"} else {print $0,"-nband b8"}}' >> $bname
 end
 #
 # Average data
 #
 foreach tim (`ls recentNano*.sys_*.bands.tim`)
   set sys = `echo $tim | awk -F ".sys_" '{print $2}' | sed s/".bands.tim"/""/`
   set baseName = `echo $tim | sed s/".tim"/".av.tim"/`
   tempo2 -gr averageData -f {$psr}_recentNANO.par $tim -autoblock
   echo "FORMAT 1" > $baseName
   grep -v FORMAT avpts.tim | awk '{print $0,"-pta NANO -sys '$sys'"}' | awk '{if ($2 < 500) {print $0,"-nband b1"} else if ($2 < 1000) {print $0,"-nband b2"} else if ($2 < 1500) {print $0,"-nband b3"} else if ($2 < 2000) {print $0,"-nband b4"} else if ($2 < 2500) {print $0,"-nband b5"} else if ($2 < 3000) {print $0,"-nband b6"} else if ($2 < 3500) {print $0,"-nband b7"} else {print $0,"-nband b8"}}' >> $baseName
 end
#
# Run EFAC/EQUAD plugin
#
 rm recentNano.efacEquad.dat
 touch recentNano.efacEquad.dat
 foreach tim (`ls recentNano*.bands.av.tim`)
    # Note multiplication by 2 for Rcvr1_2_GUPPI
    # factor of 500 in stepEquad to get small changes
   set largeError = `sort -k4g $tim | awk '{print $4*2}' | tail -1`
   set stepEquad = `echo $largeError | awk '{print $1/500.0}'`
   echo $largeError
    if ($tim =~ "recentNano.ao.sys_ao.ASP.430.bands.av.tim" && $psr =~ "J2317+1439") then
        # This set has a large gap meaning the plugin fails. Calculated by hand
	# over a smaller region
	echo "T2EFAC -sys ao.ASP.430 1.8" > efacEquad_output.dat
    else if ($tim =~ "recentNano.ao.sys_ao.ASP.327.bands.av.tim" && $psr =~ "J2317+1439") then
        # This set has a large gap meaning the plugin fails. Calculated by hand
	# over a smaller region
	echo "T2EFAC -sys ao.ASP.430 1.9" > efacEquad_output.dat
     else	
      tempo2 -gr efacEquad -plot -f {$psr}_recentNano.par $tim -nofit -fit f0 -fit f1 -flag -sys -maxEquad $largeError -stepEquad $stepEquad
     endif
   cat efacEquad_output.dat >> recentNano.efacEquad.dat
 end

 cat {$psr}_recentNano.par recentNano.efacEquad.dat > {$psr}_recentNano_wEfac_Equad.par


 #
 # Inspect the data
 #   
 foreach tim (`ls recentNano*.sys_*.bands.av.tim`)
  tempo2 -gr plk -f {$psr}_recentNANO_wEfac_Equad.par $tim -nofit
 end
    
# End check NANOGrav data processing
endif


step5:
cd ../tempFiles/
#
# Process each band
#

cat recentNano*.sys_*.bands.av.tim epta*.sys_*.bands.tim ppta*.sys_*.bands.tim earlyNano*.sys_*.bands.tim > {$psr}.all.tim
    
set parFileName = `grep $psr $SCRIPT_DIR/inputParFiles | awk '{print $2}'`    
cat $SCRIPT_DIR/../$parFileName | grep -v START | grep -v FINISH | grep -v FD | grep -v JUMP | grep -v EFAC | grep -v EQUAD | grep -v DM2 | awk '{if ($1 == "DMOFF") {print $1,$2,$3} else if ($1 == "DMMODEL") {print "DMMODEL DM 0"} else {print $1,$2}}' > {$psr}.all.par

grep T2E {$psr}_epta_wEfac_Equad.par >> {$psr}.all.par
grep T2E {$psr}_ppta_wEfac_Equad.par >> {$psr}.all.par
grep T2E {$psr}_recentNano_wEfac_Equad.par >> {$psr}.all.par
grep T2E {$psr}_earlyNano_wEfac_Equad.par >> {$psr}.all.par

# Extract the different systems and determine their data spans
rm sys.dat
touch sys.dat
foreach sys (`awk -F "-sys " '{print $2}' $psr.all.tim | awk '{print $1}' | sort | uniq`)
  set npts = `grep "\-sys $sys " $psr.all.tim | wc -l | tail -1 | awk '{print $1}'`
  set start = `grep "\-sys $sys " $psr.all.tim | sort -k3g | head -1 | awk '{print $3}'`
  set finish = `grep "\-sys $sys " $psr.all.tim | sort -k3g | tail -1 | awk '{print $3}'`
  set span = `echo $start $finish | awk '{print $2-$1}'`   
  echo $sys $npts  $start $finish $span >> sys.dat
end    

if ($psr =~ "J1730-2304") then
  cp $SCRIPT_DIR/$psr.sysList sys.dat
else if ($psr =~ "J2124-3358") then
  cp $SCRIPT_DIR/$psr.sysList sys.dat
endif    
# Process in order of data span for a single system
set nline = `wc -l sys.dat | tail -1 | awk '{print $1}'`
grep -v START $psr.all.par | grep -v FINISH > $psr.final.par
foreach lc (`seq 2 $nline`)    
 grep -v START $psr.final.par | grep -v FINISH > $psr.jumps.par
    
 set select = `sort -k5gr sys.dat | head -$lc | awk '{printf(" %s",$1)}'`
 set last = `sort -k5gr sys.dat | head -$lc | tail -1 | awk '{print $1}'`
 set lastMJD1 = `sort -k5gr sys.dat | head -$lc | tail -1 | awk '{print $3}'`
 set lastMJD2 = `sort -k5gr sys.dat | head -$lc | tail -1 | awk '{print $4}'`    
 echo "JUMP -sys $last 0 1" >> $psr.jumps.par
 echo "select command is $select"   
 tempo2 -gr plk -f $psr.jumps.par $psr.all.tim -pass "-sys $select" -set f2 0 -set f3 0 -fit f0 -fit f1
 set jval = `grep "JUMP -sys $last " $psr.jumps.par | awk '{print $4}'`
 echo "JUMP -sys $last $jval" >> $psr.final.par 
end


step6:
cd ../tempFiles
# DM Correction
# Note that some pulsars already have DM steps from the PPTA Reardon et al. data. Other pulsars do not.
# Here we process each pulsar individually
#
# PSR J1857+0943
if ($psr =~ "J1857+0943") then
 tempo2 -newpar -f $psr.final.par $psr.all.tim -fit f0 -fit f1 -fit dm -fit dm1
 \mv new.par $psr.final_dmcorr.par
else if ($psr =~ "J1911-1114" || $psr =~ "J1911+1347" || $psr =~ "J2322+2057" || $psr =~ "J1751-2857" || $psr =~ "J1738+0333" || $psr =~ "J2033+1734" || $psr =~ "J2019+2425" || $psr =~ "J1804-2717" || $psr =~ "J1801-1417" || $psr =~ "J1843-1113" || $psr =~ "J0610-2100" || $psr =~ "J1721-2457" || $psr =~ "J1853+1303" || $psr =~ "J1910+1256" || $psr =~ "J1918-0642" || $psr =~ "J1955+2908" || $psr =~ "J1455-3330") then
    # Only one frequency band. 
 tempo2 -newpar -f $psr.final.par $psr.all.tim -fit f0 -fit f1
 \mv new.par $psr.final_dmcorr.par    
else if ($psr =~ "J2229+2643" || $psr =~ "J0900-3144" || $psr =~ "J1802-2124" || $psr =~ "J2010-1323" || $psr =~ "J0034-0534" || $psr =~ "J0218+4232" || $psr =~ "J0621+1002" || $psr =~ "J0751+1807" || $psr =~ "J0030+0451" || $psr =~ "J1640+2224" || $psr =~ "J1643-1224" || $psr =~ "J1022+1001" || $psr =~ "J1024-0719") then
# Only closely spaced bands
 tempo2 -newpar -f $psr.final.par $psr.all.tim -fit f0 -fit f1 -fit dm -fit dm1
 \mv new.par $psr.final_dmcorr.par    
    else if ($psr =~ "J1744-1134" || $psr =~ "J1600-3053" || $psr =~ "J1909-3744" || $psr =~ "J1713+0747" || $psr =~ "J2317+1439" || $psr =~ "J2124-3358" || $psr =~ "J2145-0750" || $psr =~ "J1012+5307" || $psr =~ "J1730-2304" || $psr =~ "J0613-0200") then
 tempo2 -newpar -f $psr.final.par $psr.all.tim -fit f0 -fit f1 -fit dm -fit dm1
 grep -v DMOFF new.par | grep -v CONSTRAIN | grep -v DMMODEL > $psr.final_dmcorr.par
 if ($psr =~ "J1744-1134") then
    set startMJD = 53458
    set lastMJD = 56000
 else if ($psr =~ "J1600-3053") then
    set startMJD = 53430
    set lastMJD = 56000
 else if ($psr =~ "J1643-1224") then
    set startMJD = 53350
    set lastMJD = 56000
 else if ($psr =~ "J1012+5307") then
    set startMJD = 51880
    set lastMJD = 56000
 else if ($psr =~ "J0030+0451") then
    set startMJD = 53300
    set lastMJD = 56000
 else if ($psr =~ "J0613-0200") then
    set startMJD = 52370
    set lastMJD = 56000
 else if ($psr =~ "J1730-2304") then
    set startMJD = 53450
    set lastMJD = 56000
 else if ($psr =~ "J2124-3358") then
    set startMJD = 53430
    set lastMJD = 56000
 else if ($psr =~ "J2317+1439") then
    set startMJD = 53350
    set lastMJD = 56000
 else if ($psr =~ "J2145-0750") then
    set startMJD = 53350
    set lastMJD = 56000
 else if ($psr =~ "J1713+0747") then
     set startMJD = 51400
     set lastMJD = 56000	
 else if ($psr =~ "J1909-3744") then
     set startMJD = 52600
     set lastMJD = 56000
 else
   echo "Not sure how many DM steps for this pulsar"
   exit
 endif
 # Add some DM steps after MJD 53458 and until 55912
  cp $psr.final_dmcorr.par $psr.addDMOFF.par
	
  echo "DMMODEL DM 1" >> $psr.addDMOFF.par
  if ($psr =~ "J1713+0747") then
   echo "DMOFF 49400 0" >> $psr.addDMOFF.par
  endif
  seq $startMJD 100 $lastMJD | awk '{print "DMOFF",$1,0}' >> $psr.addDMOFF.par
    echo "CONSTRAIN DMMODEL_DM1" >> $psr.addDMOFF.par
# Add band jumps
  rm bjumps.dat
  touch bjumps.dat
  foreach bjump (`awk -F "-nband " '{print $2}' $psr.all.tim | awk '{print $1}' | sort | uniq`)
   set npts = `grep "\-nband $bjump " $psr.all.tim | wc -l | tail -1 | awk '{print $1}'`
   set start = `grep "\-nband $bjump " $psr.all.tim | sort -k3g | head -1 | awk '{print $3}'`
   set finish = `grep "\-nband $bjump " $psr.all.tim | sort -k3g | tail -1 | awk '{print $3}'`
   set span = `echo $start $finish | awk '{print $2-$1}'`   
   echo $bjump $npts  $start $finish $span >> bjumps.dat
  end    

  set nline = `wc -l bjumps.dat | tail -1 | awk '{print $1}'`
  foreach lc (`seq 2 $nline`)    
   set last = `sort -k5gr bjumps.dat | head -$lc | tail -1 | awk '{print $1}'`
   echo "JUMP -nband $last 0 1" >> $psr.addDMOFF.par
  end    
  tempo2 -gr plk -f $psr.addDMOFF.par $psr.all.tim
  cat $psr.addDMOFF.par | sed s/"CONSTRAIN DMMODEL"/"CONSTRAIN DMMODEL_DM1"/ > $psr.final_dmcorr.par
 else
  echo "Pulsar not included in DM analysis"
  exit
 endif

#
# Remove low bands
# 
cd ../tempFiles
sort -k3n $psr.all.tim > $psr.sort.tim    
grep -v "\-nband b1" $psr.sort.tim | grep -v "\nband b2" > $psr.use.tim    
# Remove relevant jumps
cp $psr.final_dmcorr.par $psr.jumpRemoval.par
foreach sys (`grep "\-nband b1" $psr.sort.tim | awk -F "-sys" '{print $2}' | awk '{print $1}' | sort | uniq`)
 grep -v "JUMP \-sys $sys " $psr.jumpRemoval.par > tt
 mv tt $psr.jumpRemoval.par   
end
foreach sys (`grep "\-nband b2" $psr.sort.tim | awk -F "-sys" '{print $2}' | awk '{print $1}' | sort | uniq`)
 grep -v "JUMP \-sys $sys " $psr.jumpRemoval.par > tt
 mv tt $psr.jumpRemoval.par   
end

# Turn off DM and JUMP fitting    
awk '{if ($1 == "JUMP") {print $1,$2,$3,$4,0} else if ($1 == "DM" || $1 == "DM1" || $1 == "DMMODEL") {print $1,$2,0} else {print $0}}' $psr.jumpRemoval.par > $psr.use.par

  tempo2 -gr plk -f $psr.use.par $psr.use.tim -fit f0 -fit f1

#
# Spectral modelling
#
step7:
cd ../tempFiles

if ($psr =~ "J1744-1134" || $psr =~ "J1600-3053" || $psr =~ "J2317+1439" || $psr =~ "J1857+0943" || $psr =~ "J1909-3744" || $psr =~ "J1713+0747" || $psr =~ "J1751-2857" || $psr =~ "J1738+0333" || $psr =~ "J1911-1114" || $psr =~ "J1911+1347" || $psr =~ "J2322+2057" || $psr =~ "J2229+2643" || $psr =~ "J2033+1734" || $psr =~ "J2019+2425" || $psr =~ "J2010-1323" || $psr =~ "J1804-2717" || $psr =~ "J1802-2124" || $psr =~ "J1801-1417" || $psr =~ "J1843-1113"|| $psr =~ "J0900-3144" || $psr =~ "J0610-2100" || $psr =~ "J0034-0534" || $psr =~ "J1721-2457" || $psr =~ "J0218+4232" || $psr =~ "J0621+1002" || $psr =~ "J0751+1807" || $psr =~ "J2145-0750" || $psr =~ "J2124-3358" || $psr =~ "J0030+0451" || $psr =~ "J1730-2304" || $psr =~ "J0613-0200" || $psr =~ "J1012+5307" || $psr =~ "J1640+2224" || $psr =~ "J1853+1303" || $psr =~ "J1910+1256" || $psr =~ "J1918-0642" || $psr =~ "J1955+2908" || $psr =~ "J1455-3330" || $psr =~ "J1643-1224" || $psr =~ "J1022+1001" || $psr =~ "J1024-0719") then
 echo "Processing red noise over entire data span"
else
 echo "Not sure how much red noise to process"
 exit
endif

tempo2 -gr spectralModel -f $psr.use.par $psr.use.tim -nofit -fit f0 -fit f1
echo "Repeat process (n = no, y = repeat, i = iterate using new model)"
set next = $<
if ($next =~ "y") then
 goto step7
endif
step8:
if ($next =~ "i") then
 tempo2 -gr spectralModel -f $psr.use.par $psr.use.tim -nofit -fit f0 -fit f1 -dcf $psr.model
 echo "Repeat process (n = no, y = repeat, i = iterate using new model)"
 set next = $<
 if ($next =~ "y") then
  goto step7
 else
  goto step8
 endif
endif
    
#
# Tidy up
#
step9:
cd ../tempFiles    
#
# Last fit with noise model and jumps
#
awk '{if ($1 == "JUMP" && $2 == "-sys") {print $1,$2,$3,$4,1} else {print $0}}' $psr.use.par > $psr.finalFit.par

tempo2 -gr plk -f $psr.finalFit.par $psr.use.tim -dcf $psr.model

cp $psr.finalFit.par ../finalFrequentistData/$psr.par
cp $psr.use.tim ../finalFrequentistData/$psr.tim
    
if ($psr =~ "J0437-4715" || $psr =~ "J1045-4509" || $psr =~ "J1603-7202") then
  echo "PSR $psr" > ../finalFrequentistData/$psr.modelT2
  cat $psr.model >> ../finalFrequentistData/$psr.modelT2
else
 cp $psr.model ../finalFrequentistData/.    
 echo "PSR $psr" > ../finalFrequentistData/$psr.modelT2
 set alpha = `grep ALPHA $psr.model | awk '{print $2}'`
 set fc = `grep FC $psr.model | awk '{print $2}'`
 set amp = `grep AMP $psr.model | awk '{print $2}'`

 echo "MODEL T2PowerLaw $alpha $amp $fc" >> ../finalFrequentistData/$psr.modelT2
 # Add extra DM covariance
 if ($psr =~ "J1857+0943" || $psr =~ "J1744-1134" || $psr =~ "J1600-3053" || $psr =~ "J2317+1439" || $psr =~ "J1909-3744" || $psr =~ "J1713+0747" || $psr =~ "J0711-6830" || $psr =~ "J1911-1114" || $psr =~ "J1751-2857" || $psr =~ "J1738+0333" || $psr =~ "J1911+1347" || $psr =~ "J2322+2057" || $psr =~ "J2229+2643" || $psr =~ "J2033+1734" || $psr =~ "J2019+2425" || $psr =~ "J2010-1323" || $psr =~ "J1804-2717" || $psr =~ "J1802-2124" || $psr =~ "J1801-1417" || $psr =~ "J1843-1113" || $psr =~ "J0900-3144" || $psr =~ "J0610-2100" || $psr =~ "J0034-0534"  || $psr =~ "J0218+4232" || $psr =~ "J0621+1002" || $psr =~ "J0751+1807" || $psr =~ "J1721-2457" || $psr =~ "J1732-5049" || $psr =~ "J1824-2452A" || $psr =~ "J2129-5721" || $psr =~ "J2124-3358" || $psr =~ "J2145-0750" || $psr =~ "J1730-2304" || $psr =~ "J0613-0200" || $psr =~ "J0030+0451" || $psr =~ "J1012+5307" || $psr =~ "J1640+2224" || $psr =~ "J1853+1303" || $psr =~ "J1910+1256" || $psr =~ "J1918-0642" || $psr =~ "J1955+2908" || $psr =~ "J1455-3330" || $psr =~ "J1643-1224" || $psr =~ "J1022+1001" || $psr =~ "J1024-0719") then
  echo "No extra DM variations added"
    
 else
  echo "Pulsar not found for DM covariance"
  exit
 endif
endif

echo "MODEL T2" > ../finalFrequentistData/noise.models	    
foreach file (`ls ../finalFrequentistData/*.modelT2`)
 cat $file >> ../finalFrequentistData/noise.models
 echo "" >> ../finalFrequentistData/noise.models
 echo "CLEAR" >> ../finalFrequentistData/noise.models
end    
cp $psr.log ../finalFrequentistData/.
    
echo "All done!"



echo "Please clear the working directory before starting another pulsar"
    
