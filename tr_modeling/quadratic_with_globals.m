function [f, df] = quadratic_with_globals(x)

    global H
    global g
    global c
    
    [f, df] = quadratic(H, g, c, x);
    
end
    
    