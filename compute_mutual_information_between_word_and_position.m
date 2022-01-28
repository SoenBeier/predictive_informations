function [mutual_information_array, Delta_t_array] = compute_mutual_information_between_word_and_position(word_history_struct_encoded,y_history_array,t0,range_Delta_t,Delta_t_step_size)

% Mutual information between location and signal word
mutual_information_array = [];
Delta_t_array = [];

%a = [];
%b = [];
%c = [];
%d = [];

for Delta_t = range_Delta_t(1):Delta_t_step_size:range_Delta_t(2)
    mutual_information = 0;
    
    if t0 + Delta_t < 1 | t0 + Delta_t > size(word_history_struct_encoded,1)
        continue;
    end
    
    for w = 1:max(word_history_struct_encoded,[],"all") %for sum over all wt 
        for x = 1:max(y_history_array,[],"all") %for sum over all xt
            factor2 = prob_position_xt_at_time_t_when_wT_was_at_T(x,t0 + Delta_t, w, t0, word_history_struct_encoded, y_history_array);
            factor3 = log2(factor2 / prob_position_xt_at_time_t(x,t0 + Delta_t,y_history_array));
            
            %a = [a,prob_word_wt_at_time_t(w,t0,word_history_struct)];
            %b = [b,factor2];
            %c = [c,prob_position_xt_at_time_t(x,t0 + Delta_t,y_history_array)];
            %d = [d,factor3];
            
            if not(isnan(factor3) | isinf(factor3))
                mutual_information = mutual_information + ...
                prob_word_wt_at_time_t(w,t0,word_history_struct_encoded) * ...
                factor2 * ...
                factor3;
            end
        end
    end
    
    mutual_information_array(end+1) = mutual_information;
    Delta_t_array(end+1) = Delta_t;
    
    fprintf(num2str(Delta_t) + ";");
end

end
