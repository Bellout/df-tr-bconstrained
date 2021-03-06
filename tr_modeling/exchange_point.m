function [model, succeeded, pt_i, prob] = ...
    exchange_point(model, new_point, new_fvalues, ...
                   relative_pivot_threshold, prob)

  pivot_threshold = min(1, model.radius)*relative_pivot_threshold;

  [dim, last_p] = size(model.points_abs);
  pivot_polynomials = model.pivot_polynomials;
  center_i = model.tr_center;

  % --------------------------------------------------------
  if last_p >= 2

    shift_center = model.points_abs(:, 1);
    new_point_shifted = new_point - shift_center;
    points_shifted = model.points_shifted;
    if last_p <= dim + 1
        block_beginning = 2;
        block_end = min(dim+1, last_p);
    else
        block_beginning = dim+2;
        block_end = last_p;
    end

    % ------------------------------------------------------
    max_val = 0;
    max_poly_i = 0;

    % ------------------------------------------------------
    for poly_i = block_end:-1:block_beginning
      if poly_i ~= center_i

        fprintf(prob.fid_evaluatePolynomial, ...
                [ '[ --> ' pad('exchangePoint()', 38) ']\n' ]);        
        [temp_val prob] = ...
        evaluate_polynomial(pivot_polynomials(poly_i), ...
                            new_point_shifted, ...
                            prob);
        val = model.pivot_values(poly_i)*temp_val;

        if abs(max_val) < abs(val)
            max_val = val;
            max_poly_i = poly_i;
        end
      end
    end
    new_pivot_val = max_val;

    % ------------------------------------------------------
    if abs(new_pivot_val) > pivot_threshold
      points_shifted(:, max_poly_i) = new_point_shifted;

      % ----------------------------------------------------
      % Normalize polynomial value
      fprintf(prob.fid_normalizePolynomial, ...
              [ '[ --> ' pad('exchangePoint()', 38) ']\n' ]);      
      [pivot_polynomials(max_poly_i) prob] = ...
      normalize_polynomial(pivot_polynomials(max_poly_i), ...
                           new_point_shifted, ...
                           prob);

      % ----------------------------------------------------
      % Re-orthogonalize
      [pivot_polynomials(max_poly_i) prob] = ...
      orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                         max_poly_i, ...
                                         points_shifted, ...
                                         last_p, ...
                                         prob);

      % ----------------------------------------------------
      % Orthogonalize polynomials on present block (until end)
      [pivot_polynomials prob] = orthogonalize_block(pivot_polynomials, ...
                                              new_point_shifted, ...
                                              max_poly_i, ...
                                              block_beginning, ...
                                              last_p, ...
                                              prob);

      % ----------------------------------------------------
      % Update model
      model.cached_points = [model.points_abs(:, max_poly_i), model.cached_points];
      model.cached_fvalues = [model.fvalues(:, max_poly_i), model.cached_fvalues];

      model.points_abs(:, max_poly_i) = new_point;
      model.fvalues(:, max_poly_i) = new_fvalues;
      model.points_shifted = points_shifted;

      model.pivot_polynomials = pivot_polynomials;
      model.pivot_values(:, max_poly_i) = new_pivot_val;
      model.modeling_polynomials = {};
      succeeded = true;
      pt_i = max_poly_i;

    else
      succeeded = false;
      pt_i = 0;
    end
  else
    succeeded = false;
    pt_i = 0;
    warning('cmg:runtime', 'Error here');
  end

