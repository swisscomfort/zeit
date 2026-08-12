#!/usr/bin/tcsh

\rm table1.tex
touch table1.tex
    
echo "\\begin{table}" >> table1.tex
echo "\\caption{Summary of the data used.}\\label{tb:summaryTable}" >> table1.tex
echo "\\begin{tabular}{p{1.3cm}lp{0.4cm}llp{1cm}}" >> table1.tex
echo "\\hline" >> table1.tex
echo "Pulsar & MJD range & Span & Frequency & Ntoa & Telescopes \\\\" >> table1.tex
echo " & & & range \\\\" >> table1.tex
echo "  &  & (yr) & (MHz) \\\\" >> table1.tex
echo "\\hline"     >> table1.tex

set c = 1
foreach psr (`ls ../finalFrequentistData/*.par | sed s/"..\/finalFrequentistData\/"/""/g | sed s/".par"/""/g`)
 set psrName = `echo $psr | sed s/"-"/'$-$'/g`
 echo -n $psrName "& " >> table1.tex
# Find start and end observation
 set startMJD = `grep -v "C " ../finalFrequentistData/$psr.tim | grep -v FORMAT | awk '{if (length($3) > 4) {printf("%.0f\n", $3)}}' | sort -k1g | head -1`
 set endMJD = `grep -v "C " ../finalFrequentistData/$psr.tim | grep -v FORMAT | awk '{if (length($3) > 4) {printf("%.0f\n", $3)}}' | sort -k1g | tail -1`
 echo -n $startMJD"--"$endMJD " & " >> table1.tex

# Find data span
 set span = `echo $startMJD $endMJD | awk '{printf("%.1f\n"),($2-$1)/365.25}'`
 echo -n $span " & " >> table1.tex

# Find frequency range (MHz)
 set lowFreq = `grep -v "C " ../finalFrequentistData/$psr.tim | grep -v FORMAT | awk '{if (length($2) > 4) {printf("%.0f\n", $2)}}' | sort -k1g | head -1`
 set highFreq = `grep -v "C " ../finalFrequentistData/$psr.tim | grep -v FORMAT | awk '{if (length($2) > 4) {printf("%.0f\n", $2)}}' | sort -k1g | tail -1`
 echo -n $lowFreq"--"$highFreq " & " >> table1.tex

# Get the number of ToAs
 set ntoa = `grep -v "C " ../finalFrequentistData/$psr.tim | grep -v FORMAT | awk '{if (length($3) > 10) {print $3}}' | wc -l | tail -1`
 echo -n $ntoa " & " >> table1.tex

# Determine which telescopes were used
 set telList = "" 

## Check Arecibo
 foreach tel (`grep -v "C " ../finalFrequentistData/$psr.tim | grep -v FORMAT | awk '{print $5}' | sort | uniq`)
   if ($tel =~ "PKS") then
    set tel = "pks"
   else if ($tel =~ "8") then
    set tel = "jb" 
   else if ($tel =~ "f") then
    set tel = "ncy" 
   else if ($tel =~ "AO") then
    set tel = "ao" 
   endif	

   if ($tel =~ "ao") then
    set telList = `echo $telList "A"`
   else if ($tel =~ "eff") then
    set telList = `echo $telList "E"`
   else if ($tel =~ "gbt") then
    set telList = `echo $telList "G"`
   else if ($tel =~ "jb") then
    set telList = `echo $telList "J"`
   else if ($tel =~ "ncy") then
    set telList = `echo $telList "N"`
   else if ($tel =~ "wsrt") then
    set telList = `echo $telList "W"`
   else if ($tel =~ "pks") then
    set telList = `echo $telList "P"`
   else
	echo "Have $tel"
        echo "FIX THIS"
	exit
   endif
  end
  set telList = `echo $telList | sed s/" "/"\n"/g | sort | uniq | tr "\n" "," | awk '{print substr($0,1,length($0)-1)}'`
  echo $telList "\\\\" >> table1.tex
    
 set c = `echo $c | awk '{print $1+1}'`
 if ($c =~ "6") then
  set c = 1
  echo "\\\\" >> table1.tex
 endif
end
echo "\\hline" >> table1.tex    
echo "\\end{tabular}" >> table1.tex
echo "~\\\\" >> table1.tex
echo "Telescope codes: (A) Arecibo, (E) Effelsberg, (G) Green Bank, (J) Jodrell Bank, (N) Nancay, (P) Parkes and (W) Westerbork" >> table1.tex
echo "\\end{table}" >> table1.tex
	
