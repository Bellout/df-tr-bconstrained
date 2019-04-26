function [p prob] = combine_polynomials(polynomials, coefficients, prob)

    % fprintf('%s\n', 'Calling combine_polynomials');
    terms = length(polynomials);
    if terms == 0 || length(coefficients) ~= terms
        error();
    end

    [p prob] = multiply_p(polynomials(1), coefficients(1), prob);
    for k = 2:terms
        [p prob] = add_p(p, multiply_p(polynomials(k), coefficients(k), prob), prob);
    end

end