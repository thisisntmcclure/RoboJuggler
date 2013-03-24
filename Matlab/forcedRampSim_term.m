function forcedRampSim_term(params,problem)

    %extract the problem
    V0 = problem.V0;
    tspan = problem.tspan;
    rampPolicy = problem.rampPolicy;
    derivatives = @(t,state) ballDynamics(t,state,params,rampPolicy);
    odeEvts = @(t,state) events(t,state,params,rampPolicy);
    options = odeset('Events',odeEvts);
    
    %solve the problem
    [T, V, TE, VE, ~] = ode45(derivatives,tspan,V0,options);
    
    %plot the solution
    r = V(:,1);theta = V(:,3);
    x = r.*cos(theta); y = r.*sin(theta);
    figure(1); clf
    animateRamp(T,x,y,params.l);
    if size(VE)
        r_e = VE(:,1);theta_e = VE(:,3);
        x_e = r_e.*cos(theta_e); y_e = r_e.*sin(theta_e);
        plot(x_e,y_e,'ro')
    end
    
    %plot the constraint force
    figure(2); clf
    plot(T,constraintForce(T,V',params,rampPolicy))
    hold on
    if size(VE)
        plot(TE,constraintForce(TE,VE',params,rampPolicy),'r*')
    end
end

function [value, terminal, direction] = events(t,state,params,rampPolicy)
    value = []; terminal = []; direction = [];
    %condition for the ball flying off of the ramp
    value(1) = constraintForce(t,state,params,rampPolicy);
    terminal(1) = 0;
    direction(1) = -1;

    %condition for the ball falling off of the end of the ramp
    radius = state(1);
    value(2) = abs(radius)-params.l;
    terminal(2) = 1;
    direction(2) = 0;
end