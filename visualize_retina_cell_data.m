width = 360; %pixel
height = 600; %pixel

pic = create_picture(width, height);
pic = add_pixel_to_picture(pic,{[0,0]},0,width,height);
    for j = 1:length(retina_cells)
        pic = add_pixel_to_picture(pic,retina_cells{j}.pixel_data,retina_cells{j}.color,width,height);
    end
imshow(pic,[0,128]);

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