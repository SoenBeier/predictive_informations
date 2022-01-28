clear
data_name = "duration_experiment-800data";
load(data_name + ".mat");

t0 = 50; %time which will be considered as actual time
range_Delta_t = [-40,40]; 
Delta_t_step_size = 4;

[mutual_information_array, Delta_t_array] = compute_mutual_information_between_word_and_position(word_history_struct.encoded,y_history_array,t0,range_Delta_t,Delta_t_step_size);

mi_figure = figure('name','mutual information');
save(data_name + "mutual_information", "Delta_t_array", "mutual_information_array")
plot(Delta_t_array,mutual_information_array);
savefig(mi_figure,'mi - ' + data_name);
close;