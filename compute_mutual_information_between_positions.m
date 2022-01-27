clear
data_name = "number_cell-10data";
load(data_name + ".mat");


%% Mutual information between positions
for Delta_t = -40:2:40
    mutual_information = 0;
    
    if t0 + Delta_t < 1 | t0 + Delta_t > size(word_history_struct.encoded,1)
        continue;
    end
    
    for x1 = 1:max(y_history_array,[],"all") %for sum over all xt1
        for x2 = 1:max(y_history_array,[],"all") 
            factor1 = 
            factor2 = 
            factor3 = 
            
            if not(isnan(factor3) | isinf(factor3))
                mutual_information = mutual_information + factor1 * factor2 * factor3;
            end
        end
    end
    
    mutual_information_array(end+1) = mutual_information;
    Delta_t_array(end+1) = Delta_t;
    
    fprintf(num2str(Delta_t) + ";");
    
end