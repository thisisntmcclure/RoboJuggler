function Q = constraintForce(t,state,params,rampPolicy)
    %extract state information
    r = state(1,:)';
    dr = state(2,:)';
    theta = state(3,:)';
    dtheta = rampPolicy(t,state);
    d2theta = (rampPolicy(t+.001,state)-rampPolicy(t-.001,state))/.002;
    %extract parameter information
    m = params.m;
    g = params.g;
    
    %calculate contraint torque
    Q = m*r.^2.*d2theta + 2*m*r.*dr.*dtheta + m*g*r.*cos(theta);
    %account for the ball crossing the pivot point
    %(torque goes to zero and switches signs)
    Q = sign(r).*Q;
end