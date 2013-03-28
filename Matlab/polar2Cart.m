%Transforms the polar coordinates, velocities and accelerations into
%cartesian coordinates velocities and accelerations
function varargout = polar2Cart(varargin)
    %initialize all of the non initialized variables to zero
    for i=nargin+1:6
        varargin{i} = 0;
    end
    %unpack variables
    r = varargin{1}; theta = varargin{2};
    dr = varargin{3}; dtheta = varargin{4};
    d2r = varargin{5}; d2theta = varargin{6};
    
    %coordinate transformation
    x = r.*cos(theta);
    y = r.*sin(theta);
    %derivative transformation
    dx = dr.*cos(theta) - r.*sin(theta).*dtheta;
    dy = dr.*sin(theta) + r.*cos(theta).*dtheta;
    %second derivative transformation
    d2x = d2r.*cos(theta) - 2*dr.*dtheta.*sin(theta)...
        - r.*d2theta.*sin(theta) - r.*dtheta.^2.*cos(theta);
    d2y = d2r.*sin(theta) + 2*dr.*dtheta.*cos(theta)...
        + r.*d2theta.*cos(theta) - r.*dtheta.^2.*sin(theta);
    
    %pack the variables again
    state = {x, y, dx, dy, d2x, d2y};
    varargout = {};
    for i=1:nargin
        varargout{i} = state{i};
    end
end