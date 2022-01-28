function word_history_struct_encoded = encode_words(word_history_struct_decoded); %assigns an encoding (number) to each different word and save it in word_history_struct_encoded
    %%initialisation encoded structure
    word_history_struct_encoded = NaN(size(word_history_struct_decoded,1),size(word_history_struct_decoded,2));
    
    %%assignment numbers to different words
    word_number = 1;
    b2 = false;
    for i = 1:size(word_history_struct_decoded,1) %different runs
        for j = 1:size(word_history_struct_decoded,2) %different words in a sentence
            
            for k = 1:i %different runs -> for each word -> is there another word like this?
                for l = 1:size(word_history_struct_decoded,2) %different words in a sentence
                    if isequal(word_history_struct_decoded{i,j},word_history_struct_decoded{k,l})
                        word_history_struct_encoded(i,j) = word_history_struct_encoded(k,l);
                        b2 = true; %to breack the second for loop
                        break;
                    end
                end
                if b2 == true
                    b2 = false;
                    break;
                end
            end
            
            if isnan(word_history_struct_encoded(i,j))
                word_history_struct_encoded(i,j) = word_number;
                word_number = word_number + 1;
            end   
        end
    end
    
    word_history_struct.word_list = NaN(1,size(word_history_struct_encoded,1)*size(word_history_struct_encoded,2));
    k = 1;
    for i = 1:size(word_history_struct_encoded,1)
        for j = 1:size(word_history_struct_encoded,2)
            word_history_struct.word_list(k) = word_history_struct_encoded(i,j);
            k = k + 1;
        end
    end
end