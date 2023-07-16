function [betha,sigma, x_mySEIR, output] = calculateBetha_mySEIR(activeCases, dailyCases,t_inc, B)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%t_inc is the incubation time

betha = zeros(length(activeCases)-t_inc -5,1); %calculation starts from 6th time and this index starts from 1

x_mySEIR = zeros(length(activeCases)-t_inc -5,1);

for i=6:1:length(dailyCases) - t_inc

    betha(i - 5) = dailyCases(i + t_inc)/(activeCases(i));
    
    x_mySEIR(i - 5) = i;
    
end

sigma = zeros(1, length(betha));

for i = 1:1:length(sigma)
    
    sigma(i) = 1 - (betha(i) / B);
end
x = activeCases(6:1:319-t_inc) .* 100000 / 51000000;
y = sigma(1:1:length(sigma));
output.x = x;
output.y = y;

end



