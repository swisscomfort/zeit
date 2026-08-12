#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <cpgplot.h>
#include "T2toolkit.h"
#include "TKfit.h"

void slaClyd ( int iy, int im, int id, int *ny, int *nd, int *jstat );
void slaCalyd ( int iy, int im, int id, int *ny, int *nd, int *j );
double mjd2year(long double mjd);
void processData(char *fname_ifunc,char *fname_bayesian,char *fname_expected);
void fitQuadratic(float *x,float *y,float *e, int n,double *param,double *paramE);
void fitQuad(double x,double *v,int m);

int main()
{

  cpgbeg(0,"/cps",1,1);
  cpgsch(1.2);
  cpgscf(2);
  cpgslw(2);

  processData("dataForFigure2/bipmx3_frequentist.txt","dataForFigure2/bipmx2_bayesian.txt","dataForFigure2/plotvals.taip3.2.dat");

  cpgend();
  
  

}

void processData(char *fname_ifunc,char *fname_bayesian,char *fname_expected)
{
  int i,j;
  FILE *fin;

  float temp;
  char strtemp[128];
  //
  // Frequentist-ifuncs
  //
  float ifuncT[1024],ifuncV[1024],ifuncE[1024],ifuncV_quadRemoved[1024];
  float ifuncV_quadRemoved_y1[1024],ifuncV_quadRemoved_y2[1024];
  int nIfunc=0;
  double ifuncQuadVals[4],ifuncQuadErrs[4];
  
  //
  // Bayesian
  //
  float bayesianT[15000],bayesianV[15000],bayesianV1[15000],bayesianV2[15000];
  float bayesianV_quadRemoved[15000],bayesianV1_quadRemoved[15000],bayesianV2_quadRemoved[15000];
  float bayesianCloseT[1024],bayesianCloseV[1024],bayesianCloseE[1024];
  int nBayesian;
  int nBayesianClose;
  double bayesianQuadVals[4],bayesianQuadErrs[4];

  //
  // Expected signal
  //
  float expectedT[15000],expectedV[15000],expectedV_quadRemoved[15000];
  float expectedCloseT[1024],expectedCloseV[1024],expectedCloseE[1024];
  int nExpected;
  int nExpectedClose;
  double expectedQuadVals[4],expectedQuadErrs[4];

  //
  // FREQUENTIST DATA LOADING
  //
  fin = fopen(fname_ifunc,"r");
  nIfunc=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f",&ifuncT[nIfunc],
		 &ifuncV[nIfunc],&ifuncE[nIfunc],&temp)==4)
	{
	  ifuncT[nIfunc] = mjd2year(ifuncT[nIfunc]);
	  ifuncV[nIfunc] *= 1e6;
	  ifuncE[nIfunc] *= 1e6;
	  printf("Have %g %g\n",ifuncT[nIfunc],ifuncV[nIfunc]);
	  nIfunc++;
	}
    }
  fclose(fin);

  // Fit and remove a quadratic curve
  fitQuadratic(ifuncT,ifuncV,ifuncE,nIfunc-1,ifuncQuadVals,ifuncQuadErrs);
  for (i=0;i<nIfunc;i++)
    {
      ifuncV_quadRemoved[i] = ifuncV[i] - (ifuncQuadVals[0] + ifuncQuadVals[1]*(ifuncT[i]-2004) + ifuncQuadVals[2]*pow(ifuncT[i]-2004,2));
      ifuncV_quadRemoved_y1[i] = ifuncV_quadRemoved[i]-ifuncE[i];
      ifuncV_quadRemoved_y2[i] = ifuncV_quadRemoved[i]+ifuncE[i];
    }

  //
  // Expected data loading
  //
  fin = fopen(fname_expected,"r");
  nExpected=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%s %f %f %f",strtemp,&expectedT[nExpected],
		 &temp,&expectedV[nExpected])==4)
	nExpected++;
    }
  fclose(fin);
  // Get the expected points at the sampling of the IFUNCs
  nExpectedClose=0;

  j=0;
  for (i=0;i<nExpected;i++)
    {
      if (expectedT[i] > ifuncT[j])
	{
	  expectedCloseT[nExpectedClose] = expectedT[i];
	  expectedCloseV[nExpectedClose] = expectedV[i];
	  expectedCloseE[nExpectedClose] = ifuncE[j];
	  nExpectedClose++;
	  j++;
	  if (j == nIfunc) break;
	}
    }
  
  // Fit and remove a quadratic curve
  fitQuadratic(expectedCloseT,expectedCloseV,expectedCloseE,nExpectedClose-1,expectedQuadVals,expectedQuadErrs);
  for (i=0;i<nExpected;i++)
    {
      expectedV_quadRemoved[i] = expectedV[i] - (expectedQuadVals[0] + expectedQuadVals[1]*(expectedT[i]-2004) + expectedQuadVals[2]*pow(expectedT[i]-2004,2));
    }

  //
  // BAYESIAN data loading
  //
  fin = fopen(fname_bayesian,"r");
  nBayesian=0;
  while (!feof(fin))
    {
      if (fscanf(fin,"%f %f %f %f %f",&bayesianT[nBayesian],
		 &bayesianV[nBayesian],&bayesianV1[nBayesian],
		 &bayesianV2[nBayesian],&temp)==5)
	{
	  bayesianV[nBayesian]*=-1;
	  bayesianV1[nBayesian]*=-1;
	  bayesianV2[nBayesian]*=-1;
	  nBayesian++;
	}
    }
  fclose(fin);

  // Get the expected points at the sampling of the IFUNCs
  nBayesianClose=0;

  j=0;
  for (i=0;i<nBayesian;i++)
    {
      if (bayesianT[i] > ifuncT[j])
	{
	  bayesianCloseT[nBayesianClose] = bayesianT[i];
	  bayesianCloseV[nBayesianClose] = bayesianV[i];
	  bayesianCloseE[nBayesianClose] = ifuncE[j];
	  printf("Have fit fit  %g %g %g\n",bayesianCloseT[nBayesianClose],
		 bayesianCloseV[nBayesianClose],bayesianCloseE[nBayesianClose]);
	  nBayesianClose++;
	  j++;
	  if (j == nIfunc) break;
	}
    }
  if (j != nIfunc) {
    bayesianCloseT[nBayesianClose] = bayesianT[nBayesian-1];
    bayesianCloseV[nBayesianClose] = bayesianV[nBayesian-1];
    bayesianCloseE[nBayesianClose] = ifuncE[nIfunc-1];
	  printf("Have fit fit  %g %g %g\n",bayesianCloseT[nBayesianClose],
		 bayesianCloseV[nBayesianClose],bayesianCloseE[nBayesianClose]);

    nBayesianClose++;
  }
  // Fit and remove a quadratic curve
  fitQuadratic(bayesianCloseT,bayesianCloseV,bayesianCloseE,nBayesianClose-1,bayesianQuadVals,bayesianQuadErrs);
  for (i=0;i<nBayesian;i++)
    {
      //      bayesianV_quadRemoved[i] = bayesianV[i] - (bayesianQuadVals[0] + bayesianQuadVals[1]*(bayesianT[i]-2004) + bayesianQuadVals[2]*pow(bayesianT[i]-2004,2));
      bayesianV_quadRemoved[i] = bayesianV[i] - (bayesianQuadVals[0] + bayesianQuadVals[1]*(bayesianT[i]-2004) + bayesianQuadVals[2]*pow(bayesianT[i]-2004,2));
    }

  

  //
  // Do the plots
  //
  
  cpgsvp(0.08,0.38,0.63,0.91);
  cpgswin(1993,2013,-1.8,1.8);
  cpgbox("BCTS",0,0,"ABCTS",0,0);
  cpglab("","","");
  cpgerry(nIfunc,ifuncT,ifuncV_quadRemoved_y1,ifuncV_quadRemoved_y2,1);
  cpgpt(nIfunc,ifuncT,ifuncV_quadRemoved,4);
  //  cpgline(nExpected,expectedT,expectedV);
  cpgsci(2); cpgline(nExpected,expectedT,expectedV_quadRemoved); cpgsci(1);
  //  cpgline(nBayesian,bayesianT,bayesianV);
  cpgsci(3); cpgline(nBayesian,bayesianT,bayesianV_quadRemoved);
  //  cpgsci(4); cpgpt(nBayesianClose,bayesianCloseT,bayesianCloseV,2);
}

void fitQuadratic(float *x,float *y,float *e, int n,double *param,double *paramE)
{
  int i;
  double dx[n],dy[n],de[n];
  double **cvm;
  double chisq;

  cvm = (double **)(malloc(sizeof(double *)*3));
  for (i=0;i<3;i++)
    cvm[i] = (double *)malloc(sizeof(double)*3);
  
  for (i=0;i<n;i++)
    {
      dx[i] = (double)(x[i] - 2004);
      dy[i] = (double)(y[i]);
      de[i] = (double)(e[i]);
    }
  //  TKleastSquares_svd(dx,dy,de,n,param,paramE,3,cvm,&chisq,fitQuad,1);
  TKleastSquares_svd(dx,dy,de,n,param,paramE,3,cvm,&chisq,fitQuad,0);
  printf("Parameters are %g %g %g\n",param[0],param[1],param[2]);

  for (i=0;i<3;i++)
    free(cvm[i]);
  free(cvm);
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

void fitQuad(double x,double *v,int m)
{
  v[0] = 0;
  v[1] = x;
  v[2] = x*x;
}
