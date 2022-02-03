%% loading data
clear
data_name = "number_cells-50duration_experiment-100data";
load(data_name + ".mat");

%% parameter for calculating MI
t0 = 50; %time which will be considered as actual time
range_Delta_t = [-40,40]; 
Delta_t_step_size = 2;
normalizing_information_per_spike = true;

%% parameter for generating groups of cells
number_groups = 25;
number_cells_in_group = 5;

%% computing MI for all cells
fprintf("computing MI for all cells \n");
[mutual_information_list, Delta_t_list] = compute_mutual_information_between_word_and_position(word_history_struct.encoded,y_history_array,t0,range_Delta_t,Delta_t_step_size);

mi_figure = figure('name','mutual information');
save("MI_for_all_cells_" + data_name, "Delta_t_list", "mutual_information_list")
plot(Delta_t_list,mutual_information_list);
savefig(mi_figure,'MI_all_cells-' + data_name);
close;

%% computing a mean MI of different groups of cells
groupstruct = create_encoded_word_array_for_groups_of_cells(word_history_struct.decoded,number_cells_in_group,number_groups);
save("groupstruct_of_" + num2str(length(groupstruct)) + "_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name,"groupstruct","number_groups","number_cells_in_group");

for i = 1:length(groupstruct)
    fprintf("\n computing MI of group " + i + " of " + length(groupstruct) + "\n");
    [mutual_information_cellarray{i}, Delta_t_cellarray{i}] = compute_mutual_information_between_word_and_position(groupstruct(i).word_history_struct.encoded,y_history_array,t0,range_Delta_t,Delta_t_step_size);
end

%creating fig with MI of different cellgroups
mi_figure = figure('name','mutual information of different cell groups');
hold on
legend_text = [];
for i = 1:length(groupstruct)
    plot(Delta_t_cellarray{i},mutual_information_cellarray{i});
    legend_text = [legend_text,num2str(i)];
end
legend(legend_text);
hold off
savefig(mi_figure,"MI_different_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name);
close;

%calculating mean
fprintf("computing mean of MI for groups \n")
mean_mutual_information = [];
for j = 1:length(range_Delta_t(1):Delta_t_step_size:range_Delta_t(2))
    sum_MI = 0;
    for i = 1:length(groupstruct)
        sum_MI = sum_MI + mutual_information_cellarray{i}(j);
    end
    mean_mutual_information(j) =  sum_MI / length(groupstruct);
end

mi_figure = figure('name','mutual information of different cell groups');
plot(Delta_t_cellarray{1},mean_mutual_information);
savefig(mi_figure,"MI_mean_of_" + num2str(length(groupstruct)) + "_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name);
close;

save("MI_of_groupstruct_of" + num2str(length(groupstruct)) + "_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name, "mutual_information_cellarray","Delta_t_cellarray","mean_mutual_information");


