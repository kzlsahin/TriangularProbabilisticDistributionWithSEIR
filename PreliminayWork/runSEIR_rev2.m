function [S, E, I, R, N, D] = runSEIR_rev2(duration, population, betha)
%This function simulates a S-E-I-R model
%This is modifed from the paper of Kok Yew Ng and Meei Mei Gui(May 2020)
%
%   Detailed explanation goes here
a = 0.75;
b = 0.51;
c = 1;
S = zeros(1, duration);

E = zeros(1, duration);

I = zeros(1, duration);

R = zeros(1, duration);

N = zeros(1, duration);

D = zeros(1, duration);

s_protection = 0; %scale of protection or efficiensy of measures

t_inc = int16(5);    %incubation period

t_rec = int16(10);    %recovery period

t_hosp= int16(20);      %hospital period before death

k_young = 0.98;  %recovery rate for population under 65 years of age

k_old = 0.92;    %recovery rate for population over 65 years of age

N_old = 0.15;    %percentage of population over 65 years of age to total

B = betha / population;      %transmission rate per S-I

resusceptibality = 0.01;

deathRate = ((1-k_old).*N_old + (1-k_young).*(1 - N_old)); %daeth rate of infected peapole

t_start = t_inc + max(t_rec + t_hosp);

for t = 1:t_start
    
    S(t) = population;
    
    E(t) = 0;
    
    I(t) = 0;
    
    R(t) = 0;
    
    D(t) = 0;
    
    s_protection(t) = 0;
    
    N(t) = population;
    
end

I(t_start) = 4;       %infected and shows symptoms

E(t_start) = 80;      %exposed to virus

S(t_start) = N(t_start) - I(t_start) - E(t_start); %susceptible population 

for t = t_start:(duration-1)

    %B = betha / N(t);
    
    i_died = deathRate .* B .* (1 - s_protection(t - t_inc - t_hosp)) .*  S(t - t_inc - t_hosp) .* I(t - t_inc - t_hosp);
    
    s_protection(t) =  getProtection((I(t) + I(t-2) + I(t-4))/3, t); %measures taken according to previous day values;
    
    S(t+1) = S(t) - B .* (1 - s_protection(t) ) .*  S(t) .* I(t) + (1 - deathRate) .* B .* (1 - s_protection(t) ) .*  S(t - t_inc - t_rec) .* I(t - t_inc - t_rec) .* resusceptibality;
    
    E(t + 1) = E(t) + B .* (1 - s_protection(t)) .*  S(t) .* I(t) - B .* (1 - s_protection(t - t_inc)) .*  S(t - t_inc) .* I(t - t_inc);
    
    I(t+1) = I(t) + B .* (1 - s_protection(t - t_inc)) .*  S(t - t_inc) .* I(t - t_inc) - (1 - deathRate) .* B .* (1 - s_protection(t - t_inc - t_rec)) .*  S(t - t_inc - t_rec) .* I(t - t_inc - t_rec) - (deathRate) .* B .* (1 - s_protection(t - t_inc - t_hosp)) .*  S(t - t_inc - t_hosp) .* I(t - t_inc - t_hosp);
    
    R(t+1) = R(t) + (1 - deathRate) .* B .* (1 - s_protection(t - t_inc - t_rec)) .*  S(t - t_inc - t_rec) .* I(t - t_inc - t_rec) .* ( 1 - resusceptibality);

    D(t+1) = D(t) + deathRate .* B .* (1 - s_protection(t - t_inc - t_hosp)) .*  S(t - t_inc - t_hosp) .* I(t - t_inc - t_hosp);
    
    N(t+1) = N(t) - deathRate .* B .* (1 - s_protection(t - t_inc - t_hosp)) .*  S(t - t_inc - t_hosp) .* I(t - t_inc - t_hosp);
    
    
end
    figure(1);
   
    plot(E);
    hold on
    plot(I);
    set(gcf,'renderer','painters')
    xlabel('\itt') 
    hold on
    legend('E','I');

    function [sigma] = getProtection(activeCase, t)
        %this function evaluates the effect of measures taken against
        %disease spread
        %i is number of infected people
        %n is population
        d = activeCase * 1 / 50; 
        % death numbers per 100000 ple
        tiredness = 0.00000001;
        a = a - tiredness * log(double(t));
        b = b - 0.000005 * double(t);
        sigma = 0.2 + (a / (1 + exp(-1 .* b .* (d + c))) ) + 0* rand;
    end
    
end

