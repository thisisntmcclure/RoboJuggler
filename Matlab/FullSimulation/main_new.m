function main_new
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
                    'tspan',[0,3],...
                    'rampPolicy',@(t, state, airborne) 12*cos(13*t));
                
    tilt = struct('V0',[1;0;1],...
                    'tspan',[0,3],...
                    'rampPolicy',@(t, state, airborne) 0);
                
    [t,x,y,theta,xe,ye]=fullSim(params, toss);
    animateRamp(t,x,y,theta,params.l)
    plot(xe,ye,'ro'); hold on
%     plot(x,y,'.-')
end