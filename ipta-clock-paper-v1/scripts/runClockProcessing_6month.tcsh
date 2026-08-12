#!/usr/bin/tcsh
#
# Make the clock signal
#
cd ../finalClock

#goto step2
    
ls ../finalFrequentistData/*.par > parFiles
sed s/".par"/".tim"/g parFiles > timFiles
cp ../finalFrequentistData/noise.models .
echo "SIFUNC 2 2" > global.par
seq 49400 182.625 56000 | awk '{print "IFUNC"NR,$1,0,0}' >> global.par
echo "CONSTRAIN IFUNC" >> global.par
    echo "CLK TT(BIPM2013)" >> global.par
    # -fit parameters set to make it run
echo -n "tempo2 -gr clock -g bipm_6month.ps/cps -global global.par -dcf noise.models -fit f0 -fit f1 -miny -1.5 -maxy 1.5 -nobs 5000 -npsr 50 " > runCmd    
paste parFiles timFiles  | awk '{printf( "-f %s %s ",$1,$2)}' >> runCmd
source runCmd |tee bipm_svd.output
cp ifunc.dat ifunc.bipm_6month.dat
exit

#
# TAI
#
step2:
echo "SIFUNC 2 2" > global.par
seq 49400 182.625 56000 | awk '{print "IFUNC"NR,$1,0,0}' >> global.par
echo "CONSTRAIN IFUNC" >> global.par
echo "CLK TT(TAI)" >> global.par    
echo -n "tempo2 -gr clock -g tai_6month.ps/cps -overlay tai2tt_bipm2016.clk -fit f0 -fit f1 -global global.par -dcf noise.models -miny -2 -maxy 2 -nobs 5000 -npsr 50 " > runCmd    
paste parFiles timFiles  | awk '{printf( "-f %s %s ",$1,$2)}' >> runCmd
source runCmd > tai_svd.output
cp ifunc.dat ifunc.tai_6month.dat


#
# BIPMx3
#
echo "SIFUNC 2 2" > global.par
seq 49400 182.625 56000 | awk '{print "IFUNC"NR,$1,0,0}' >> global.par
echo "CONSTRAIN IFUNC" >> global.par
echo "CLK TT(BIPMx3)" >> global.par    
echo -n "tempo2 -gr clock -g bipmx3_6month.ps/cps -overlay tai2tt_p3.clk -invert -fit f0 -fit f1 -global global.par -dcf noise.models -miny -2 -maxy 2 -nobs 5000 -npsr 50 " > runCmd    
paste parFiles timFiles  | awk '{printf( "-f %s %s ",$1,$2)}' >> runCmd
source runCmd > bipmx3_svd.output
cp ifunc.dat ifunc.bipmx3_6month.dat
    
