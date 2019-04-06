function [polynomial, prob] = ...
  normalize_polynomial(polynomial, point, prob)

    [val prob] = evaluate_polynomial(polynomial, point, prob);
    for k = 1:3
        polynomial = multiply_p(polynomial, 1/val);
        [val prob] = evaluate_polynomial(polynomial, point, prob);
        if ((val - 1) == 0)
            break
        end
    end