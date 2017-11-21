param M:= 100000000;

param numFactors:= 7;

set fact:= 1..numFactors ordered;

var t{i in fact};
var pCon{i in fact} binary;
var flag {i in fact} integer;
var flag2 {i in fact} integer;
var ind{i in fact} binary;
var ind2{i in fact} binary;
var penalty{i in fact};
var penaltya{i in fact};
var penaltyb{i in fact};
var flagBinary {j in fact} binary; # indicator for whether flag is 0 or 1
var flagBinary2 {j in fact} binary;

var id{j in fact} binary;
var id2{j in fact} binary;

minimize value: sum{i in fact} (t[i]+ penalty[i]);
#minimize value: sum{i in fact} (t[i] + pCon[i] * 1 + penalty[i]);
#minimize value: sum{i in fact} (t[i] + pCon[i] * 1);
#subject to prefCon1 {i in fact}: t[i] <= (i+1)*10 + (1-pCon[i])* M;
#subject to prefCon2 {i in fact}: t[i] + pCon[i]* M >= (i+1)*10;

# if ind[i], then t[i] =  (i*10, (i+1)*10)
# otherwise ind2[i] = true, then t[i] = ((i+2)*10, (i+3)*10)
#subject to con1 {i in fact}: ind[i] ==> (t[i] >= i*10) else (t[i] >= (i+2)*10);
#subject to con1b {i in fact}: ind[i] ==> (t[i] <= (i+1)*10) else (t[i] <= (i+3)*10);
#subject to con2 {i in fact}: ind2[i] ==> (t[i] >= (i+2)*10) else (t[i] >= (i+0)*10);
#subject to con2b {i in fact}: ind2[i] ==> (t[i] <= (i+3)*10) else (t[i] <= (i+1)*10);

#subject to con1a {i in 1 .. numFactors}: ind[i] ==> (t[i] >= i*10) else (t[i]  >= (i+2)*10);
#subject to con1b {i in 1 .. numFactors}: ind[i] ==> (t[i] <= (i+1)*10) else (t[i]  <= (i+3)*10);
#subject to con2a {i in 1 .. numFactors}: ind2[i] ==> (t[i] >= (i+2)*10) else (t[i]>= (i+0)*10);
#subject to con2b {i in 1 .. numFactors}: ind2[i] ==> (t[i] <= (i+3)*10) else (t[i] <= (i+1)*10);

subject to con1c {j in 2 .. numFactors}: t[j-1] + 10 <= t[j]  + M*(1-id[j]); 
subject to con1d {j in 2 .. numFactors}: t[j-1] + 10 + id[j]*M >= t[j] ;
subject to con2c {j in 1 .. numFactors - 1}: t[j] + 5 <= t[j+1] + M*(1-id2[j]); 
subject to con2d {j in 1 .. numFactors - 1}: t[j] + 5 + id2[j]*M  >= t[j+1];

	
subject to con3 {i in 2..numFactors-1}: id[i] ==> (penaltya[i] = t[i] - t[i-1]) else (penaltya[i] = t[i+1] - t[i-1]);
subject to con3a {i in 2..numFactors-1}: id2[i] ==> (penaltyb[i] = t[i+1] - t[i]) else (penaltyb[i] = t[i+1] - t[i]);

subject to conPenalty {j in 2..numFactors-1}: flagBinary2[j] ==> (penalty[j] = penaltya[j]) else (penalty[j] = penaltyb[j]);
subject to con3b: penalty[first(fact)] = 0;
subject to con3c: penalty[last(fact)] = 0;

#subject to con6a {j in fact}:  flagBinary[j] <= flag[j];
#subject to con6b {j in fact}:  flagBinary[j] >= flag[j];

#flag[j] = ind[j] XOR ind2[j]
# forces one of them to be satisfied
#subject to con4a {j in fact}: flag[j] <= ind[j] + ind2[j];
#subject to con4b {j in fact}: flag[j] >= ind[j];
#subject to con4c {j in fact}: flag[j] >= ind2[j];
#subject to con4z {j in fact}: flag[j] <= 2 - ind[j] - ind2[j];
#subject to restrict01 {i in fact} : 1 <= flag[i] <= 1;

subject to normalcons {i in fact} : t[i] >= 0 ;

subject to con6c {j in fact}:  flagBinary2[j] <= flag2[j];
subject to con6d {j in fact}:  flagBinary2[j] >= flag2[j];

subject to con4d {j in fact}: flag2[j] <= id[j] + id2[j];
subject to con4e {j in fact}: flag2[j] >= id[j];
subject to con4f {j in fact}: flag2[j] >= id2[j];
subject to restrict02 {i in fact} : 0 <= flag2[i] <= 1;
subject to con4zz {j in fact}: flag2[j] <= 2 - id[j] - id2[j];
