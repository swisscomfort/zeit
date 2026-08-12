#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <cpgplot.h>

// // gcc -lm -o plotFigure1 plotFigure1.c -I/opt/build_psrsoft/workspace/psr-pgplot-build/pgplot_build/ -L/opt/build_psrsoft/workspace/psr-pgplot-build/pgplot_build/ -lcpgplot -lpgplot -lgfortran -lX11 -lpng

void slaClyd ( int iy, int im, int id, int *ny, int *nd, int *jstat );
void slaCalyd ( int iy, int im, int id, int *ny, int *nd, int *j );
double mjd2year(long double mjd);


int main(int argc,char *argv[])
{
  int i,j;
  float fx[8192],fy[8192];
  double toa;
  FILE *fin;
  char fname[1024];
  int n=0;
  int c=1;
  char name[1024];
  
  cpgbeg(0,"figure1.ps/cps",1,1);
  cpgscf(2);
  cpgsch(1.4);
  cpgslw(2);

  

  //cpgenv(1991,2012.4,-1,50,0,-1);
  cpgsvp(0.03,0.95,0.13,0.95);
  cpgswin(1991,2012.4,-1,50);
  cpgbox("BCTSN",0,0,"BC",0,0);
  cpglab("Year","","");
  for (i=1;i<argc;i++)
    {
      sprintf(fname,argv[i]);
      sprintf(name,fname+15);
      if (name[10] == '.') name[10] = '\0';
      else name[11] = '\0';
      printf("File = %s\n",fname);
      n=0;
      fin = fopen(fname,"r");
      while (!feof(fin))
	{
	  if (fscanf(fin,"%lf",&toa)==1)
	    {
	      fx[n] = mjd2year(toa);
	      fy[n] = 49-i-0.5;
	      n++;
	    }
	}
      fclose(fin);
      if (c==1) cpgsci(1);
      else if (c==2) cpgsci(2);
      else if (c==3) cpgsci(4);
      cpgsch(1); cpgpt(n,fx,fy,20); cpgsch(1.4);
      cpgsch(0.7); cpgtext(1991.3,fy[0]-0.3,name); cpgsch(1.4);
      c++; if (c==4) c = 1;
    }
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
