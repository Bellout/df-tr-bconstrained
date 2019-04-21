function [polynomials prob] = orthogonalize_block(polynomials, point, np, ...
                                           orth_beginning, orth_end,...
                                           prob)
    if nargin < 5
        % All polynomials from this block and higher
        orth_end = length(polynomials);
    end
        
    for p = orth_beginning:orth_end
        if p ~= np
            [polynomials(p) prob] = zero_at_point(polynomials(p), ...
                                           polynomials(np), ...
                                           point, ...
                                           prob);
        end
    end
    
end
