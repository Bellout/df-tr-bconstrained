function [l_alpha prob] = nfp_finite_differences(points, fvalues, polynomials, prob)

  % ------------------------------------------------------------------
  % Change so we can interpolate more functions at the same time
  [dim, points_num] = size(points);

  l_alpha = fvalues;
  part=70; subp=1; print_soln_body;

  % ------------------------------------------------------------------
  % Remove constant polynomial
  for m = 2 : points_num

     fprintf(prob.fid_evaluatePolynomial, [ '[ --> ' pad('nfpFiniteDifferences()[a]', 38) ']' ]);     
     [val prob] = evaluate_polynomial(polynomials(1), points(:, m), prob);
     l_alpha(:, m) = l_alpha(:, m) - l_alpha(:, 1)*val;
  end

  part=70; subp=2; print_soln_body;
  % ------------------------------------------------------------------
  % Remove terms corresponding to degree 1 polynomials
  for m = dim+2 : points_num
    for n = 2 : dim + 1
      fprintf(prob.fid_evaluatePolynomial, [ '[ --> ' pad('nfpFiniteDifferences()[b]', 38) ']' ]);
      [val prob] = evaluate_polynomial(polynomials(n), points(:, m), prob);

      part=70; subp=3; print_soln_body;
      l_alpha(:, m) = l_alpha(:, m) - l_alpha(:, n)*val;
    end
  end

  part=70; subp=4; print_soln_body;
    
end
    