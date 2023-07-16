% gets distribution of a time interval from the history of data
function h = getH(Ti)
global c;
global L;

%let's get samples from the distribution before simpson integration
h_part1 = zeros(c , 1);
for x = 1 : c + 1
    h_part1(x, 1) =  p_1(x - 1, c, L) .* Ti(1, x);
end

h_part2 = zeros(1 + L - c, 1);
for x = c+1 : L
    h_part2(1 + x - c, 1) = p_2(x, c, L) .* Ti(1, x);
end

h = trapz(h_part1) + trapz(h_part2);

function y = p_1(x, c, L)
y = (2 * x ) ./ (L * c);
end

function y = p_2(x, c, L)
y = (2 * (L - x)) ./ (L * (L - c));
end
end