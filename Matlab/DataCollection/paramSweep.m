function [velocities, stopAngles, distances] = paramSweep
    %define constant parameters
    m = 0.010;
    r = 0.026;
    I = 2/3*m*r^2;%moment of inertia of a thin walled ball
    g = 9.81;
    l = 0.15;%half length of the ramp 
    params = struct('m',m,'r',r,'I',I,'g',g,'l',l);
    addpath('../')
    velocities = linspace(10,20,100);
    stopAngles = linspace(.01,pi/2-.1,100);
    distances = zeros(length(velocities),length(stopAngles));
    for v = 1:length(velocities)
        disp(num2str(v))
        for a = 1:length(stopAngles)
            problem = struct('V0',[.07;0;0],...
                            'tspan',[0,10],...
                            'rampPolicy',@(t, state, airborne) rampPolicy(t,state,airborne,velocities(v),stopAngles(a)));

            [~,x,~,~,~,~]=twoRampSim(params, problem);
            distances(v,a) = x(end);
        end
    end
    pcolor(stopAngles,velocities,distances)
end

function dtheta = rampPolicy(t,~,~,velocity,stopAngle)
    if (t < (stopAngle/velocity))
        dtheta = velocity; 
    else
        dtheta = 0;
    end
end