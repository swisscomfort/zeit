#!/usr/bin/tcsh
#
# Make the clock signal leaving out one pulsar in turn
# This is used to determine which pulsars make the most positive contribution
# to the resulting clock signal
#
cd ../finalClock

    #foreach psr (`ls ../finalFrequentistData/*.par | sed s/"..\/finalFrequentistData\/"/""/g | sed s/".par"/""/g | grep -v J02 | grep -v J00`)
    #foreach psr (J1713+0747)
#foreach psr (J1909-3744)
    #foreach psr (J1744-1134)
    #foreach psr (J0711-6830)
    #    foreach psr (J1824-2452A)
    #foreach psr (J1600-3053)
foreach psr (`ls ../finalFrequentistData/*.par | sed s/"..\/finalFrequentistData\/"/""/g | sed s/".par"/""/g | grep -v J02 | grep -v J00 | grep -v J1713+0747 | grep -v J1909-3744 | grep -v J0437-4715 | grep -v J1744-1134 | grep -v J0711-6830 | grep -v J1824-2452A | grep -v J0613-0200 | grep -v J0610-2100 | grep -v J1600-3053 | grep -v J0621+1002 | grep -v J0751+1807 | grep -v J0900-3144 | grep -v J1012+5307 | grep -v J1022+1001 | grep -v J1024-0719 | grep -v J1045-4509 | grep -v J1455-3330 | grep -v J1603-7202 | grep -v J1640+2224 | grep -v J1643-1224 | grep -v J1721-2457 | grep -v J1730-2304 | grep -v J1732-5049 | grep -v J1738+0333 | grep -v J1738+0333 | grep -v J1751-2857 | grep -v J1801-1417 | grep -v J1802-2124 | grep -v J1804-2717 | grep -v J1843-1113 | grep -v J1853+1303 | grep -v J1857+0943 | grep -v J1910+1256 | grep -v J1911-1114`)
 echo $psr
 ls ../finalFrequentistData/*.par | grep -v J02 | grep -v J00 | grep -v $psr > parFiles
 sed s/".par"/".tim"/g parFiles > timFiles
 cp ../finalFrequentistData/noise.models .
 echo "SIFUNC 2 2" > global.par
 seq 49400 365.25 56000 | awk '{print "IFUNC"NR,$1,0,0}' >> global.par
 echo "CONSTRAIN IFUNC" >> global.par
 echo "CLK TT(BIPM2013)" >> global.par

 echo -n "tempo2 -gr clock -g bipm_minus$psr.ps/cps -global global.par -dcf noise.models -fit f0 -fit f1 -miny -1.5 -maxy 1.5 -nobs 5000 -npsr 50 " > runCmd    
 paste parFiles timFiles  | awk '{printf( "-f %s %s ",$1,$2)}' >> runCmd
 source runCmd |tee bipm_svd_minus$psr.output
 cp ifunc.dat ifunc.bipm_minus$psr.dat
end
    
