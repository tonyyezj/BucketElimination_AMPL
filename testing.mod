param numdec = 2;
param numvars = 3;
param L:= 31;
param M:= 31;
param numFactors:= 5;
set fact:= 1..numFactors;
set var:= 1..numFactors+2;
var x {j in var};
var a {j in fact};
var b {j in fact};
var ind {j in fact} binary ;
var ind2 {j in fact} binary ;


maximize profit: sum{j in fact} (a[j] + b[j]);
subject to con1a {j in fact}: ind[j] ==> (a[j] = x[j]) else (a[j] = x[j+1]);
subject to con1b {j in fact}: ind2[j] ==> (b[j] = x[j+1]) else (b[j] = x[j+2]);

subject to con2 {j in fact}: x[j+1] <= x[j] + M*(1-ind[j]);
subject to con3 {j in fact}: x[j+2] <= x[j+1] + M*(1-ind2[j]);

subject to bounds {j in var}: -10 <= x[j] <= 10;