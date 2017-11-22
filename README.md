# BFB - BoundedFromBelow
Mathematica package to check boundedness of general Higgs potentials.


# Prerequisites
1) Mathematica

   BFB is a Mathematica package and was tested on Mathematica Version 11. It should work for any recent version, however, older version may not be supported due to the lack constructs like associations.

2) Macaulay2

   For the calculation or resultants BFB currently needs a different computer algebra system called Macaulay2, which was designed especially for problems in algebraic geometry.
   You can get Macaulay2 at one of the following urls
   
   http://www2.macaulay2.com/Macaulay2/
   
   https://faculty.math.illinois.edu/Macaulay2/
   
   https://github.com/Macaulay2/M2
   
   BFB was tested on version 1.6, however any more recent version should work, too.

3) Resultants (Macaulay2 package)

   Some distributions of Macaulay2 don't contain all optional package.
   You can test for the "Resultants" package by calling the M2 interpreter and loading the package.
   ```bash
   > M2
   Macaulay2, version 1.6
   with packages: ConwayPolynomials, Elimination, IntegralClosure, LLLBases,
                  PrimaryDecomposition, ReesAlgebra, TangentCone
   i1 : loadPackage "Resultants"
   o1 = Resultants
   o1 : Package
   i2 :
   ```
   
   If you don't have the package installed you can get it from
   
   https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.10/share/doc/Macaulay2/Resultants/html/
   
   You have to put the Resultants.m2 file into the directory
   ```
   share/Macaulay2
   ```
   of your Macaulay2 installation.
   If you have a system wide installation this can be one of the two directories
   ```
   /usr/share/Macaulay2
   /usr/local/share/Macaulay2
   ```
   
4) Cygwin (optional)

   BFB wasn't tested on Windows environments, however you might want to use a compatiblilty layer like Cygwin.
   You can get it from
   
   https://www.cygwin.com/
