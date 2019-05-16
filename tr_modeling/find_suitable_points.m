function [new_point, new_value, prob] = find_suitable_points(polynomial, bl, bu, attempt, prob)

  % ----------------------------------------------------------------
  if attempt == 1
      % Minimize inside TR
      [new_point, new_value] = ...
         minimize_polynomial_with_bounds(polynomial, bl, bu, smaller_radius);

  % ----------------------------------------------------------------
  elseif attempt == 2
      % Maximize inside TR
      [new_point, new_value] = ...
          minimize_polynomial_with_bounds(multiply_p(polynomial, -1, prob), bl, bu, smaller_radius);

  % ----------------------------------------------------------------
  elseif attempt == 3
      % Minimize in larger region
      [new_point, new_value] = minimize_polynomial_with_bounds(polynomial, bl, bu, 1);

  % ----------------------------------------------------------------
  elseif attempt == 4
      % Maximize in larger region
      [new_point, new_value] = ...
          minimize_polynomial_with_bounds(multiply_p(polynomial, -1, prob), bl, bu, 1);

  % ----------------------------------------------------------------
  elseif attempt == 5
      fprintf(prob.fid_coefficientsToMatrices, ...
      [ '[ --> ' pad('findSuitablePoints()', 38) ']' ]);
      [cp, gp, Hp] = coefficients_to_matrices(polynomial.dimension, polynomial.coefficients);

      if norm(gp, inf) == 0
          new_point = gp;
          fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=5a] ] ']);
          [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);
      else
          new_point = round(gp/max(gp));
          new_point = new_point/norm(new_point);
          new_point = min(bu, max(bl, new_point));
          fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=5b] ] ']);
          [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);
      end

  % ----------------------------------------------------------------
  elseif attempt == 6
      fprintf(prob.fid_coefficientsToMatrices, ...
      [ '[ --> ' pad('findSuitablePoints()', 38) ']' ]);    
      [cp, gp, Hp] = coefficients_to_matrices(polynomial.dimension, polynomial.coefficients);

      if norm(gp, inf) == 0
          new_point = gp;
          fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=6a] ] ']);
          [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);
      else
          new_point = round(gp/max(gp));
          new_point = -new_point/norm(new_point);
          new_point = min(bu, max(bl, new_point));
          fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=6b] ] ']);
          [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);
      end

  else

      fprintf(prob.fid_coefficientsToMatrices, ...
      [ '[ --> ' pad('findSuitablePoints()', 38) ']' ]);
      [cp, gp, Hp] = coefficients_to_matrices(polynomial.dimension, polynomial.coefficients);
      [~, v1] = max(Hp, [], 1);
      [~, v2] = max(Hp, [], 2);
      if v1 ~= v2
          attempt = attempt + 2;
      end

      if attempt == 7
          new_point = zeros(dim, 1);
          new_point(v1) = min(bu(v1), max(bl(v1), 1));
          fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=7] ]  ']);
          [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);

      elseif attempt == 8
          new_point = zeros(dim, 1);
          new_point(v1) = min(bu(v1), max(bl(v1), -1));
          fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=8] ]  ']);
          [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);
      elseif attempt == 9

      end

  % ----------------------------------------------------------------
  elseif attempt == 8
      fprintf(prob.fid_coefficientsToMatrices, ...
      [ '[ --> ' pad('findSuitablePoints()', 38) ']' ]);    
      [cp, gp, Hp] = coefficients_to_matrices(polynomial.dimension, polynomial.coefficients);
      [~, v1] = max(Hp, [], 1);
      [~, v2] = max(Hp, [], 2);

      new_point = zeros(dim, 1);
      new_point(v2) = min(bu(v2), max(bl(v2), 1));
      fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=8] ]  ']);
      [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);

  % ----------------------------------------------------------------
  elseif attempt == 9
      if v1 == v2
          continue
      end
      new_point = zeros(dim, 1);
      new_point(v1) = 1/sqrt(2);
      new_point(v2) = 1/sqrt(2);
      new_point = min(bu, max(bl, 1));
      fprintf(prob.fid_evaluatePolynomial, ['[ --> findSuitablePoints() [att=9] ]  ']);
      [new_value prob] = evaluate_polynomial(polynomial, new_point, prob);
  else
      error('cmg:pivot_not_found', 'Pivot not found');
  end
end