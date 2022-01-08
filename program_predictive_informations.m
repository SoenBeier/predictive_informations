import retina_cell

width = 360; %pixel
height = 600; %pixel
bar_width = 11;
bar_height = 1;
position = [0,0]; %startposition [x,y] in pixel
velocity = [0,0]; %startvelocity [v_x,v_y] in pixel per timestep
x_history = [];
y_history = [];
signal_history = {};
duration_experiment = 100; %timesteps
number_cells = 30;
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
    black_pixel = compute_bar_pixel(position, bar_width, bar_height);
    pic = create_picture(width, height);
    for i = 1:length(retina_cells)
        pic = add_pixel_to_picture(pic,retina_cells{i}.pixel_data,retina_cells{i}.color,width,height);
    end
    pic = add_pixel_to_picture(pic,black_pixel,0,width,height);
    imshow(pic,[0,128]);
    
    %create signal for the actual position
    signal = create_signal(pic);
    signal_history{i} = signal; 
    
    %plot graphs
    %plot(y_history)
end
pause(1);
close;

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

function signal = create_signal(pic)
    signal = [];
end