from math import sqrt
def get_corr(x,y):
   if len(x)!=len(y):
       print "error: lengths of vectors don't match in get_corr"
   n = len(x)
   xSum = 0.0
   xxSum = 0.0
   ySum = 0.0
   yySum = 0.0
   xySum = 0.0
   for j in range(n):
      xVal = x[j]
      yVal = y[j]
      xSum +=  xVal;
      xxSum += xVal * xVal;
      ySum += yVal;
      yySum += yVal * yVal;
      xySum += xVal * yVal;
        
   cov = xySum - (xSum * ySum) / float(n);
   xVar = xxSum - (xSum * xSum) / float(n);
   yVar = yySum - (ySum * ySum) / float(n);
   den = sqrt(xVar*yVar);
   if den>0:
       return cov/den;
   else:
       return 0

print get_corr(range(5),range(5))
print get_corr(range(4),[0,3,2,5])
print get_corr(range(4),[3,2,1,0])
print get_corr(range(5),[6,7,8,9,10])

from rpy import *
print r.cor(range(4),[0,3,2,5])
