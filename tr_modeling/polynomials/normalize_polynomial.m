function [polynomial, prob] = ...
  normalize_polynomial(polynomial, point, prob)


% --------------------------------------------------------------------
fprintf(prob.fid_evaluatePolynomial, [ '[ --> ' pad('normalizePolynomial()[a]', 38) ']' ]);
[val prob] = evaluate_polynomial(polynomial, point, prob);

% --------------------------------------------------------------------
for k = 1:3

  [polynomial prob] = multiply_p(polynomial, 1/val, prob);
  fprintf(prob.fid_evaluatePolynomial, [ '[ --> ' pad('normalizePolynomial()[b]', 38) ']' ]);
  [val prob] = evaluate_polynomial(polynomial, point, prob);

  if ((val - 1) == 0)
    break
  end
end