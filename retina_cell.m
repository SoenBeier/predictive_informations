classdef retina_cell
    properties
        centerposition
        radius
    end
    methods
        function obj = retina_cell(center_position, radius)
            obj.centerposition = center_position;
            obj.radius = radius
            
        end
    end
end