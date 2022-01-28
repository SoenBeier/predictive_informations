function groups = create_encoded_word_array_for_groups_of_cells(word_history_struct_decoded,number_cells_in_group,number_groups)
    original_number_cells = length(word_history_struct_decoded{1,1});
    
    %% create groups.cell_index_list
    fprintf("\n creating cell_index_list of groups struct \n");
    i = 1;
    while i <= number_groups
        groups(i).cell_index_list = [];
        groups(i).group_index = i;
        
        j = 1;
        while j <= number_cells_in_group
            new_cell_index = randi([1,original_number_cells]);
            if isempty(find(groups(i).cell_index_list == new_cell_index)) %using cell only once
                groups(i).cell_index_list(end + 1) = new_cell_index;
                j = j + 1;
            end
        end
        
        for j = 1:(length(groups) - 1) %if group is the same as a further group - rewrite group
            if isequal(groups(i).cell_index_list, groups(j).cell_index_list)
                i = i - 1;
                break;
            end
        end
        i = i + 1;        
    end
    
    %% create decoded word array for different groups 
    fprintf("create decoded word array for groups struct \n");
    for i = 1:size(groups,2)
        for j = 1:size(word_history_struct_decoded,1) %every experiment
            for t = 1:size(word_history_struct_decoded,2) %every time step
                word = [];
                for k = 1:number_cells_in_group %for every cell in the group
                    cell_index = groups(i).cell_index_list(k);
                    word(end+1) = word_history_struct_decoded{j,t}(cell_index);
                end
                groups(i).word_history_struct.decoded{j,t} = word;
            end
        end
        fprintf("finished computing group " + i + " of " + size(groups,2) + "\n");
    end
    
    %% create encoded word array
    fprintf("create encoded word array for groups struct \n");
    for i = 1:size(groups,2)
        groups(i).word_history_struct.encoded = encode_words(groups(i).word_history_struct.decoded);
        fprintf("finished generating encoded word struct to group " + i + " of " + size(groups,2) + "\n");
    end
    
    %% remove decoded decoded
    fprintf("remove decoded field of groups struct \n");
    for i = 1:size(groups,2)
        groups(i).word_history_struct = rmfield(groups(i).word_history_struct,"decoded");
    end
end