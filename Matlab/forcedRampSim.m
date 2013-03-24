function forcedRampSim
    %define parameters
    m = 0.010;
    r = 0.026;
    I = 2/3*m*r^2;%thin walled ball
    g = 9.81;
    params = struct('m',m,'r',r,'I',I,'g',g);
    
    %define problem
    V0 = [7.2;0;0];
    tspan = [0 10];
    rampPolicy = @(t, state) cos(t);
    derivatives = @(t,state) ballDynamics(t,state,params,rampPolicy);
    
    %solve the problem
    [T, V] = ode45(derivatives,tspan,V0);
    
    %plot the solution
    r = V(:,1);theta = V(:,3);
    x = r.*cos(theta); y = r.*sin(theta);
    animateBall(T,x,y)
end