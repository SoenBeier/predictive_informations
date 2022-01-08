import retina_cell

width = 360; %pixel
height = 600; %pixel
bar_width = 11;
bar_height = 1;
position = [0,0]; %startposition [x,y] in pixel
velocity = [0,0]; %startvelocity [v_x,v_y] in pixel per timestep
x_history = [];
y_history = [];
signal_word_history = {};
duration_experiment = 1000; %timesteps
number_cells = 40;
minimum_radius_cells = 50;
maximum_radius_cells = 100;
cell_position_area = {[0,0],100}; %{[xcenter,ycenter],radius} of area in which the cells will be created
close;

%create cells
cell_creating_struct = create_cell_creating_struct(number_cells,width,height,minimum_radius_cells,maximum_radius_cells,cell_position_area);
retina_cells = create_retina_cells(cell_creating_struct);


for i = 1:duration_experiment
    %compute next positions
    [position,velocity] = compute_next_position(position,velocity);
    x_history = [x_history,position(1)];
    y_history = [y_history,position(2)];
    
    %create picture
    bar_pixel = compute_bar_pixel(position, bar_width, bar_height);
    pic = create_picture(width, height);
    for j = 1:length(retina_cells)
        pic = add_pixel_to_picture(pic,retina_cells{j}.pixel_data,retina_cells{j}.color,width,height);
    end
    pic = add_pixel_to_picture(pic,bar_pixel,0,width,height);
    imshow(pic,[0,128]);
    
    %create signal for the actual position
    word = create_signal_word(bar_pixel,retina_cells);
    signal_word_history{i,1} = word; 
end

[signal_word_history,sentence] = encode_words_consecutively(signal_word_history);
%plot graphs

figure('Name','y coordinate and signal word history')
hold on;
plot(y_history);
plot(sentence,'-o');
legend('y coordinate', 'signal word history');
hold off;


%pause(1);
%close;

function [position,velocity] = compute_next_position(position, velocity) %compute next position of bar
xi = random('Normal',0,1);
gamma = 20 / 60; %damping
omega = 2*pi*1.5 /60; %natural frequency 
D = 2.7e6 / 60^3; 

position(2) = round(position(2) + velocity(2) * 1);
velocity(2) = (1 - gamma * 1) * velocity(2) - omega^2 * position(2)*1 + xi * sqrt(D*1);

end
function cell_creating_struct = create_cell_creating_struct(Number,picture_width,picture_height,min_radius,max_radius,cell_position_area)

    for i = 1:Number
        while true
            x = round(rand * picture_width - picture_width/2);
            y = round(rand * picture_height - picture_height/2);
            
            if retina_cell.is_inside_radius(cell_position_area{1},cell_position_area{2},[x,y])
                break;
            end
        end
        
        cell_creating_struct{i}.position = [x,y];
        cell_creating_struct{i}.radius = rand * (max_radius-min_radius) + min_radius;
    end
end
function retina_cells = create_retina_cells(cell_creating_struct)%creating a structure with the retina cell objs
    for i = 1:length(cell_creating_struct)
        center_position = cell_creating_struct{i}.position;
        radius = cell_creating_struct{i}.radius;
        retina_cells{i} = retina_cell(center_position,radius);
    end
end
function bar_pixel = compute_bar_pixel(position, bar_width, bar_height) %create structure with the coordinates/pixels of the bar
    start_x = round(position(1) - bar_width/2);
    end_x = round(position(1) + bar_width/2 - 1);
    start_y = round(position(2) - bar_height/2);
    end_y = round(position(2) + bar_height/2 - 1);
    
    i = 1;
    for x = start_x:end_x
        for y = start_y:end_y
            bar_pixel{i} = [x,y];
            i = i + 1;
        end
    end
end
function pic = create_picture(width, height)%create white picture
    pic = zeros(height,width) + 128; % 128 = white
end 
function pic = add_pixel_to_picture(pic, pixel_data, color_value,width,height) %draw new pixel into the pic; pixel_data has format: {[x,y],[x2,y2],...}
    for i = 1:length(pixel_data)
        x = round(pixel_data{i}(1) + width/2);
        y = round(pixel_data{i}(2) + height/2);
        
        if y > 0 & x > 0 & y < height & x < width
            pic(y,x) = color_value;
        end
    end
end
function word = create_signal_word(pixel_struct,retina_cells) %create signal_word of current time step, pixel_struct = {[x1,y1],[x2,y2],..}
    word = [];
    for i = 1:length(retina_cells)
        word = [word, retina_cells{i}.gives_signal_V1(pixel_struct)];
    end
end
function [signal_word_history,sentence] = encode_words_consecutively(signal_word_history) %takes signal_word_history as a struct with entries signal_word_history{i,1} = [words]; gives the second row with signal_word_history{i,2} = index word; same words get same number,sentence is the concatenation of numbers in an array
    sentence = [];
    for i = 1:length(signal_word_history)
        signal_word_history{i,2} = "None";
    end
    
    k = 1;
    for i = 1:length(signal_word_history)
        for j = 1:length(signal_word_history)
            if isequal(signal_word_history{i,1},signal_word_history{j,1})
                signal_word_history{i,2} = signal_word_history{j,2};
                break
            end            
        end
        if isequal(signal_word_history{i,2}, "None")
            signal_word_history{i,2} = k;
            k = k + 1;
        end
        sentence = [sentence,signal_word_history{i,2}];
    end
end
function mutal_information(sentence,y_history)
end