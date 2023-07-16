function sigma = produceSigmoid_SIR(a, b, c, activeCases)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

sigma = zeros(length(activeCases),1);

for i=1:1:length(activeCases)
sigma(i) = a / ( 1 + exp(-1 .* b.*(activeCases(i)/510 - c)));
end

end

