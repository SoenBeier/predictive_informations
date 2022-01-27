clear
data_name = "duration_experiment-200data";
load(data_name + ".mat");

%% Mutual information between location and signal word
mutual_information_array = [];
Delta_t_array = [];
t0 = 50; %time which will be considered as actual time
%a = [];
%b = [];
%c = [];
%d = [];

for Delta_t = -40:2:40
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
    
    mutual_information_array(end+1) = mutual_information;
    Delta_t_array(end+1) = Delta_t;
    
    fprintf(num2str(Delta_t) + ";");
end

mi_figure = figure('name','mutual information');
save(data_name + "mutual_information", "Delta_t_array", "mutual_information_array")
plot(Delta_t_array,mutual_information_array);
savefig(mi_figure,'mi - ' + data_name);
close;
