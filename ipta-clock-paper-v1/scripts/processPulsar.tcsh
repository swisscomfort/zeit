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
./runProcessScript.tcsh $psr | tee ../logFiles/$psr.log
