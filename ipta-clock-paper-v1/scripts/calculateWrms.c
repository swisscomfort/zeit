#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc,char *argv[])
{
  FILE *fin;
  int i,j;
  int n;
  double mjd[100],y[100],e[100];
  double wrms_early,rms_early,temp;
  double mean_early,wmean_early,wmean_late;
  double mean_late,rms_late,wrms_late;
  double weight,swi,wixi;
  double v1,v2;
  double improveEarly,improveLate,improveEarlyW,improveLateW;
  int n0=11;
  int nEarly;
  int nLate;
  double rms_early0,rms_late0,wrms_early0,wrms_late0;
  
  for (i=1;i<argc;i++)
    {
      n=0;
      fin = fopen(argv[i],"r");
      while (!feof(fin))
	{
	  if (fscanf(fin,"%lf %lf %lf %lf",&mjd[n],&y[n],&e[n],&temp)==4)
	    n++;
	}
      fclose(fin);
      mean_early=0;
      nEarly=0;
      wixi = swi = 0.0;
      for (j=0;j<n0;j++)
	{
	  mean_early+=y[j];
	  weight = 1.0/e[j]/e[j];
	  wixi += weight*y[j];
	  swi += weight;
	  nEarly++;
	}
      mean_early/=(double)nEarly;
      wmean_early = wixi/swi;
      
      v1=0;
      v2=0;
      for (j=0;j<n0;j++)
	{
	  v1+= pow(y[j]-mean_early,2);
	  weight = 1.0/e[j]/e[j];
	  v2+= pow(y[j]-wmean_early,2)*weight;
	}
      rms_early = sqrt(v1/(double)nEarly);
      wrms_early = sqrt(v2/swi);
      
      // Late times (since 2005)
      mean_late=0;
      nLate=0;
      wixi = swi = 0.0;
      for (j=n0;j<n;j++)
	{
	  mean_late+=y[j];
	  weight = 1.0/e[j]/e[j];
	  wixi += weight*y[j];
	  swi += weight;
	  nLate++;
	}
      mean_late/=(double)nLate;
      wmean_late = wixi/swi;
      v1=0;
      v2=0;
      for (j=n0;j<n;j++)
	{
	  v1+= pow(y[j]-mean_late,2);
	  weight = 1.0/e[j]/e[j];
	  v2+= pow(y[j]-wmean_late,2)*weight;
	}
      rms_late = sqrt(v1/(double)nLate);
      wrms_late = sqrt(v2/swi);
      if (i==1)
	{
	  rms_early0 = rms_early;
	  rms_late0  = rms_late;
	  wrms_early0 = wrms_early;
	  wrms_late0 = wrms_late;
	}

      improveEarly = (rms_early-rms_early0)/rms_early0;
      improveLate  = (rms_late-rms_late0)/rms_late0;
      improveEarlyW= (wrms_early-wrms_early0)/wrms_early0;
      improveLateW = (wrms_late-wrms_late0)/wrms_late0;
      
      printf("%s %g %g %g %g %g %g %g %g %g %g %g %g\n",argv[i],mean_early,rms_early,mean_late,rms_late,wmean_early,wrms_early,wmean_late,wrms_late,improveEarly,improveLate,improveEarlyW,improveLateW);
    }
}
  
