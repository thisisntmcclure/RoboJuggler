%Transforms the cartesian coordinates, velocities and accelerations into
%polar coordinates velocities and accelerations
function varargout = cart2Polar(varargin)
    %initialize all of the non initialized variables to zero
    for i=nargin+1:6
        varargin{i} = 0;
    end
    %unpack variables
    x = varargin{1}; y = varargin{2};
    dx = varargin{3}; dy = varargin{4};
    d2x = varargin{5}; d2y = varargin{6};
    
    %coordinate transformation
    r = sqrt(x.^2+y.^2)*sign(cos(x));
    theta = atan(y./x);
    %derivative transformation
    dr = (x.*dx + y.*dy)./r;
    dtheta = (x.*dy - dx.*y)./r.^2;
    %second derivative transformation
    d2r = (dx.^2 + x.*d2x + dy.^2 + y.*d2y)./r - dr.^2./r;
    d2theta = (x.*d2y - y.*d2x)./r.^2 - 2*dtheta.*dr./r;
    
    %pack the variables again
    state = {r, theta, dr, dtheta, d2r, d2theta};
    varargout = {};
    for i=1:nargin
        varargout{i} = state{i};
    end
end