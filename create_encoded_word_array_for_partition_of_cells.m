word_history_struct_decoded = word_history_struct.decoded;
number_cells_in_partition = 7;
number_partitions = 25;


%function partitions = create_encoded_word_array_for_partition_of_cells(word_history_struct_decoded,number_cells,number_partitions)
    original_number_cells = length(word_history_struct_decoded{1,1});
    
    %% create partitions.cell_index_list
    i = 1;
    while i <= number_partitions
        partitions(i).cell_index_list = [];
        partitions(i).partition_index = i;
        
        j = 1;
        while j <= number_cells_in_partition
            new_cell_index = randi([1,original_number_cells]);
            if isempty(find(partitions(i).cell_index_list == new_cell_index)) %using cell only once
                partitions(i).cell_index_list(end + 1) = new_cell_index;
                j = j + 1;
            end
        end
        
        for j = 1:(length(partitions) - 1) %if partition is the same as a further partition - rewrite partition
            if isequal(partitions(i).cell_index_list, partitions(j).cell_index_list)
                i = i - 1;
                break;
            end
        end
        i = i + 1;        
    end
    
    %% create decoded word array for different partitions 
    for i = 1:size(partitions,2)
        for j = 1:size(word_history_struct_decoded,1) %every experiment
            for t = 1:size(word_history_struct_decoded,2) %every time step
                word = [];
                for k = 1:number_cells_in_partition %for every cell in the partition
                    cell_index = partitions(i).cell_index_list(k);
                    word(end+1) = word_history_struct_decoded{j,t}(cell_index);
                end
                partitions(i).word_history_struct.decoded{j,t} = word;
            end
        end
        fprintf("compute partition " + i + " of " + size(partitions,2) + "\n");
    end
    
    

%end