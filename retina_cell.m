classdef retina_cell
    properties
        center_position 
        radius %area in the radius around the center_position is covered by the cell
    end
    methods
        function obj = retina_cell(center_position, radius)
            obj.center_position = center_position;
            obj.radius = radius;
        end
       
        function is_inside = is_inside_radius(obj,position) %is the position [x,y] inside the area covered by the retina cell
            if obj.dist(obj.center_position,position) < obj.radius
                is_inside = true;
            else
                is_inside = false;
            end
        end
        
        function gives_signal = gives_signal_V1(obj,black_pixel)
            for i = 1:length(black_pixel)
                if obj.dist(black_pixel{i}, obj.center_position) < obj.radius
                    gives_signal = true;
                    return
                end
            end
            gives_signal = false;
        end
    end
    methods (Static)
        function d = dist(position1, position2)
            d = sqrt((position1(1) - position2(1))^2 + (position1(2) - position2(2))^2);
        end
    end
end