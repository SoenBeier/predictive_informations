function P_X_conditional = prob_position_xT_at_time_T_when_xt_was_at_t(xt,t,xT,T,y_history_array)
    count_xt = 0; %count of experiments with x2 at time T
    count_xT_with_xt = 0; %count of experiments with x1 at t when x2 at T
    
    for i = 1:size(y_history_array,1)
        if y_history_array(i,t) == xt
            if y_history_array(i,T) == xT
                count_xT_with_xt = count_xT_with_xt + 1;                
            end
            count_xt = count_xt + 1;
        end
    end
    P_X_conditional = count_xT_with_xt / count_xt;
end