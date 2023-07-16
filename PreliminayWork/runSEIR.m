function [S, E, I, R, N, D] = runSEIR(duration, population, betha)
%This function simulates a S-E-I-R model
%This is modifed from the paper of Kok Yew Ng and Meei Mei Gui(May 2020)
%
%   Detailed explanation goes here

S = zeros(1, duration);

E = zeros(1, duration);

dailyExposed = zeros(1, duration);

I = zeros(1, duration);

R = zeros(1, duration);

N = zeros(1, duration);

D = zeros(1, duration);

birthRate = 1.1e-12; %daily rate of birth per person

naturalDeathRate = 1.01e-12;

B = betha;      %transmission rate per S-I

s_protection = 0; %scale of protection or efficiensy of measures

t_inc = 5;    %incubation period

t_rec = 19;    %recovery period

t_hosp= 20;      %hospital period before death

k_young = 0.98;  %recovery rate for population under 65 years of age

k_old = 0.92;    %recovery rate for population over 65 years of age

N(1) = population; %population

N_old = 0.15;    %percentage of population over 65 years of age to total

I(1) = 4;       %infected and shows symptoms

E(1) = 80;      %exposed to virus

S(1) = N(1) - (I(1) + E(1)); %susceptible population

R(1) = 0;       %permenantly recovered population

D(1) = 0;       %Deaths due to infection

resusceptibality = 0.01;

Rs = 0; %starting value of Rs is number of resusceptibles per time interval

deathRate = ((1-k_old).*N_old + (1-k_young).*(1 - N_old)); %daeth rate of infected peapole

for t = 1:(duration-1)
    
    dailyExposed(t) = B.*(1 - s_protection) .* ( S(t) / N(t) ) .* I(t);
    
    if (t - t_inc) < 1
        
        e = 0;
        
    else
        
        e = dailyExposed(int16(t - t_inc)) .* ((1 - naturalDeathRate).^t_inc);
        
    end
    
    if (t - t_rec) < 1
        
        i_rec = 0;
        
    else
        
        i_rec = dI(int16(t - t_rec));
        
        i_rec = (1 - deathRate) .* i_rec .* ((1 - naturalDeathRate) .^ t_rec);
    end
    
    if (t - t_hosp) < 1
        
        i_died = 0;
        
    else
        
        i_died = deathRate .*  dI(int16(t - t_hosp)) .* ((1 - naturalDeathRate) .^ t_hosp);
        
    end
        
    dI(t) = e;
    
    Rs = i_rec .* resusceptibality;
    
    I(t+1) = I(t) + dI(t) - I(t).* naturalDeathRate - i_rec - i_died ;
        
    S(t+1) = S(t) + N(t).*birthRate - S(t).* naturalDeathRate - dailyExposed(t) + Rs;

    E(t + 1) = E(t) + dailyExposed(t) - E(t) .* naturalDeathRate - e;
    
    R(t+1) = R(t) + i_rec - Rs - (R(t) .* naturalDeathRate);

    D(t+1) = D(t) + i_died;
    
    N(t+1) = N(t) .* (1 - naturalDeathRate + birthRate) - i_died;
    
    s_protection = getProtection(i_died); %measures taken according to previous day values
end

    plot(S);
    hold on
    plot(E);
    hold on
    plot(I);
    hold on
   plot(R);
   hold on
    plot(D);
    set(gcf,'renderer','painters')
    xlabel('\itt') 
    hold on
    legend('S','E','I','R','D');

    function [sigma] = getProtection(d)
        %this function evaluates the effect of measures taken against
        %disease spread
        %d is number of deaths today
        
        a = 0.25; %maks limit for protection
        c = 0.5; %sensibilaty to disease
        d = d .* 100000 / N(t);
        sigma = (1 / (1 + exp(-1 .* a .* d + c)));
    end
    
end

