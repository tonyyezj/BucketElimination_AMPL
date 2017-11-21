param M:= 10000;

param numFactors:= 30;

set fact:= 1..numFactors ordered;

var t{i in fact};
var preference{i in fact};
var satisfied{i in fact} binary; #flag whether preference satisfied 
var flag {i in fact} integer;
var ind{i in fact} binary;
var ind2{i in fact} binary;

#random values
param coeff1 {i in fact}:= round(Uniform(5, 10));
param coeff2 {i in fact}:= round(Uniform(5, 10));
param coeff3 {i in fact}:= round(Uniform(5, 10));
param coeff4 {i in fact}:= round(Uniform(5, 10));


minimize value: sum{i in fact} (t[i] + preference[i]^2 );
#minimize value: sum{i in fact} (t[i] + pCon[i] * 1 + penalty[i]);
#minimize value: sum{i in fact} (t[i] + pCon[i] * 1);
#subject to prefCon1 {i in fact}: t[i] <= (i+1)*10 + (1-pCon[i])* M;
#subject to prefCon2 {i in fact}: t[i] + pCon[i]* M >= (i+1)*10;

# if ind[i], then t[i] =  (i*10, (i+1)*10)
# otherwise ind2[i] = true, then t[i] = ((i+2)*10, (i+3)*10)
#subject to con1 {i in fact}: ind[i] ==> (t[i] >= i*coeff1[i]) else (t[i] >= (i+2)*coeff2[i]);
#subject to con1b {i in fact}: ind[i] ==> (t[i] <= (i+1)*coeff3[i]) else (t[i] <= (i+3)*coeff4[i]);
#subject to con2 {i in fact}: ind2[i] ==> (t[i] >= (i+2)*coeff2[i]) else (t[i] >= (i+0)*coeff1[i]);
#subject to con2b {i in fact}: ind2[i] ==> (t[i] <= (i+3)*coeff4[i]) else (t[i] <= (i+1)*coeff3[i]);

# disjunctive constraint
subject to con1 {i in fact}: ind[i] ==> (t[i] >= i*10) else (t[i] >= (i+2)*10);
subject to con1b {i in fact}: ind[i] ==> (t[i] <= (i+1)*10) else (t[i] <= (i+3)*10);
subject to con2 {i in fact}: ind2[i] ==> (t[i] >= (i+2)*10) else (t[i] >= (i+0)*10);
subject to con2b {i in fact}: ind2[i] ==> (t[i] <= (i+3)*10) else (t[i] <= (i+1)*10);

#poststartGap
subject to postStart {i in 1..(numFactors - 1)}: t[i] + 10 <= t[i+1];

#preferenceConstraint
subject to pref1 {j in fact}: t[j] <= (j+1)*10 + M*(1-satisfied[j]); 
subject to pref2 {j in fact}: t[j] + satisfied[j]*M >= (j+1)*10 ;
subject to pref3 {j in 1 .. numFactors}: satisfied[j] ==> (preference[j] = t[j] - 10) else (preference[j] = 9 - t[j]);
#subject to prefa: preference[first(fact)] = 0;
#subject to prefb: preference[last(fact)] = 0;

#flag[j] = ind[j] XOR ind2[j]
# forces one of them to be satisfied
subject to con4a {j in fact}: flag[j] <= ind[j] + ind2[j];
subject to con4b {j in fact}: flag[j] >= ind[j];
subject to con4c {j in fact}: flag[j] >= ind2[j];
subject to con4z {j in fact}: flag[j] <= 2 - ind[j] - ind2[j];
subject to restrict01 {i in fact} : 1 <= flag[i] <= 1;

#subject to normalcons {i in fact} : 0 <= t[i] <= (last(fact) + 3) * 10 ;