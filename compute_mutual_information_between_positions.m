clear
data_name = "duration_experiment-800data";
load(data_name + ".mat");



%% Mutual information between positions
mutual_information_array = [];
Delta_t_array = [];
t0 = 400; %time which will be considered as actual time
%a = [];
%b = [];
%c = [];
%d = [];


for Delta_t = -300:5:10
    mutual_information = 0;
    
    if t0 + Delta_t < 1 | t0 + Delta_t > size(y_history_array,1)
        continue;
    end
    
    for xt = 1:max(y_history_array,[],"all") %for sum over all xt
        for xT = 1:max(y_history_array,[],"all") 
            factor1 = prob_position_xt_at_time_t(xt,t0,y_history_array);
            factor2 = prob_position_xT_at_time_T_when_xt_was_at_t(xt,t0,xT,t0 + Delta_t,y_history_array);
            factor3 = log2(factor2/prob_position_xt_at_time_t(xT,t0 + Delta_t,y_history_array));
            
            %a = [a,factor1];
            %b = [b,factor2];
            %c = [c,prob_position_xt_at_time_t(xT,t0 + Delta_t,y_history_array)];
            %d = [d,factor3];
            
            if not(isnan(factor3) | isinf(factor3))
                mutual_information = mutual_information + factor1 * factor2 * factor3;
            end
        end
    end
    
    mutual_information_array(end+1) = mutual_information;
    Delta_t_array(end+1) = Delta_t;
    
    fprintf(num2str(Delta_t) + ";");
end

mi_figure = figure('name','mutual_information_positions_300steps');
save(data_name + "mutual_information_positions", "Delta_t_array", "mutual_information_array")
plot(Delta_t_array,mutual_information_array);
savefig(mi_figure,'mi_positions-' + data_name);
close;
