function Q = constraintForce(t,state,params,rampPolicy)
    %extract state information
    x = state(1,:)';
    v = state(2,:)';
    theta = state(3,:)';
    omega = rampPolicy(t,state);
    alpha = (rampPolicy(t+.001,state)-rampPolicy(t-.001,state))/.002;
    %extract parameter information
    m = params.m;
    g = params.g;
    
    %calculate contraint torque
    Q = m*x.^2.*alpha + 2*m*x.*v.*omega + m*g*x.*cos(theta);
    %account for the ball crossing the pivot point
    %(torque goes to zero and switches signs)
    Q = sign(x).*Q;
end