param numdec = 2;
param numvars = 3;
param L:= 31;
param M:= 31;
param numFactors:= 10000;
set fact:= 1..numFactors;
set var:= 1..numFactors+2;
var x {j in var};
var a {j in fact};
var ind {j in fact} binary ;


maximize profit: sum{j in fact} a[j];
subject to con1 {j in fact}: ind[j] ==> (a[j] = x[j]) else (a[j] = x[j+1] + x[j+2]);
subject to con2 {j in fact}: x[j+1] + x[j+2] <= x[j] + M*(1-ind[j]);

subject to bounds {j in var}: 0 <= x[j] <= 10;