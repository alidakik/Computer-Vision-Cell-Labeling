function [count, labelMatrix] = My_Labeling(binaryImage)
    [rows, cols] = size(binaryImage);
    
    labelMatrix = zeros(rows, cols);
    
    label = 0;
    
    directions = [-1, 0; 1, 0; 0, -1; 0, 1; -1, -1; -1, 1; 1, -1; 1, 1];
    
    function dfs(r, c)
        stack = [r, c];
        while ~isempty(stack)
            [cur_r, cur_c] = deal(stack(end, 1), stack(end, 2));
            stack(end, :) = [];
            
            for i = 1:size(directions, 1)
                new_r = cur_r + directions(i, 1);
                new_c = cur_c + directions(i, 2);
                
                if new_r > 0 && new_r <= rows && new_c > 0 && new_c <= cols ...
                        && binaryImage(new_r, new_c) == 1 && labelMatrix(new_r, new_c) == 0
                    labelMatrix(new_r, new_c) = label;
                    stack = [stack; new_r, new_c]; 
                end
            end
        end
    end

    for r = 1:rows
        for c = 1:cols
            if binaryImage(r, c) == 1 && labelMatrix(r, c) == 0
                label = label + 1;
                labelMatrix(r, c) = label;
                dfs(r, c);
            end
        end
    end
    
    count = label;
end
