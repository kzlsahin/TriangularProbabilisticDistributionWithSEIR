clear;

% dependency matlab function getH 

rawData = importdata("SouthKorea_rawData.txt", ' ', 1);
derivedData = importdata( "SouthKorea__t-Ti_t-novelDailyCases-Ht.txt", ' ', 1);

global total_cases;
global novelDailyCases;
global active_cases;
global total_deaths;
global daily_deaths;
global Ti_t_meanSeries;
global daily_recovered;
global total_recovered;


total_cases = rawData.data(:,1);
novelDailyCases = rawData.data(:,2);
active_cases = rawData.data(:,3);
total_deaths= rawData.data(:,4);
daily_deaths = rawData.data(:,5);

Ti_t_meanSeries = derivedData.data(:,1);
daily_recovered = derivedData.data(:, 3);

total_recovered = total_cases - total_deaths - active_cases;

%triangular distribution
global t_0
global c;
global L;
t_0 = 7; 
c = 4;
L = 28;

% initial parameters
global betha_;
global sigma;
global gamma;
global k;
global t_inc;
global t_start;
global S_start;
global N_start;
global I_hist;
global t_end;

betha_ = 0.1 ;
sigma = 0; % for now there is no control
gamma = 0.025;
k = 0.001;
t_inc = 6; %time delay due to incubation
t_start = t_inc + L + 5; % starting time of the model
t_end = 2000;
S_start = 5.1478e7;
N_start = 5.1478e7;


%histroy Data
global I_hist;
global S_hist;
global N_hist;

I_hist = active_cases(1:t_start);
S_hist = S_start;
N_hist = N_start;

t_span = t_start : t_end;
lags = [t_inc, (1 : L) + (t_inc + t_0)]; % lag from instant exposed, Te
sol = dde23(@ddefun, lags, @history, t_span);

figure(1)
plot(sol.x,sol.y,'-o')
xlabel('Time t');
ylabel('Solution y');
legend('S','I','R', 'D');




function dydt = ddefun(t,y,z)
    global N_start;
    global betha_;
    global sigma;
    global gamma;
    global k;
    S = y(1);  
    I = y(2);
    R = y(3);
    D = y(4);
    S_d = z(1, 2:end); % delayed values for triangular dist.
    I_d = z(2, 2:end);
    R_d = z(3, 2:end);
    D_d = z(4, 2:end);
    S_tinc = z(1, 1); % delayed values at t - t_inc
    I_tinc = z(2, 1);
    R_tinc = z(3, 1);
    D_tinc = z(4, 1);
    N = N_start - D;
    Te = betha_ .* (1 - sigma) .* I .* (S ./ N);
    Ti_tinc = betha_ .* (1 - sigma) .* I_tinc .* (S_tinc ./ (N_start - D_tinc));
    Ti_tringDist = betha_ .* (1 - sigma) .* I_d .* (S_d ./ (N_start - D_d));
    h = getH(Ti_tringDist);
    dSdt = -Te + R * k;
    dIdt = Ti_tinc - h;
    dRdt = h .* ( 1 - gamma) - R* k;
    dDdt = h .* gamma;
    dydt = [dSdt; dIdt; dRdt; dDdt];
end
%-------------------------------------------
function s = history(t)
global S_start
global t_start
global active_cases
  s = zeros(4,1);
  s(1) = S_start;
  if t > 1
  s(2) = interp1(1:t_start, active_cases(1:t_start), t);
  end
end

