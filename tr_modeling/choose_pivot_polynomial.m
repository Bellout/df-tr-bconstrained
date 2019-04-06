function [pivot_polynomials, pivot_value, success, prob] = ...
    choose_pivot_polynomial(pivot_polynomials, points, ...
                            initial_i, final_i, tol, prob)

    last_point = initial_i - 1;
    incumbent_point = points(:, initial_i);
    success = false;
    pivot_value = 0;
    for k = initial_i:final_i
        [polynomial prob] = ...
        orthogonalize_to_other_polynomials(pivot_polynomials, k, ...
                                           points, last_point, prob);
        [val prob] = evaluate_polynomial(polynomial, ...
                                         incumbent_point, ...
                                         prob);
        if abs(val) > tol
            % Accept polynomial
            success = true;
            % Swap polynomials
            pivot_polynomials(k) = pivot_polynomials(initial_i);
            pivot_polynomials(initial_i) = polynomial;
            pivot_value = val;
            break
        else
            false; % We won't even save the orthogonalization
        end
    end
    

end