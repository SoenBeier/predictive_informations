load("data.mat");

mutual_information_array = [];
Delta_t_array = [];
t0 = 80; %time which will be considered as actual time
a = [];
b = [];
c = [];
d = [];


for Delta_t = -80:1:20
    mutual_information = 0;
    
    if t0 + Delta_t < 1 | t0 + Delta_t > size(word_history_struct.encoded,1)
        continue;
    end
    
    for w = 1:max(word_history_struct.encoded,[],"all") %for sum over all wt 
        for x = 1:max(y_history_array,[],"all") %for sum over all xt
            factor2 = prob_position_xt_at_time_t_when_wT_was_at_T(x,t0 + Delta_t, w, t0, word_history_struct, y_history_array);
            factor3 = log2(factor2 / prob_position_xt_at_time_t(x,t0 + Delta_t,y_history_array));
            
            %a = [a,prob_word_wt_at_time_t(w,t0,word_history_struct)];
            %b = [b,factor2];
            %c = [c,prob_position_xt_at_time_t(x,t0 + Delta_t,y_history_array)];
            %d = [d,factor3];
            
            if not(isnan(factor3) | isinf(factor3))
                mutual_information = mutual_information + ...
                prob_word_wt_at_time_t(w,t0,word_history_struct) * ...
                factor2 * ...
                factor3;
            end
        end
    end
    
    mutual_information_array = [mutual_information_array,mutual_information];
    Delta_t_array = [Delta_t_array,Delta_t];
    
    fprintf(num2str(Delta_t) + ";");
end

plot(Delta_t_array,mutual_information_array);

function P_W = prob_word_wt_at_time_t(wt,t,word_history_struct) %probabilaty, that word wt ist at time t
    count_wt = 0;
    for i = 1:size(word_history_struct.encoded,1) %browse through all experiments
        if word_history_struct.encoded(i,t) == wt
            count_wt = count_wt + 1;
        end
    end
    P_W = count_wt / size(word_history_struct.encoded,1);
end
function P_X = prob_position_xt_at_time_t(xt,t,y_history_array)
    count_xt = 0;
    for i = 1:size(y_history_array,1) %browse through all experiments
        if y_history_array(i,t) == xt
            count_xt = count_xt + 1;
        end
    end
    P_X = count_xt / size(y_history_array,1);
end
function P_X_conditional = prob_position_xt_at_time_t_when_wT_was_at_T(xt,t,wT,T,word_history_struct,y_history_array) %probability that at time t the position is xt under the condition that at time T there was the signal wT
    count_wT = 0; %count of experiments with wT at time T
    count_xt_with_wT = 0; %count of experiments with xt at t when wT at T
    for i = 1:size(word_history_struct.encoded,1) %browse through all experiments
        if word_history_struct.encoded(i,T) == wT
            if y_history_array(i,t) == xt
                 count_xt_with_wT = count_xt_with_wT + 1;
            else
                count_wT = count_wT + 1;
            end
        end
    end
    P_X_conditional = count_xt_with_wT / count_wT;
end
