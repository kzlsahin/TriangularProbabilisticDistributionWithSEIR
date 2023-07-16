


duration = 400;

B = 0.7;

S = zeros(1, duration);

I = zeros(1, duration);

R = zeros(1, duration);

N = 51000000;

I(1) = 18;

R(1) = 0;

S(1) = N - I(1);


Rec = 0.0204;

for t = 1:(duration-1)
    
    a = 0.9309 - 0.002 * t;
    
    b = 4.727 + 0.;
    
    c = 0.5986;
    
    B_resp = B * (1 - produceSigmoid_SIR(a, b, c, I(t) * (100000/N)) );
    
    dI = B_resp * I(t) * S(t) / N;
    
    dR = Rec * I(t);
    
    I(t + 1) = I(t) + dI - dR;
    
    S(t + 1) = S(t) - dI;
    
    R(t + 1) = R(t) + dR;  
    
end