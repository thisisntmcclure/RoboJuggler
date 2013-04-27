function policy = linearControlPolicy(params)
    function dtheta = control(t,state,airborn)
        r = state(1);
        dr = state(2);
        set = params.l/2;
        err = set-r;
        dtheta = -err + dr
    end
    policy = @control;
end