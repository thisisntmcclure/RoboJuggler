function derivatives = projectileDynamics(t, state, params, ramp_policy)
    %unpack information
    g = params.g;
    dx = state([3 4]);
    
    %calculate derivatives
    d2x = [0 -g];
    dtheta_dt = ramp_policy(t, state);
    
    derivatives = [dx(1); dx(2); d2x(1); d2x(2); dtheta_dt];
end