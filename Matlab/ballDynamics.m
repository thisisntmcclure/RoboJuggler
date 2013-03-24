function derivatives = ballDynamics(t, state, params, ramp_policy)
    m = params.m;
    r = params.r;
    I = params.I;
    g = params.g;
    
    x = state(1);
    v = state(2);
    theta = state(3);
    omega = ramp_policy(t, state);
    
    dx_dt = v;
    dv_dt = (x.*omega.^2 - g.*sin(theta))/(1+I/(m*r^2));
    dtheta_dt = omega;
    
    derivatives = [dx_dt; dv_dt; dtheta_dt];
end