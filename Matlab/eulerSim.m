function eulerSim
    %parameters
    m = 0.010;
    r = 0.026;
    I = 2/3*m*r^2;%moment of inertia of a thin walled ball
    g = 9.81;
    l = 2;%0.15;%half length of the ramp 
    params = struct('m',m,'r',r,'I',I,'g',g,'l',l);
    
    %initial condition
    r0 = 0;
    dr0 = 0;
    theta0 = 0;
    initState = [r0 dr0 theta0];
    
    %define the time series
    tspan = 0:.01:16;
    dt = tspan(2) - tspan(1);
    
    %allocate memory for the state list
    states = zeros(length(tspan),3);
    states(1,:) = initState;
    
    for i = 2:length(tspan)
        states(i-1,:)
        states(i,:) = states(i-1,:) + derivatives(params,tspan(1:i-1),states(1:i-1,:),@policy)*dt;
    end
    
    r = states(:,1);
    theta = states(:,3);
    x = r.*cos(theta);
    y = r.*sin(theta);
    figure(1)
    animateRamp(tspan,x,y,theta,params.l)
    figure(2)
    plot(tspan,r)
end

function dstate = derivatives(params,times,stateList,policy)
    %unpack data
    g = params.g; I = params.I; b = params.r; m = params.m;
    r = stateList(end,1); dr = stateList(end,2); theta = stateList(end,3);
    
    %compute derivatives
    dtheta = policy(params,times,stateList);
    d2r = (r*dtheta^2 - g*sin(theta))/(1+I/(m*b^2));
    
    dstate = [dr d2r dtheta];
end

function dtheta = policy(params,times,stateList)
    input = @(t) params.l/2;
    %system control
    if (length(times)>=2)
        dinput = (input(times(end))-input(times(end-1)))/(times(end)-times(end-1));
    else
        dinput = 0;
    end
    if (length(times)>=3)
        d2input = (input(times(end-1))-input(times(end-2)))/(times(end-1)-times(end-2));
        d2input = (dinput-d2input)/(times(end)-times(end-1));
    else
        d2input = 0;
    end
    %system output
    r = stateList(end,1);
    dr = stateList(end,2);
    if (length(times)>=2)
        d2r = (stateList(end,2)-stateList(end-1,2))/(times(end)-times(end-1));
    else
        d2r = 0;
    end
    if (length(times)>=3)
        d3r = (stateList(end-1,2)-stateList(end-2,2))/(times(end-1)-times(end-2));
        d3r = (d2r-d3r)/(times(end)-times(end-1));
    else
        d3r = 0;
    end
    err = input(times(end))-r;
    derr = dinput-dr;
    d2err = d2input-d2r;
    dtheta = -err+dr+d2r;
end