function [model, exitflag, prob] = add_point(model, new_point, ...
    new_fvalues, relative_pivot_threshold, prob)

  % ------------------------------------------------------------------
  fprintf('%s\n', 'Calling add_point');
  pivot_threshold = min(1, model.radius)*relative_pivot_threshold;
  
  [dim, last_p] = size(model.points_abs);
  pivot_polynomials = model.pivot_polynomials;
  polynomials_num = length(model.pivot_polynomials);
  
  % ------------------------------------------------------------------
  cA = (last_p >= 1);
  if cA
      shift_center = model.points_abs(:, 1);
      new_point_shifted = new_point - shift_center;
      points_shifted = [model.points_shifted, new_point_shifted];
  else
      false; % should this ever happen?
  end
  % ------------------------------------------------------------------  
  next_position = last_p + 1;

  cB = (next_position == 1);
  part=77; subp=1; print_soln_body;
  % pivot_threshold, new_point_shifted, shift_center, points_shifted


  cC = (next_position <= polynomials_num);
  cD = (next_position <= dim+1);

  if cB
    % Should be rebuilding model!!!
    model.tr_center = 1;
    pivot_polynomials = band_prioritizing_basis(dim);
    exitflag = 1;
    warning('cmg:no_point', ['TR model had no point. '...
            'This should never happen']);

    part=77; subp=2; print_soln_body;

  elseif cC

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
    fprintf(prob.fid_choosePivotPolynomial, ...
            [ '[ --> ' pad('addPoint()', 38) ']' ]);    
    [pivot_polynomials, pivot_value, success, prob] = ...
    choose_pivot_polynomial(pivot_polynomials, ...
                            points_shifted, ... points
                            next_position, ... initial_i <--- !!!!
                            block_end, ... final_i
                            pivot_threshold,... tol
                            prob);

    part=77; subp=3; print_soln_body;

    % ----------------------------------------------------------------
    if success
      % Normalize polynomial value
      fprintf(prob.fid_normalizePolynomial, ...
              [ '[ --> ' pad('addPoint()', 38) ']\n' ]);
      [pivot_polynomials(next_position) prob] = ...
      normalize_polynomial(pivot_polynomials(next_position), ...
                           new_point_shifted, ...
                           prob);

      part=77; subp=4; print_soln_body;

      % --------------------------------------------------------------
      % Re-orthogonalize
      fprintf(prob.fid_orthogonalizeToOtherPolynomials, ...
              [ '[ --> ' pad('addPoint()', 38) ']' ]);      
      [pivot_polynomials(next_position) prob] = ...
      orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                         next_position, ...
                                         points_shifted, ...
                                         next_position-1, ...
                                         prob);

      part=77; subp=5; print_soln_body;
      
      % --------------------------------------------------------------
      % Orthogonalize polynomials on present block (deffering
      % subsequent ones)    
      fprintf(prob.fid_orthogonalizeBlock, ...
              [ '[ --> ' pad('addPoint()', 38) ']\n' ]);      
      [pivot_polynomials prob] = orthogonalize_block(pivot_polynomials, ...
                                              new_point_shifted, ...
                                              next_position, ...
                                              block_beginning, ...
                                              next_position-1, ...
                                              prob);

      exitflag = 1;
      part=77; subp=6; print_soln_body;

    else
      exitflag = 0;
    end

    part=77; subp=7; print_soln_body;

  else
    % Model is full. Should remove another 
    % point to add this one
    exitflag = 0;
    part=77; subp=8; print_soln_body;

  end

  % ------------------------------------------------------------------
  if exitflag > 0
    
    % Add values to vectors/matrices
    points_shifted(:, next_position) = new_point_shifted;
    
    fvalues = model.fvalues;
    fvalues(:, next_position) = new_fvalues;

    points_abs = model.points_abs;
    points_abs(:, next_position) = new_point;

    % empty modeling polynomials
    model.modeling_polynomials = {};

    % Uploaded updated vectors/matrices to model struc
    model.points_abs = points_abs;
    model.fvalues = fvalues;
    model.points_shifted = points_shifted;
    model.pivot_polynomials = pivot_polynomials;
    model.pivot_values(:, next_position) = pivot_value;

  end

part=77; subp=9; print_soln_body;

end