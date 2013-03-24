function animateBall(t,x,y)

    %interpolate data
    tq = linspace(min(t),max(t));
    x = interp1(t,x,tq);
    y = interp1(t,y,tq);
    t = tq/max(t);%speed up the playback
    
    %first plot
    axis equal; hold on
    plot(x,y)
    plot(x(1),y(1),'o')
    
    %next plots
    for i=2:length(t)
        pause(t(i)-t(i-1))
        plot(x(i),y(i),'o')
    end
end