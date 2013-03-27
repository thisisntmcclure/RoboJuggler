function derivatives = projectileDynamics(t, state, params, ramp_policy)
    %unpack information
    g = params.g;
    v = state([2 4]);
    
    %calculate derivatives
    dx_dt = v;
    dv_dt = [0 -g];
    dtheta_dt = ramp_policy(t, state);
    
    derivatives = [dx_dt(1); dv_dt(1); dx_dt(2); dv_dt(2); dtheta_dt];
end