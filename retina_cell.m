classdef retina_cell
    properties
        center_position 
        radius %area in the radius around the center_position is covered by the cell
        color %color of cell at the picture
        pixel_data %pixel (structure) of obj which will be painted with obj.color at the picture {[x1,y1],[x2,y2],...}
    end
    methods
        function obj = retina_cell(center_position, radius)
            obj.center_position = center_position;
            obj.radius = radius;
            obj.color = round(rand()*90 + 10);
            obj.pixel_data = get_obj_pixel_data(obj);
        end
        function gives_signal = gives_signal_V1(obj,pixel_struct)
            for i = 1:length(pixel_struct)
                if obj.dist(pixel_struct{i}, obj.center_position) < obj.radius
                    gives_signal = true;
                    return
                end
            end
            gives_signal = false;
        end
        function pixel_data = get_obj_pixel_data(obj) %gives pixel structure ({[x1,y1],[x2,y2],...}) which will represent the obj in the image
            pixel_data = {};
            pixel_data{1} = [obj.center_position(1),obj.center_position(2)];
            i = 2;
            for phi = 0:0.01:2*pi-0.01
                x = round(obj.center_position(1) + obj.radius * cos(phi));
                y = round(obj.center_position(2) + obj.radius * sin(phi));
                pixel_data{i} = [x,y];
                i = i + 1;      
            end
        end
    end
    methods (Static)
        function d = dist(position1, position2)
            d = sqrt((position1(1) - position2(1))^2 + (position1(2) - position2(2))^2);
        end
        function is_inside = is_inside_radius(position_center, radius, position) %is the position [x,y] inside the area covered by the retina cell
            if retina_cell.dist(position_center,position) < radius
                is_inside = true;
            else
                is_inside = false;
            end
        end
    end

end