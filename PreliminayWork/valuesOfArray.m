function [array] = valuesOfArray(arrIn)
    arraySize = size(arrIn);
    if length(arraySize) > 2 || arraySize(1) > 1
        display("input argument is not a single line array");
        return
    end

    for i = 1:length(arrIn)
        display(arrIn(i));
        array(i) = arrIn(i);
    end
    
end
