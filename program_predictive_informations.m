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
duration_experiment = 50; %timesteps



for i = 1:duration_experiment
    %compute next positions
    [position,velocity] = compute_next_position(position,velocity);
    x_history = [x_history,position(1)];
    y_history = [y_history,position(2)];
    
    %create picture
    black_pixel = compute_bar_pixel(position, bar_width, bar_height);
    pic = create_picture(black_pixel, width, height);
    
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

function pic = create_picture(black_pixel, width, height) %black_pixel is a structure array with all pixel coordinates which belongs to the object
    pic = zeros(height,width) + 128;
    
    for i = 1:length(black_pixel)
        x = black_pixel{i}(1) + width/2;
        y = black_pixel{i}(2) + height/2;
        pic(y,x) = 0;
    end
    
    imshow(pic);
end

function signal = create_signal(pic)
    signal = pic;
end