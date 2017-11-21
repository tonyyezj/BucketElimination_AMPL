param numdec = 2;
param numvars = 3;
param L:= 31;
param M:= 31;
param numFactors:= 1000;
set fact:= 1..numFactors;
set var:= 1..numFactors+1;
var x {j in var};
var a {j in fact};
var ind {j in fact} binary ;


maximize profit: sum{j in fact} a[j];
subject to con1 {j in fact}: ind[j] ==> (a[j] = x[j]) else (a[j] = x[j+1]);
subject to con2 {j in fact}: x[j+1] <= x[j] + M*(1-ind[j]);

subject to bounds {j in var}: -10 <= x[j] <= 10;