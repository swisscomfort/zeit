#!/usr/bin/tcsh

\rm table2.tex
touch table2.tex

set dl = \$
echo "\\begin{table*}" >> table2.tex
echo "\\caption{Parameters describing the DM model (columns 2 -- 8) and the red-noise model (last 3 columns) used for each pulsar.}\\label{tb:dmModel}" >> table2.tex
echo "\\begin{tabular}{lcccccccccr}" >> table2.tex
echo "\\hline" >> table2.tex
echo "Pulsar & DM"$dl"_0$dl & dDM/dt & Sine  & Cosine & Grid & a & b & "$dl"\\alpha$dl & P"$dl"_0"$dl" & f"$dl"_c"$dl" \\\\" >> table2.tex
echo " & (cm"$dl"^{-3}"$dl"pc) & (cm"$dl"^{-3}"$dl"pc\\,yr"$dl"^{-1}"$dl") & (cm"$dl"{-3}"$dl"pc) & (cm"$dl"^{-3}"$dl"pc) & ("$dl"\\Delta t_{\\rm DM}"$dl"\\,yr) & (s"$dl"^2"$dl") & (d) & & (yr"$dl"^3"$dl") & (yr"$dl"^{-1}"$dl") \\\\" >> table2.tex
echo "\\hline"     >> table2.tex
set c = 1
foreach psr (`ls ../finalFrequentistData/*.par | sed s/"..\/finalFrequentistData\/"/""/g | sed s/".par"/""/g`)
 set psrName = `echo $psr | sed s/"-"/'$-$'/g`
 echo -n $psrName "& " >> table2.tex
 set dm = `grep "DM" ../finalFrequentistData/$psr.par | grep -v DMEPOCH | grep -v S1YR | grep -v C1YR  | grep -v DMMODEL | grep -v DMOFF | grep -v DM1 | grep -v DM2 | awk '{printf("%.2f",$2)}'`
 echo -n $dm " & " >> table2.tex

# Get DM1
 set dm1 = `grep "DM1" ../finalFrequentistData/$psr.par | awk '{printf("%.1e", $2)}'`
 set t1 = `echo $dm1 | sed s/"e"/"\n"/ | head -1`
 set t2 = `echo $dm1 | sed s/"e"/"\n"/ | tail -1 | awk '{printf("%d",$1)}'`
 set dl = \$
 set lc = "{"
 set rc = "}"   



 set len = `echo $dm1 | wc -c`
 if ($len =~ "1") then
  echo -n " -- & " >> table2.tex 
 else
  echo -n "$dl$t1\\times 10^$lc$t2$rc$dl & " >> table2.tex
 endif
    
# Get S1YR
 set s1yr = `grep "S1YR" ../finalFrequentistData/$psr.par | awk '{printf("%.1e", $2)}'`
 set t1 = `echo $s1yr | sed s/"e"/"\n"/ | head -1`
 set t2 = `echo $s1yr | sed s/"e"/"\n"/ | tail -1 | awk '{printf("%d",$1)}'`
 set len = `echo $s1yr | wc -c`

 if ($len =~ "1") then
   echo -n " -- & " >> table2.tex 
 else    
  echo -n "$dl$t1\\times 10^$lc$t2$rc$dl & " >> table2.tex
 endif

# Get C1YR
 set c1yr = `grep "C1YR" ../finalFrequentistData/$psr.par | awk '{printf("%.1e", $2)}'`
 set t1 = `echo $c1yr | sed s/"e"/"\n"/ | head -1`
 set t2 = `echo $c1yr | sed s/"e"/"\n"/ | tail -1 | awk '{printf("%d",$1)}'`

 set len = `echo $c1yr | wc -c`
 if ($len =~ "1") then
   echo -n " -- & " >> table2.tex 
 else    
  echo -n "$dl$t1\\times 10^$lc$t2$rc$dl & " >> table2.tex
 endif

# Get DMOFF grid
 set dmgrid = `grep DMOFF ../finalFrequentistData/$psr.par | awk '{print $2}' | tail -2 | awk '{printf("%f ",$1)}' | awk '{printf("%.1f\n", ($2-$1)/365.25)}'`
 set wc = `echo $dmgrid | wc -c`
 if ($wc =~ "1") then
  echo -n " -- & " >> table2.tex
 else
  echo -n $dmgrid " & " >> table2.tex   
 endif

# DM covariance
 set dmcovarStr = `grep DMCovarParam ../finalFrequentistData/$psr.modelT2`
 set wc = `echo $dmcovarStr | wc -c`
 if ($wc =~ "1") then   
   echo -n " -- & -- & "  >> table2.tex
 else
   set res1 = `echo -n $dmcovarStr | awk '{print $4}'`
   set res2 = `echo -n $dmcovarStr | awk '{print $5}'`

   set t1 = `echo $res1 | sed s/"e"/"\n"/ | head -1`
   set t2 = `echo $res1 | sed s/"e"/"\n"/ | tail -1 | awk '{printf("%d",$1)}'`

   echo -n "$dl$t1\\times 10^$lc$t2$rc$dl & $res2 & " >> table2.tex
 endif

# T2 covariance
 set redCovarStr = `grep T2PowerLaw ../finalFrequentistData/$psr.modelT2`
 set wc = `echo $redCovarStr | wc -c`
 if ($wc =~ "1") then   
   echo -n " -- & -- & -- "  >> table2.tex
 else
   set res1 = `echo $redCovarStr | awk '{print $3}'`
   set res2 = `echo $redCovarStr | awk '{print $4}'`
   set res3 = `echo $redCovarStr | awk '{print $5}'`
   set t1 = `echo $res2 | sed s/"e"/"\n"/ | head -1`
   set t2 = `echo $res2 | sed s/"e"/"\n"/ | tail -1 | awk '{printf("%d",$1)}'`



    echo -n $res1 " & $dl$t1\\times 10^$lc$t2$rc$dl & " $res3 >> table2.tex
 endif
    
 echo "\\\\" >> table2.tex
    
 set c = `echo $c | awk '{print $1+1}'`
 if ($c =~ "6") then
  set c = 1
  echo "\\\\" >> table2.tex
 endif



end

echo "\\hline"     >> table2.tex
echo "\\end{tabular}" >> table2.tex
echo "\\end{table*}" >> table2.tex

    
