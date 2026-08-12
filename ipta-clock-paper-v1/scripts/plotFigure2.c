#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <cpgplot.h>

void slaClyd ( int iy, int im, int id, int *ny, int *nd, int *jstat );
void slaCalyd ( int iy, int im, int id, int *ny, int *nd, int *j );
double mjd2year(long double mjd);

// gcc -lm -o plotFigure2 plotFigure2.c -I/opt/build_psrsoft/workspace/psr-pgplot-build/pgplot_build/ -L/opt/build_psrsoft/workspace/psr-pgplot-build/pgplot_build/ -lcpgplot -lpgplot -lgfortran -lX11 -lpng

int main()
{
  int npsr=0;
  FILE *fin;
  float fx[15000],fy[15000];
  float expectedTAI_x[15000],expectedTAI_y[15000];
  int nExpectedTAI=0;
  float expectedTAIx2_x[15000],expectedTAIx2_y[15000];
  int nExpectedTAIx2=0;
  
  float err;
  float yerr1[15000],yerr2[15000];
  float dummy;
  int npts=0;
  char str[1024];
  int i,j;
  double expected;
  int col=1;
  long double mjd;
  
  // Load the expected data sets
  fin = fopen("dataForFigure2/plotvals.taip3.2.dat","r");
  //  fin = fopen("dataForFigure2/expected_tai.dat","r");
  nExpectedTAIx2=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%s %f %f %f",str,&expectedTAIx2_x[nExpectedTAIx2],&dummy,&expectedTAIx2_y[nExpectedTAIx2])==4)
	{
	  //	  expectedTAIx2_y[nExpectedTAIx2]*=-2;
	  expectedTAIx2_y[nExpectedTAIx2]*=0.5;
	  nExpectedTAIx2++;
	}      
    }
  fclose(fin);

  fin = fopen("dataForFigure2/expected_tai.2.dat","r");
  nExpectedTAI=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%s %f %f %f",str,&expectedTAI_x[nExpectedTAI],&dummy,&expectedTAI_y[nExpectedTAI])==4)
	{
	  expectedTAI_y[npts]*=-1;
	  nExpectedTAI++;
	}      
    }
  fclose(fin);


  
  cpgbeg(0,"/cps",1,1);
  cpgsch(1.2);
  cpgscf(2);
  cpgslw(2);

  cpgsvp(0.08,0.38,0.09,0.36);
  cpgswin(1993,2013,0,0.9);
  cpgbox("BCTSN",0,0,"ABCTSN",0,0);
  cpglab("\\uYear","1s Error bar (\\gms)","");
  fin = fopen("dataForFigure2/tai_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts],&dummy)==5)    
	{
	  // NOTE NOTHING BEING REVERSED HERE!
	  fy[npts] = (yerr1[npts]-yerr2[npts])/2.0;
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);
  fin = fopen("dataForFigure2/tai_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]=err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgpt(npts,fx,fy,4);
  
  cpgsvp(0.38,0.68,0.09,0.36);
  cpgswin(1993,2013,0,0.9);
  cpgbox("BCTSN",0,0,"ABCTS",0,0);
  cpglab("\\uYear","","");

  fin = fopen("dataForFigure2/bipmx2_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts],&dummy)==5)    
	{
	  // NOTE NOTHING BEING REVERSED HERE!
	  fy[npts] = (yerr1[npts]-yerr2[npts])/2.0;
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);
  //
  fin = fopen("dataForFigure2/bipmx3_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]=err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgpt(npts,fx,fy,4);

  
  
  cpgsvp(0.68,0.98,0.09,0.36);
  cpgswin(1993,2013,0,0.9);
  cpgbox("BCTSN",0,0,"ABCTS",0,0);
  cpglab("\\uYear","","");

  fin = fopen("dataForFigure2/bipm_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts])==4)    
	{
	  // NOTE NOTHING BEING REVERSED HERE!
	  fy[npts] = (yerr1[npts]-yerr2[npts])/2.0;
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);

  fin = fopen("dataForFigure2/bipm_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]=err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgpt(npts,fx,fy,4);

  //
  cpgsvp(0.08,0.38,0.36,0.63);
  cpgswin(1993,2013,-0.9,0.9);
  cpgbox("BCTS",0,0,"ABCTSN",0,0);
  cpglab("","Residual (\\gms)","");
  fx[0] = 1992; fx[1] = 2015;
  fy[0] = fy[1] = 0.0;
  cpgsci(2); cpgline(2,fx,fy); cpgsci(1);

  
  fin = fopen("dataForFigure2/tai_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts],&dummy)==5)    
	{
	  // NOTE NOTHING BEING REVERSED HERE!
	  for (j=0;j<nExpectedTAI;j++)
	    {
	      if (fx[npts] < expectedTAI_x[j])
		{
		  expected = expectedTAI_y[j];
		  break;
		}
	    }
	  fy[npts] -= expected;
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);

  fin = fopen("dataForFigure2/tai_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]*=1e6;
	  for (j=0;j<nExpectedTAI;j++)
	    {
	      if (fx[npts] < expectedTAI_x[j])
		{
		  expected = expectedTAI_y[j];
		  break;
		}
	    }
	  fy[npts]-=expected;
	  yerr1[npts] = fy[npts]-err*1e6;
	  yerr2[npts] = fy[npts]+err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgerry(npts,fx,yerr1,yerr2,1);
  cpgpt(npts,fx,fy,4);

  
  
  cpgsvp(0.38,0.68,0.36,0.63);
  cpgswin(1993,2013,-0.9,0.9);
  cpgbox("BCTS",0,0,"ABCTS",0,0);
  fx[0] = 1992; fx[1] = 2015;
  fy[0] = fy[1] = 0.0;
  cpgsci(2); cpgline(2,fx,fy); cpgsci(1);
  fin = fopen("dataForFigure2/bipmx2_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts],&dummy)==5)    
	{
	  // NOTE NOTHING BEING REVERSED HERE!
	  for (j=0;j<nExpectedTAIx2;j++)
	    {
	      if (fx[npts] < expectedTAIx2_x[j])
		{
		  expected = expectedTAIx2_y[j];
		  break;
		}
	    }
	  fy[npts] = -expected-fy[npts]; // UPDATE
	  //	  fy[npts] = (yerr1[npts]-yerr2[npts])/2.0;
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);

  fin = fopen("dataForFigure2/bipmx3_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]*=1e6;
	  for (j=0;j<nExpectedTAIx2;j++)
	    {
	      if (fx[npts] < expectedTAIx2_x[j])
		{
		  expected = expectedTAIx2_y[j];
		  break;
		}
	    }
	  fy[npts] -= expected;
	  yerr1[npts] = fy[npts]-err*1e6;
	  yerr2[npts] = fy[npts]+err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgerry(npts,fx,yerr1,yerr2,1);
  cpgpt(npts,fx,fy,4);
  // panel 2/2
  fx[0] = 1992; fx[1] = 2015;
  fy[0] = fy[1] = 0.0;
  cpgsci(2); cpgline(2,fx,fy); cpgsci(1);


  
  
  cpgsvp(0.68,0.98,0.36,0.63);
  cpgswin(1993,2013,-0.9,0.9);
  cpgbox("BCTS",0,0,"ABCTS",0,0);

  // Overlay the Bayesian result
  fin = fopen("dataForFigure2/bipm_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts])==4)    
	{
	  fy[npts]=-fy[npts]; // REVERSING
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);

  fin = fopen("dataForFigure2/bipm_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]*=1e6;
	  yerr1[npts] = fy[npts]-err*1e6;
	  yerr2[npts] = fy[npts]+err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgerry(npts,fx,yerr1,yerr2,1);
  cpgpt(npts,fx,fy,4);
  fx[0] = 1992; fx[1] = 2015;
  fy[0] = fy[1] = 0.0;
  cpgsci(2); cpgline(2,fx,fy); cpgsci(1);

  //
  cpgsvp(0.08,0.38,0.63,0.91);
  cpgswin(1993,2013,-1.8,1.8);
  cpgbox("BCTS",0,0,"ABCTSN",0,0);
  cpglab("","Clock offset (\\gms)","\\dTT(TAI)");
  // TAI clock offset
  // Overlay the Bayesian result
  fin = fopen("dataForFigure2/tai_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts],&dummy)==5)    
	{
	  fy[npts] = fy[npts];
	  yerr1[npts] = yerr1[npts];
	  yerr2[npts] = yerr2[npts];
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);
  cpgsci(3); cpgline(npts,fx,yerr1); cpgsci(1);
  cpgsci(3); cpgline(npts,fx,yerr2); cpgsci(1);

  fin = fopen("dataForFigure2/tai_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]*=1e6;
	  yerr1[npts] = fy[npts]-err*1e6;
	  yerr2[npts] = fy[npts]+err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgerry(npts,fx,yerr1,yerr2,1);
  cpgpt(npts,fx,fy,4);

  cpgsci(2); cpgline(nExpectedTAI,expectedTAI_x,expectedTAI_y); cpgsci(1);
  
  cpgsvp(0.38,0.68,0.63,0.91);
  cpgswin(1993,2013,-1.8,1.8);
  cpgbox("BCTS",0,0,"ABCTS",0,0);
  cpglab("","","\\dTest signal");
  // Test-signal clock offset
  // Overlay the Bayesian result
  printf("BIPMX2_BAYESIAN\n");
  fin = fopen("dataForFigure2/bipmx2_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts],&dummy)==5)    
	{
	  fy[npts] = -fy[npts];
	  yerr1[npts] = -yerr1[npts];
	  yerr2[npts] = -yerr2[npts];
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);
  cpgsci(3); cpgline(npts,fx,yerr1); cpgsci(1);
  cpgsci(3); cpgline(npts,fx,yerr2); cpgsci(1);
  for (i=0;i<npts;i++)
    printf("OUTPUT3: %g %g %g %g\n",fx[i],fy[i],yerr1[i],yerr2[i]);

  fin = fopen("dataForFigure2/bipmx3_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]*=1e6;
	  yerr1[npts] = fy[npts]-err*1e6;
	  yerr2[npts] = fy[npts]+err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgerry(npts,fx,yerr1,yerr2,1);
  cpgpt(npts,fx,fy,4);
  for (i=0;i<npts;i++)
    {
      printf("OUTPUT1: %g %g %g\n",fx[i],fy[i],(yerr2[i]-yerr1[i])/2.0);
    }

  fx[0] = 1992; fx[1] = 2015;
  fy[0] = fy[1] = 0.0;
  cpgsci(2); cpgline(2,fx,fy); cpgsci(1);

  cpgsci(2); cpgline(nExpectedTAIx2,expectedTAIx2_x,expectedTAIx2_y); cpgsci(1);
  //  cpgsci(1); cpgsls(4); cpgline(npts,fx,yerr1); cpgsci(1); cpgsls(1);
  for (i=0;i<nExpectedTAIx2;i++)
    printf("OUTPUT2: %g %g\n",expectedTAIx2_x[i],expectedTAIx2_y[i]);
  
  
  cpgsvp(0.68,0.98,0.63,0.91);
  cpgswin(1993,2013,-1.8,1.8);
  cpgbox("BCTS",0,0,"ABCTS",0,0);
  cpglab("","","\\dTT(BIPM16)");
  // BIPM clock offset
  // Overlay the Bayesian result
  fin = fopen("dataForFigure2/bipm_bayesian.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&yerr1[npts],&yerr2[npts])==4)    
	{
	  fy[npts] = -fy[npts];
	  yerr1[npts] = -yerr1[npts];
	  yerr2[npts] = -yerr2[npts];
	  npts++;
	}      
    }
  fclose(fin);
  cpgsci(4); cpgline(npts,fx,fy); cpgsci(1);
  cpgsci(3); cpgline(npts,fx,yerr1); cpgsci(1);
  cpgsci(3); cpgline(npts,fx,yerr2); cpgsci(1);

  fin = fopen("dataForFigure2/bipm_frequentist.txt","r");
  npts=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&fx[npts],&fy[npts],&err,&dummy)==4)    
	{	  
	  fx[npts] = mjd2year(fx[npts]);
	  fy[npts]*=1e6;
	  yerr1[npts] = fy[npts]-err*1e6;
	  yerr2[npts] = fy[npts]+err*1e6;
	  npts++;
	}      
    }
  fclose(fin);
  cpgerry(npts,fx,yerr1,yerr2,1);
  cpgpt(npts,fx,fy,4);
  fx[0] = 1992; fx[1] = 2015;
  fy[0] = fy[1] = 0.0;
  cpgsci(2); cpgline(2,fx,fy); cpgsci(1);



  cpgend();
  

}


void slaCalyd ( int iy, int im, int id, int *ny, int *nd, int *j )
    /*
     **  - - - - - - - - -
     **   s l a C a l y d
     **  - - - - - - - - -
     **
     **  Gregorian calendar date to year and day in year (in a Julian
     **  calendar aligned to the 20th/21st century Gregorian calendar).
     **
     **  (Includes century default feature:  use slaClyd for years
     **   before 100AD.)
     **
     **  Given:
     **     iy,im,id   int    year, month, day in Gregorian calendar
     **                       (year may optionally omit the century)
     **  Returned:
     **     *ny        int    year (re-aligned Julian calendar)
     **     *nd        int    day in year (1 = January 1st)
     **     *j         int    status:
     **                         0 = OK
     **                         1 = bad year (before -4711)
     **                         2 = bad month
     **                         3 = bad day (but conversion performed)
     **
     **  Notes:
     **
     **  1  This routine exists to support the low-precision routines
     **     slaEarth, slaMoon and slaEcor.
     **
     **  2  Between 1900 March 1 and 2100 February 28 it returns answers
     **     which are consistent with the ordinary Gregorian calendar.
     **     Outside this range there will be a discrepancy which increases
     **     by one day for every non-leap century year.
     **
     **  3  Years in the range 50-99 are interpreted as 1950-1999, and
     **     years in the range 00-49 are interpreted as 2000-2049.
     **
     **  Called:  slaClyd
     **
     **  Last revision:   22 September 1995
     **
     **  Copyright P.T.Wallace.  All rights reserved.
     */
{
    int i;

    /* Default century if appropriate */
    if ( ( iy >= 0 ) && ( iy <= 49 ) )
        i = iy + 2000;
    else if ( ( iy >= 50 ) && ( iy <= 99 ) )
        i = iy + 1900;
    else
        i = iy;

    /* Perform the conversion */
    slaClyd ( i, im, id, ny, nd, j );
}

void slaClyd ( int iy, int im, int id, int *ny, int *nd, int *jstat )
    /*
     **
     **  Returned:
     **     ny          int    year (re-aligned Julian calendar)
     **     nd          int    day in year (1 = January 1st)
     **     jstat       int    status:
     **                          0 = OK
     **                          1 = bad year (before -4711)
     **                          2 = bad month
     **                          3 = bad day (but conversion performed)
     **
     **  Notes:
     **
     **  1  This routine exists to support the low-precision routines
     **     slaEarth, slaMoon and slaEcor.
     **
     **  2  Between 1900 March 1 and 2100 February 28 it returns answers
     **     which are consistent with the ordinary Gregorian calendar.
     **     Outside this range there will be a discrepancy which increases
     **     by one day for every non-leap century year.
     **
     **  3  The essence of the algorithm is first to express the Gregorian
     **     date as a Julian Day Number and then to convert this back to
     **     a Julian calendar date, with day-in-year instead of month and
     **     day.  See 12.92-1 and 12.95-1 in the reference.
     **
     **  Reference:  Explanatory Supplement to the Astronomical Almanac,
     **              ed P.K.Seidelmann, University Science Books (1992),
     **              p604-606.
     **
     **  Last revision:   26 November 1994
     **
     **  Copyright P.T.Wallace.  All rights reserved.
     */
{
    long i, j, k, l, n, iyL, imL;

    /* Month lengths in days */
    static int mtab[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };



    /* Validate year */
    if ( iy < -4711 ) { *jstat = 1; return; }

    /* Validate month */
    if ( ( im < 1 ) || ( im > 12 ) ) { *jstat = 2; return; }

    /* Allow for (Gregorian) leap year */
    mtab[1] = ( ( ( iy % 4 ) == 0 ) &&
            ( ( ( iy % 100 ) != 0 ) || ( ( iy % 400 ) == 0 ) ) ) ?
        29 : 28;

    /* Validate day */
    *jstat = ( id < 1 || id > mtab[im-1] ) ? 3 : 0;

    /* Perform the conversion */
    iyL = (long) iy;
    imL = (long) im;
    i = ( 14 - imL ) /12L;
    k = iyL - i;
    j = ( 1461L * ( k + 4800L ) ) / 4L
        + ( 367L * ( imL - 2L + 12L * i ) ) / 12L
        - ( 3L * ( ( k + 4900L ) / 100L ) ) / 4L + (long) id - 30660L;
    k = ( j - 1L ) / 1461L;
    l = j - 1461L * k;
    n = ( l - 1L ) / 365L - l / 1461L;
    j = ( ( 80L * ( l - 365L * n + 30L ) ) / 2447L ) / 11L;
    i = n + j;
    *nd = 59 + (int) ( l -365L * i + ( ( 4L - n ) / 4L ) * ( 1L - j ) );
    *ny = (int) ( 4L * k + i ) - 4716;
}

double mjd2year(long double mjd)
{
  double jd,fjd,day;
  int ijd,b,c,d,e,g,month,year;
  int retYr,retDay,stat;
  
  jd = mjd + 2400000.5;
  ijd = (int)(jd+0.5);
  fjd = (jd+0.5)-ijd;
  if (ijd > 2299160)
    {
      int a;
      a = (int)((ijd-1867216.25)/36524.25);
      b = ijd + 1 + a - (int)(a/4.0);
    }
  else
    b = ijd;
  
  c = b + 1524;
  d = (int)((c - 122.1)/365.25);
  e = (int)(365.25*d);
  g = (int)((c-e)/30.6001);
  day = c-e+fjd-(int)(30.6001*g);
  if (g<13.5)
    month = g-1;
  else
    month = g-13;
  if (month>2.5)
    year = d-4716;
  else
    year = d-4715;
  slaCalyd(year, month, (int)day, &retYr, &retDay, &stat);
  return (double)(retYr+(retDay+(day-(int)day))/365.25);
}
