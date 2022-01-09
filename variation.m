global variations_struct
variations_struct = {}
word_variation(30,[]);

function word_variation(number_cells,variation) %paramter should be:variation = [], variations_stuct = {}
    global variations_struct
    if length(variation) >= number_cells
        variations_struct{length(variations_struct) + 1} = variation;
        return
    end    
    word_variation(number_cells,[variation,0]);
    word_variation(number_cells,[variation,1]);
end