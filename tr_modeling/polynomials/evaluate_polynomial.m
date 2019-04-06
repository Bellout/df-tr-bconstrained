function [ value prob ] = evaluate_polynomial(polynomial, point, prob)
% Evaluates polynomial in given point

[ nr nc ] = size(polynomial.coefficients);

% ----------------------------------------------------------
if (~strcmp(prob.cf_prev, prob.cf))
  fprintf(prob.fidpc, '[ %s (%s)]\n', prob.cf, prob.cf_prev);
end
prob.cf_prev = prob.cf;
% fprintf(prob.fidpc, [ repmat('%20.16f ', 1, nr) '\n'] , polynomial.coefficients);
fprintf(prob.fidpc, [ repmat('%22.12e ', 1, nr) '\n'] , polynomial.coefficients);

% ----------------------------------------------------------
[c, g, H] = coefficients_to_matrices(polynomial.dimension, ...
                                     polynomial.coefficients);

terms = [c, g'*point, 0.5*(point'*H*point)];
terms = sort(terms);

value = (terms(1) + terms(2)) + terms(3);


end

