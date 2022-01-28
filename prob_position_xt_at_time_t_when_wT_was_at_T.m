function P_X_conditional = prob_position_xt_at_time_t_when_wT_was_at_T(xt,t,wT,T,word_history_struct_encoded,y_history_array) %probability that at time t the position is xt under the condition that at time T there was the signal wT
    count_wT = 0; %count of experiments with wT at time T
    count_xt_with_wT = 0; %count of experiments with xt at t when wT at T
    for i = 1:size(word_history_struct_encoded,1) %browse through all experiments
        if word_history_struct_encoded(i,T) == wT
            if y_history_array(i,t) == xt
                 count_xt_with_wT = count_xt_with_wT + 1;
            else
                count_wT = count_wT + 1;
            end
        end
    end
    P_X_conditional = count_xt_with_wT / count_wT;
end
