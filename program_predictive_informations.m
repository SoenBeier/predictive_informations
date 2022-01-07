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
duration_experiment = 20; %timesteps
number_cells = 30;
maximum_radius_cells = 40;


%create cells
cell_creating_struct = create_cell_creating_struct(number_cells,height,width,maximum_radius_cells);
retina_cells = create_retina_cells(cell_creating_struct);


for i = 1:duration_experiment
    %compute next positions
    [position,velocity] = compute_next_position(position,velocity);
    x_history = [x_history,position(1)];
    y_history = [y_history,position(2)];
    
    %create picture
    black_pixel = compute_bar_pixel(position, bar_width, bar_height);
    pic = create_picture(width, height);
    pic = add_pixel_to_picture(pic,black_pixel,0);
    imshow(pic);
    
    %create signal for the actual position
    signal = create_signal(pic);
    signal_history{i} = signal; 
    
    %plot graphs
    plot(y_history)
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

function cell_creating_struct = create_cell_creating_struct(Number,picture_width,picture_height,max_radius)

    for i = 1:Number
        cell_creating_struct{i}.position = [round(rand * picture_width - 1) , round(rand * picture_height - 1)];
        cell_creating_struct{i}.radius = rand * max_radius;
    end
end

function retina_cells = create_retina_cells(cell_creating_struct)
    for i = 1:length(cell_creating_struct)
        center_position = cell_creating_struct{i}.position;
        radius = cell_creating_struct{i}.radius;
        retina_cells{i} = retina_cell(center_position,radius);
    end
end

function bar_pixel = compute_bar_pixel(position, bar_width, bar_height)
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

function pic = create_picture(width, height)
    pic = zeros(height,width) + 128; % 128 = white
end

function pic = add_pixel_to_picture(pic, pixel_data, color_value) %draw new pixel into the pic; pixel_data has format: {[x,y],[x2,y2],...}
    height = size(pic,1);
    width = size(pic,2);
    
    for i = 1:length(pixel_data)
        x = pixel_data{i}(1) + width/2;
        y = pixel_data{i}(2) + height/2;
        pic(y,x) = color_value;
    end
end

function signal = create_signal(pic)
    signal = []
end