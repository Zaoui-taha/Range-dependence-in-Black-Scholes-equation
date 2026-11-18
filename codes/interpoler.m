% Interpolation function at time t :

    function z = interpoler(y, t, x, u) 
        if y <= x(1)
            z = u(t,1);
        elseif y >= x(end)
            z = u(t,end);
        else
            i = find(x <= y, 1, 'last');
            alpha = (y - x(i)) / (x(i+1) - x(i));
            z = (1 - alpha) * u(t, i) + alpha * u(t, i + 1);
        end    
    end