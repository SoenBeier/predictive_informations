word_history_struct_decoded = word_history_struct.decoded;
number_cells = 7;
number_partitions = 100;


%function partitions = create_encoded_word_array_for_partition_of_cells(word_history_struct_decoded,number_cells,number_partitions)
    original_number_cells = length(word_history_struct_decoded{1,1});
    
    %create partitions.cell_index_list
    i = 1;
    while i <= number_partitions
        partitions(i).cell_index_list = [];
        partitions(i).partition_index = i;
        
        for j = 1:number_cells
            new_cell_index = randi([1,original_number_cells]);
            if isempty(find(partitions(i).cell_index_list == new_cell_index)) %using cell only once
                partitions(i).cell_index_list(end + 1) = new_cell_index;
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
    
    
    


%end