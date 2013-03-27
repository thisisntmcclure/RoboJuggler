function main
    %define parameters
    m = 0.010;
    r = 0.026;
    I = 2/3*m*r^2;%moment of inertia of a thin walled ball
    g = 9.81;
    l = 0.3;%length of the ramp 
    params = struct('m',m,'r',r,'I',I,'g',g,'l',l);
    
    %define problems
    gentleSway = struct('V0',[.15;.1;0],...
                        'tspan',[0,10],...
                        'rampPolicy',@(t, state, airborne) .2*cos(3*t));
    toss = struct('V0',[.20;0;0],...
                    'tspan',[0,4],...
                    'rampPolicy',@(t, state, airborne) 6*cos(6*t));
    
    %run simulation
    x = []; y = [];
    xe = []; ye = [];
    flag = 1;
    airborne = False;
    while flag
        if airborne
            [T, V, VE, flag] = projectileSim(params,toss,false);
            if size(VE)
                xe_i = VE(:,1);
                ye_i = VE(:,3);
            end
        else
            [T, V, VE, flag] = forcedRampSim_term(params,toss,false);
            r = V(:,1);theta = V(:,3);
            xi = r.*cos(theta);
            yi = r.*sin(theta);
            if size(VE)
                r_e = VE(:,1);theta_e = VE(:,3);
                xe_i = r_e.*cos(theta_e);
                ye_i = r_e.*sin(theta_e);
            end
        end
        airborne = ~airborne;
        x = vertcat(x, xi); 
        y = vertcat(y, yi);
        if size(VE)
            xe = vertcat(xe, xe_i);
            ye = vertcat(ye, ye_i);
        end
    end
    
    %plot the solution
    figure(1); clf
    animateRamp(T,x,y,params.l);
    plot(xe,ye,'ro')
    
end