%time series Neural network inputs and targets

t_start = 6;

t_end = 280;

nnInputs = zeros(t_end - t_start + 1, 4);

nnOutputs = zeros(t_end - t_start + 1, 1);

for i = t_start:1:t_end
    
    nnInputs(i-5,:) = [i N activeCases(i) daily_deaths(i)];
    
    nnOutputs(i-5) = sigma(i - 5); %sigma was calculated from i = 6
    
end
