import retina_cell

name_cells_load_data = "";
prefix = "2Bars_bei_10_und_-10_"; % to add easily something to the name of the data file
graphic = false;
position_obj1 = [10,0]; %startposition [x,y] in pixel
position_obj2 = [-10,0]; %for 2 obj
velocity = [0,0]; %startvelocity [v_x,v_y] in pixel per timestep
width = 360; %pixel
height = 600; %pixel
bar_width = 11;
bar_height = 1;
number_of_runs = 5000;
duration_experiment = 100; %timesteps
number_cells = 50;
minimum_radius_cells = 50;
maximum_radius_cells = 60;
y_history_list = [];
y_history_array = [];
word_history_struct = {};
cell_position_area = {[0,0],100}; %{[xcenter,ycenter],radius} of area in which the cells will be created
gamma = 20 / 60; %damping
omega = 2*pi*1.5 /60; %natural frequency 
D = 2.7e6 / 60^3; 

close;

 
%create/load cells
if name_cells_load_data == ""
    cell_creating_struct = create_cell_creating_struct(number_cells,width,height,minimum_radius_cells,maximum_radius_cells,cell_position_area);
    retina_cells = create_retina_cells(cell_creating_struct);
else
    load(name_cells_load_data);
end

for h = 1:number_of_runs
    y_history = [];
    for i = 1:duration_experiment
        %compute next positions
        [position_obj1,velocity] = compute_next_position(position_obj1,velocity,gamma, omega, D);
        [position_obj2,velocity] = compute_next_position(position_obj2,velocity,gamma, omega, D); %for 2 obj
        
        y_history(end+1) = position_obj1(2);
        y_history_list(end+1) = position_obj1(2);
    
        %create picture
        bar_pixel = compute_bar_pixel(position_obj1, bar_width, bar_height);
        bar_pixel = [bar_pixel, compute_bar_pixel(position_obj2, bar_width, bar_height)]; %for 2 obj
        
        if graphic
            pic = create_picture(width, height);
            for j = 1:length(retina_cells)
                pic = add_pixel_to_picture(pic,retina_cells{j}.pixel_data,retina_cells{j}.color,width,height);
            end
            pic = add_pixel_to_picture(pic,bar_pixel,0,width,height);
            imshow(pic,[0,128]);
        end
    
        %create signal for the actual position
        word = create_signal_word(bar_pixel,retina_cells);
        word_history_struct.decoded{h,i} = word; 
    end
    
    y_history_array(h,:) = y_history; %column: different experiments, one line: one experiment
    
    if mod(h,number_of_runs/50) == 0
        fprintf(num2str(h) + ",");
    end
end

[word_history_struct.encoded,word_history_struct.spikes_per_word] = encode_words(word_history_struct.decoded);
fprintf("\n")

%%save_data
save("number_cells-" + num2str(number_cells) + "cells_data","retina_cells"); 
save(prefix +"number_cells-" + num2str(number_cells) + "duration_experiment-" + num2str(duration_experiment) +"data.mat","word_history_struct","y_history_array","y_history_list","number_cells","minimum_radius_cells","maximum_radius_cells","bar_width","bar_height","cell_position_area","gamma", "omega", "D","duration_experiment");

 

function [position,velocity] = compute_next_position(position, velocity, gamma, omega, D) %compute next position of bar
xi = random('Normal',0,1);

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
    
    for x = min([start_x,end_x]):max([start_x,end_x])
        for y = min([start_y,end_y]):max([start_y,end_y])
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
        word(end+1) = retina_cells{i}.gives_signal_V1(pixel_struct);
    end
end

