%%Defines the dynamics of a ball that is constrained to a ramp that moves
%%according to ramp_policy
function derivatives = rampDynamics(t, state, params, ramp_policy)
    %unpack parameters
    m = params.m;
    b = params.r;
    I = params.I;
    g = params.g;
    
    %unpack state
    r = state(1);
    dr = state(2);
    theta = state(3);
    dtheta = ramp_policy(t, state);
    d2theta = (ramp_policy(t+.001,state)-ramp_policy(t-.001,state))/.002;
    
    %convert, calculate, convert back\
    d2r = (r.*dtheta.^2 - g.*sin(theta))/(1+I/(m*b^2));
    
    derivatives = [dr; d2r; dtheta];
end