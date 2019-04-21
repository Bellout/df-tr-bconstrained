function [result] = is_complete(model, prob)
%IS_COMPLETE Summary of this function goes here
%   Detailed explanation goes here

    fprintf('%s\n', 'Calling is_complete');
    [dim, points_num] = size(model.points_abs);
    
    max_terms = ((dim + 1)*(dim + 2))/2;
    max_terms_unused = length(model.pivot_polynomials);
    
    result = points_num >= max_terms;
    if points_num > max_terms
        warning('cmg:possible_error', 'Too many points');
    end

    part=71; subp=1; print_soln_body;

end

