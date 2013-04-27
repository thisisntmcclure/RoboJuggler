function policy = controlPolicy1(params)
    function dtheta = control(t,state,airborn)
        r = state(1);
        dr = state(2);
        theta = state(3);

        g = params.g;
        B = params.m/(params.I/params.r^2 + params.m);

        input = @(t) 2*sin(t)*cos(t);
        dtheta = sqrt(g*sin(theta)+input(t)/B);
    end
    policy = @control;
end