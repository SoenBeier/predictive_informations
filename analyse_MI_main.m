%% loading data
clear
data_name = "number_cells-50duration_experiment-100data";
load(data_name + ".mat");

%% parameter for calculating MI
t0 = 50; %time which will be considered as actual time
range_Delta_t = [-40,40]; 
Delta_t_step_size = 2;
normalizing_information_per_spike = true; %normalizing by mean of spikes which were recorded at the considered time step

%% parameter for generating groups of cells
number_groups = 25;
number_cells_in_group_array = [1,2,3,4,5,6,7]; %cell numbers for which we want to see a result

%% computing MI for all cells
fprintf("computing MI for all cells \n");
[mutual_information_list, Delta_t_list] = compute_mutual_information_between_word_and_position(word_history_struct.encoded,y_history_array,t0,range_Delta_t,Delta_t_step_size,normalizing_information_per_spike,word_history_struct.spikes_per_word);

save("MI_for_all_cells_" + data_name, "Delta_t_list", "mutual_information_list")

mi_figure = figure('name','mutual information');
plot(Delta_t_list,mutual_information_list);
savefig(mi_figure,'MI_all_cells-' + data_name);
close;

%% computing a mean MI of different groups of cells
mean_mutual_information_different_groupsize_array = []; %will be filled with mean mutual information for every cell number which are defined in number_cells_in_group_array
std_error_MI_different_groupsize_array = [];

for number_cells_in_group = number_cells_in_group_array
    groupstruct = create_encoded_word_array_for_groups_of_cells(word_history_struct.decoded,number_cells_in_group,number_groups);
    save("groupstruct_of_" + num2str(length(groupstruct)) + "_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name,"groupstruct","number_groups","number_cells_in_group");

    for i = 1:length(groupstruct)
        fprintf("\n computing MI of group " + i + " of " + length(groupstruct) + "\n");
        [mutual_information_cellarray{i}, Delta_t_cellarray{i}] = compute_mutual_information_between_word_and_position(groupstruct(i).word_history_struct.encoded,y_history_array,t0,range_Delta_t,Delta_t_step_size,normalizing_information_per_spike,groupstruct(i).word_history_struct.spikes_per_word);
    end

    %creating fig with MI of different cellgroups
    mi_figure = figure('name','mutual information of different cell groups');
    hold on
    legend_text = [];
    for i = 1:length(groupstruct)
        plot(Delta_t_cellarray{i},mutual_information_cellarray{i});
        legend_text = [legend_text,string(num2str(i))];
    end
    legend(legend_text);
    xlabel("\Delta t");
    ylabel("I(W_{t1};X_{t1+\Delta t} in bits/spike");
    hold off
    savefig(mi_figure,"MI_different_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name);
    close;

    %calculating mean
    fprintf("computing mean of MI for groups \n")
    mean_mutual_information = [];
    std_error_MI = [];
    for j = 1:length(range_Delta_t(1):Delta_t_step_size:range_Delta_t(2))
        temp_MI_list = [];
        for i = 1:length(groupstruct)
            temp_MI_list(end + 1) = mutual_information_cellarray{i}(j);
        end
        mean_mutual_information(j) =  mean(temp_MI_list);
        std_error_MI(j) = std(temp_MI_list)/sqrt(length(temp_MI_list));
    end
    
    %saving data for figure with different group sizes
    mean_mutual_information_different_groupsize_array(end + 1,:) = mean_mutual_information;
    std_error_MI_different_groupsize_array(end + 1,:) = std_error_MI;
    
    %saving data from this groupsize
    save("MI_of_groupstruct_of" + num2str(length(groupstruct)) + "_cell_groups_with_size" + num2str(number_cells_in_group) + "_" + data_name, "mutual_information_cellarray","Delta_t_cellarray","mean_mutual_information","std_error_MI");
    
    fprintf("finished calculation for cell number " + string(number_cells_in_group) + "\n");
end

%saving figure with mean MI of groups of cells with different sizes
mi_figure = figure('name','mutual information of different cell groups');
hold on
for i = 1:size(mean_mutual_information_different_groupsize_array,1)
    errorbar(Delta_t_cellarray{1},mean_mutual_information_different_groupsize_array(i,:),std_error_MI_different_groupsize_array(i,:));
end
legend(string(number_cells_in_group_array));
xlabel("\Delta t");
ylabel("I(W_{t1};X_{t1+\Delta t} in bits/spike");
hold off
savefig(mi_figure,"MI_mean_of_" + num2str(length(groupstruct)) + "_cell_groups_for_different_sizes" + "_" + data_name);
save("MI_mean_of_" + num2str(length(groupstruct)) + "_cell_groups_for_different_sizes" + "_" + data_name, "mean_mutual_information_different_groupsize_array","Delta_t_cellarray");
close;
