function [p prob] = zero_at_point(p1, p2, x, prob)
% ZERO_AT_POINT - subtract polynomials 
% so that the result is zero at x
%
prob.cf = 'zero_at_point';

p = p1;
[px prob] = evaluate_polynomial(p, x, prob);
[p2x prob] = evaluate_polynomial(p2, x, prob);

iter = 1;
while px ~= 0
    p = add_p(p, multiply_p(p2, -px/p2x));
    [px prob] = evaluate_polynomial(p, x, prob);
    if iter >= 2
        break
    end
    iter = iter + 1;
end

end
