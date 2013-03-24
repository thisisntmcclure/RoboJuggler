function forcedRampSim_term
    %define parameters
    m = 0.010;
    r = 0.026;
    I = 2/3*m*r^2;%moment of inertia of a thin walled ball
    g = 9.81;
    params = struct('m',m,'r',r,'I',I,'g',g);
    
    %define problem
    V0 = [7.2;0;0];
    tspan = [0 12];
    rampPolicy = @(t, state) cos(t);
    derivatives = @(t,state) ballDynamics(t,state,params,rampPolicy);
    options = odeset('Events',@events);
    
    %solve the problem
    [T, V, TE, VE, ~] = ode45(derivatives,tspan,V0,options);
    
    %plot the solution
    r = V(:,1);theta = V(:,3);
    x = r.*cos(theta); y = r.*sin(theta);
    r_e = VE(:,1);theta_e = VE(:,3);
    x_e = r_e.*cos(theta_e); y_e = r_e.*sin(theta_e);
    figure(1)
    animateBall(T,x,y)
    plot(x_e,y_e,'ro')
    figure(2)
    plot(T,constraintForce(T,V',params,rampPolicy))
    hold on
    plot(TE,constraintForce(TE,VE',params,rampPolicy),'r*')
    
    function [value, terminal, direction] = events(t,state)
        value = []; terminal = []; direction = [];
        %condition for the ball flying off of the ramp
        value(1) = constraintForce(t,state,params,rampPolicy);
        terminal(1) = 0;
        direction(1) = -1;
    end
end