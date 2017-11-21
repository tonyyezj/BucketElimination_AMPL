param M:= 21;

param numFactors:=10;

set fact:= 1..numFactors;
set var:= 1..numFactors+2;

var x {j in var};
var factorVal {j in fact};
var maxVal {j in fact};
var minVal {j in fact};
var ind {j in fact} binary ;
var ind2 {j in fact} binary ;
#var flag {j in fact} binary;
var flag {j in fact} integer;
var flagBinary {j in fact} binary; # indicator for whether flag is 0 or 1

maximize profit: sum{j in fact} (factorVal[j]);
subject to con1 {j in fact}: flagBinary[j] ==> (factorVal[j] = maxVal[j]) else (factorVal[j] = minVal[j]);
subject to con1b {j in fact}: ind[j] ==> (maxVal[j] = x[j] - x[j+1]) else (maxVal[j] = x[j+1] - x[j]);
subject to con1c {j in fact}: ind2[j] ==> (minVal[j] = x[j+2] - x[j+1]) else (minVal[j] = x[j+1] - x[j+2]);

subject to con2 {j in fact}: x[j+1] <= x[j] + M*(1-ind[j]); #ind[j] = 1 if x[j] >= x[j+1]
subject to con3 {j in fact}: x[j+2] <= x[j+1] + M*(1-ind2[j]); #ind2[j] = 1 if x[j+1] >= x[j+2]

#convert flag[j] (integer 0 1) to binary var, for use in the implication statement above.
subject to con4 {j in fact}: flagBinary[j] <= flag[j];
subject to con4g {j in fact}: flagBinary[j] >= flag[j];

#cast to XOR ind[j] xor ind2[j] = flag[j]
#https://cs.stackexchange.com/questions/12102/express-boolean-logic-operations-in-zero-one-integer-linear-programming-ilp
subject to con4a {j in fact}: flag[j] <= ind[j] + ind2[j];
subject to con4b {j in fact}: flag[j] >= ind[j] - ind2[j];
subject to con4c {j in fact}: flag[j] >= ind2[j] - ind[j];
subject to con4d {j in fact}: flag[j] <= 2 - ind[j] - ind2[j];

subject to bounds {j in var}: 0 <= x[j] <= 10;
subject to restrict01 {j in fact} : 0 <= flag[j] <= 1;