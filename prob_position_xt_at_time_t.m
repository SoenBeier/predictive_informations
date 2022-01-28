function P_X = prob_position_xt_at_time_t(xt,t,y_history_array)
    count_xt = 0;
    for i = 1:size(y_history_array,1) %browse through all experiments
        if y_history_array(i,t) == xt
            count_xt = count_xt + 1;
        end
    end
    P_X = count_xt / size(y_history_array,1);
end
