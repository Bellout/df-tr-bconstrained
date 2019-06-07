function [model, exitflag, prob] = add_point(model, new_point, ...
    new_fvalues, relative_pivot_threshold, prob)

  % ------------------------------------------------------------------
  fprintf('%s\n', 'Calling add_point');
  pivot_threshold = min(1, model.radius)*relative_pivot_threshold;
  
  [dim, last_p] = size(model.points_abs);
  pivot_polynomials = model.pivot_polynomials;
  polynomials_num = length(model.pivot_polynomials);
  
  % ------------------------------------------------------------------
  if last_p >= 1
      shift_center = model.points_abs(:, 1);
      new_point_shifted = new_point - shift_center;
      points_shifted = [model.points_shifted, new_point_shifted];
  else
      false; % should this ever happen?
  end

  part=77; subp=1; print_soln_body;

  % ------------------------------------------------------------------  
  next_position = last_p+1;
  if next_position == 1
    % Should be rebuilding model!!!
    model.tr_center = 1;
    pivot_polynomials = band_prioritizing_basis(dim);
    exitflag = 1;
    warning('cmg:no_point', ['TR model had no point. '...
            'This should never happen']);

  elseif next_position <= polynomials_num
    if next_position <= dim+1
      % Add to linear block
      block_beginning = 2;
      block_end = dim+1;
    else
      % Add to quadratic block
      block_beginning = dim+2;
      block_end = polynomials_num;
    end

    % ----------------------------------------------------------------
    [pivot_polynomials, pivot_value, success, prob] = ...
    choose_pivot_polynomial(pivot_polynomials, ...
                            points_shifted, ...
                            next_position, ...
                            block_end, ...
                            pivot_threshold,...
                            prob);

    % ----------------------------------------------------------------
    if success
      % Normalize polynomial value
      fprintf(prob.fid_normalizePolynomial, ...
              [ '[ --> ' pad('addPoint()', 38) ']\n' ]);
      [pivot_polynomials(next_position) prob] = ...
      normalize_polynomial(pivot_polynomials(next_position), ...
                           new_point_shifted, ...
                           prob);

      % --------------------------------------------------------------
      % Re-orthogonalize
      [pivot_polynomials(next_position) prob] = ...
      orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                         next_position, ...
                                         points_shifted, ...
                                         next_position-1, ...
                                         prob);
      
      % --------------------------------------------------------------
      % Orthogonalize polynomials on present block (deffering
      % subsequent ones)
      [pivot_polynomials prob] = orthogonalize_block(pivot_polynomials, ...
                                              new_point_shifted, ...
                                              next_position, ...
                                              block_beginning, ...
                                              next_position-1, ...
                                              prob);
      exitflag = 1;
    else
      exitflag = 0;
    end

  else
    % Model is full. Should remove another 
    % point to add this one
    exitflag = 0;
  end

  % ------------------------------------------------------------------
  if exitflag > 0
    points_shifted(:, next_position) = new_point_shifted;
    fvalues = model.fvalues;
    fvalues(:, next_position) = new_fvalues;
    points_abs = model.points_abs;
    points_abs(:, next_position) = new_point;
    model.modeling_polynomials = {};

    model.points_abs = points_abs;
    model.fvalues = fvalues;
    model.points_shifted = points_shifted;
    model.pivot_polynomials = pivot_polynomials;
    model.pivot_values(:, next_position) = pivot_value;
  end

end