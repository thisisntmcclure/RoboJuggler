function animateRamp(t,x,y,theta,ramp_length)

    axis equal; hold on
    plot(x,y,'.')
    %interpolate data
    tq = linspace(min(t),max(t));
    x = interp1(t,x,tq);
    y = interp1(t,y,tq);
    theta = interp1(t,theta,tq);
    t = tq/max(t);%speed up the playback
    
    r_x = ramp_length*cos(theta);
    r_y = ramp_length*sin(theta);
    
    %first plot
    xb = x(1); yb = y(1);
    xr = [r_x(1), -r_x(1)];
    yr = [r_y(1), -r_y(1)];
    
    plot(x,y)
    ballHandle = plot(xb,yb,'o','XDataSource', 'xb', 'YDataSource', 'yb');
    rampHandle = plot(xr,yr,'r','XDataSource', 'xr', 'YDataSource', 'yr');
    rampEndHandle = plot(xr,yr,'ro','XDataSource', 'xr', 'YDataSource', 'yr');
    drawnow; axis manual%fix the axes where they are
    
    %next plots
    for i=2:length(t)
        pause(t(i)-t(i-1))
        xb = x(i); yb = y(i);        
        xr = [r_x(i), -r_x(i)];
        yr = [r_y(i), -r_y(i)];
        refreshdata(ballHandle,'caller')
        refreshdata(rampHandle,'caller')
        refreshdata(rampEndHandle,'caller')
        drawnow
%         input('')
    end
end