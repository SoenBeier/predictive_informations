function P_W = prob_word_wt_at_time_t(wt,t,word_history_struct_encoded) %probabilaty, that word wt is at time t
    count_wt = 0;
    for i = 1:size(word_history_struct_encoded,1) %browse through all experiments
        if word_history_struct_encoded(i,t) == wt
            count_wt = count_wt + 1;
        end
    end
    P_W = count_wt / size(word_history_struct_encoded,1);
end