# BFB - BoundedFromBelow
Mathematica package to check boundedness of general Higgs potentials.


# Publications
* [https://arxiv.org/abs/1802.07976](https://arxiv.org/abs/1802.07976)
* [DOI: 10.1140/epjc/s10052-018-5893-y](https://doi.org/10.1140/epjc/s10052-018-5893-y)
* [Thesis](http://www.teco.edu/~koepke/mastersthesis.pdf) ([alternative upload](https://www.dropbox.com/s/py3c28ilpisphwb/Mastersthesis.pdf?dl=0))


# Prerequisites
1) Mathematica

   BFB is a Mathematica package and was tested on Mathematica version 11. It should work for any recent version, however, older versions may not be supported due to the lack of constructs like associations.

2) Macaulay2

   For the calculation of resultants BFB currently needs a different computer algebra system called Macaulay2, which was designed especially for problems in algebraic geometry.
   You can get Macaulay2 from one of the following urls:
   
   http://www2.macaulay2.com/Macaulay2/
   
   https://faculty.math.illinois.edu/Macaulay2/
   
   https://github.com/Macaulay2/M2
   
   BFB was tested on version 1.6, however any more recent version should work, too.

3) Resultants (Macaulay2 package)

   Some distributions of Macaulay2 don't contain all optional packages.
   You can test for the package `Resultants` by calling the M2 interpreter and loading the package.
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
   
   https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.6/share/doc/Macaulay2/Resultants/html/
   
   **WARNING: Adjust the Macaulay2 version in this link according to the currently stable version!**
   
   You have to put the `Resultants.m2` file into the directory
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
   
   Make sure to call the Mathematica kernel from within Cygwin.


# Install
To install BFB download the whole repository as a .zip file or use
```bash
git clone https://github.com/image357/BoundedFromBelow.git
```
in your download directory of choice.
Before you can start using BFB, you have to modify the file `config.m` to point to the binary of Macaulay2.
If you have a system wide installation then Macaulay2 is probably in your PATH variable.
```
Macaulay2Binary = "M2";
```
If not use
```
Macaulay2Binary = "/<path to Macaulay2>/bin/M2";
```


# Usage
Once you have installed BFB you can simply load it into Mathematica via
```
Get["/<path to download directory>/BFB.m"];
```
To see the error log, capture stderr of your Mathematica kernel, i.e. in your terminal of choice type
```bash
mathematica
```
and run your notebooks as usual.

There are currently two top-level functions.
Arguments in brackets are optional.
## GetResultant
Calculates the resultant of a given system of homogeneous polynomials.

Syntax:
```
GetResultant[polynomials, variables, parameters, (options)]
```

## PositivityTest
Tests a given Higgs potential for postive (semi)definiteness on large field values.

Syntax:
```
PositivityTest[potential, variables, (parameters), (options)]
```

## Example Notebook
As a starting point you can have a look at `Test.nb`.  
Also, consider reading through the [open](https://github.com/image357/BoundedFromBelow/issues) and [closed](https://github.com/image357/BoundedFromBelow/issues?q=is%3Aissue+is%3Aclosed) issues for some useful examples and discussions.
