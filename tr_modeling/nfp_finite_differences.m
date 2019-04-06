function [l_alpha prob] = nfp_finite_differences(points, fvalues, polynomials, prob)

    % Change so we can interpolate more functions at the same time
    [dim, points_num] = size(points);
    
    l_alpha = fvalues;
    
    % Remove constant polynomial
    for m = 2:points_num
       [val prob] = evaluate_polynomial(polynomials(1), points(:, m), prob);
       l_alpha(:, m) = l_alpha(:, m) - l_alpha(:, 1)*val;
    end
    
    % Remove terms corresponding to degree 1 polynomials
    for m = dim+2:points_num
        for n = 2:dim+1
            [val prob] = evaluate_polynomial(polynomials(n), points(:, m), prob);
            l_alpha(:, m) = l_alpha(:, m) - l_alpha(:, n)*val;
        end
    end
    
end
    