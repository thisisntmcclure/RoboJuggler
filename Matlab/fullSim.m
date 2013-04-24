function [t_total, x_total, y_total, theta_total, x_events, y_events] = fullSim(params, problem)
    %extract the problem
    V0 = problem.V0;
    tspan = problem.tspan;
    rampPolicy = problem.rampPolicy;
    
    x_total = [];
    y_total = [];
    theta_total = [];
    t_total = [];
    x_events = [];
    y_events = [];
    airborne = false;
    while true
        %redefine the policy based on if the ball is airborne
        rPolicy = @(t,state) rampPolicy(t,state,airborne);
        
        if airborne
            events = @(t,state) projectileEvents(t,state,params,rPolicy);
            derivatives = @(t,state) projectileDynamics(t,state,params,rPolicy);
        else
            events = @(t,state) rampEvents(t,state,params,rPolicy);
            derivatives = @(t,state) rampDynamics(t,state,params,rPolicy);
        end
        options = odeset('Events',events,'MaxStep',.002);
        
        [T, V, ~, VE, IE] = ode45(derivatives,tspan,V0,options);
        
        %append the new data to the old data
        t_total = vertcat(t_total,T); %#ok<*AGROW>
        if airborne
            x_new = V(:,1); y_new = V(:,2);
        else
            [x_new, y_new] = polar2Cart(V(:,1),V(:,3));
        end
        x_total = vertcat(x_total, x_new);
        y_total = vertcat(y_total, y_new);
        theta_total = vertcat(theta_total, V(:,end));
        
        %check exit condition
        if size(IE)
            abs(x_total(end))- params.l < 0
            tspan = [T(end)+.0001 tspan(end)];
            if airborne
                %extract events
                x_events_new = VE(end,1);
                y_events_new = VE(end,2);
                %determine initial condition
                x0 = V(end, 1); y0 = V(end, 2);
                dx0 = V(end, 3); dy0 = V(end, 4);
                theta0 = V(end, 5);
                [r0,~,dr0,~] = cart2Polar(x0,y0,dx0,dy0);
                V0 = [r0,dr0,theta0];
            else
                %extract events
                [x_events_new, y_events_new] = polar2Cart(VE(end,1),VE(end,3));
                %determine initial condition
                r0 = V(end, 1); theta0 = V(end, 3);
                dr0 = V(end, 2); dtheta0 = rPolicy(T(end),V(end,:));
                [x0, y0, dx0, dy0] = polar2Cart(r0, theta0, dr0, dtheta0);
                V0 = [x0,y0,dx0,dy0,theta0];
            end
            %log events
            x_events = vertcat(x_events, x_events_new);
            y_events = vertcat(y_events, y_events_new);
            
            if airborne
                switch IE(end)
                    case 1
                        %escaped the boundaries
                        disp('The ball escaped the boundaries')
                        break
                    case 2
                        %collided with the ramp again
                        disp('The ball collided with the ramp again')
                        %TODO: deal with the case when the ball collides
                        %with the ramp again
                end
            else
                switch IE(end)
                    case 1
                        %Left the ramp
                        disp('The ball left the ramp')
                    case 2
                        %Escaped the ramp
                        disp('The ball escaped the ramp')
                        break
                        %TODO: deal with the case when the ball collides
                        %with the ramp again
                end
            end
            airborne = ~airborne;
        else
            break%exit the loop if the whole simulation has finished
        end
    end
end

function [value, terminal, direction] = rampEvents(t,state,params,rampPolicy)
    value = []; terminal = []; direction = [];

    r = state(1);
    
    %condition for the ball flying off of the ramp
    value(1) = constraintForce(t,state,params,rampPolicy);
    terminal(1) = 1;
    direction(1) = -1;

    %condition for the ball falling off of the end of the ramp
    value(2) = abs(r)-params.l;
    terminal(2) = 1;
    direction(2) = 1;
end

function [value, terminal, direction] = projectileEvents(~,state,params,~)
    value = []; terminal = []; direction = [];
    
    x = state(1); y = state(2);
    theta = state(5);
    
    %condition for the ball escaping the boundaries
    value(1) = abs(x) - params.l;
    terminal(1) = 1;
    direction(1) = 1;

    %condition for the ball colliding with the ramp again
    if abs(x)<params.l*cos(theta)
        value(2) = y - tan(theta)*x;%vertical distance to the ramp
    else
        value(2) = norm([x y]-params.l*[cos(theta)*sign(x) sin(theta)]);
    end
    terminal(2) = 1;
    direction(2) = -1;
end