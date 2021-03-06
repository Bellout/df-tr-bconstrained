function [model, model_changed, prob] = rebuild_model(model, options, prob)

  % ------------------------------------------------------------------
  % Region considered to use points
  radius_factor = options.radius_factor;

  % Threshold for pivot polynomials
  pivot_threshold_rel = options.pivot_threshold;
  radius = model.radius;
  pivot_threshold = pivot_threshold_rel*min(1, radius);

  % ------------------------------------------------------------------
  % All points we know
  points_abs = [model.points_abs, model.cached_points];
  fvalues = [model.fvalues, model.cached_fvalues];

  part=116; subp=1; print_soln_body; % setUpTempAllPoints() -- 13

  [dim, p_ini] = size(points_abs); % dimension, number of points

  part=15; subp=1; print_soln_body; % reCenterPoints() -> reBuildModel()







  % ------------------------------------------------------------------
  % Center will be first
  points_abs(:, [1, model.tr_center]) = points_abs(:, [model.tr_center, 1]);
  fvalues(:, [1, model.tr_center]) = fvalues(:, [model.tr_center, 1]);
  
  % Calculate distances
  points_shifted = zeros(dim, p_ini);
  distances = zeros(1, p_ini);
  for n = 2 : p_ini
    % Shift all points to TR center
    % Calculate distances
    points_shifted(:, n) = points_abs(:, n) - points_abs(:, 1);
    distances(n) = norm(points_shifted(:, n), inf); % or 2 norm
  end
  part=16; subp=1; print_soln_body; % reCenterPoints() -> reBuildModel()

  % ------------------------------------------------------------------
  % Reorder
  [distances, pt_order] = sort(distances);
  part=16; subp=2; print_soln_body; % reCenterPoints() -> reBuildModel()

  points_shifted = points_shifted(:, pt_order);
  points_abs = points_abs(:, pt_order);
  fvalues = fvalues(:, pt_order);

  part=16; subp=3; print_soln_body; % reCenterPoints() -> reBuildModel()









  % NEW FUNCTION: rowPivotGaussianElimination()


  % ------------------------------------------------------------------
  % Building model
  pivot_polynomials = nfp_basis(dim, prob); % Basis of Newton
                                      % Fundamental Polynomials



                                      
  polynomials_num = length(pivot_polynomials);
  pivot_values = zeros(1, polynomials_num);

  % ------------------------------------------------------------------
  % Constant term
  last_pt_included = 1;
  pivot_values(1) = 1;  % pivot_values_(0) = 1;
  poly_i = 2;  % int poly_i = 1;

  part=17; print_soln_body;

  for iter = 2 : polynomials_num % int iter = 1; iter < polynomials_num; iter++
    % [2 3 4 5 6]; [1 2 3 4 5]

    % Gaussian elimination (using previuos points)
    fprintf(prob.fid_orthogonalizeToOtherPolynomials, ...
            [ '[ --> ' pad('rowPivotGaussianElimination()[a]', 38) ']' ]);    
    [pivot_polynomials(poly_i) prob] = ...
        orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                           poly_i, ...
                                           points_shifted, ...
                                           last_pt_included, ...
                                           prob);

    part=18; print_soln_body;

    % ----------------------------------------------------------------
    if poly_i <= dim + 1 % poly_i <= dim

      block_beginning = 2; % block_beginning = 1;
      block_end = dim + 1; % block_end = dim;

      % --------------------------------------------------------------
      % Linear block (we allow more points (*2))
      maxlayer = min(2*radius_factor, distances(end)/radius);

      str_blck = 'Linear block (we allow more points (*2))';
      part=19; subp=1; print_soln_body;

      if iter > dim + 1 % iter > dim
        % We already tested all linear terms
        % We do not have points to build a FL model
        % How did this happen??? see Comment [1]
        break
      end

    else

      % --------------------------------------------------------------
      % Quadratic block -- being more careful
      maxlayer = min(radius_factor, distances(end)/radius);
      block_beginning = dim + 2; % block_beginning = dim + 1;
      block_end = polynomials_num; % block_end = polynomials_num - 1;

      str_blck = 'Quadratic block (being more careful)';
      part=19; subp=2; print_soln_body;

    end

    % ----------------------------------------------------------------
    maxlayer = max(1, maxlayer);
    all_layers = linspace(1, maxlayer, ceil(maxlayer));

    part=20; print_soln_body;

    max_absval = 0;
    pt_max = 0;

    % ----------------------------------------------------------------
    for layer = all_layers
      dist_max = layer*radius;

      for n = last_pt_included + 1 : p_ini
        if distances(n) > dist_max
          part=21; subp=1; print_soln_body;
          break % for(n)
        end

        % ----------------------------------------------------------
        part=21; subp=2; print_soln_body;

        fprintf(prob.fid_evaluatePolynomial, ...
                [ '[ --> ' pad('rowPivotGaussianElimination()', 38) ']' ]);
        [val prob] = evaluate_polynomial(pivot_polynomials(poly_i), ...
                                         points_shifted(:, n), ...
                                         prob);

        % ------------------------------------------------------------
        val = val/dist_max; % minor adjustment
        if abs(max_absval) < abs(val)
          max_absval = val;
          pt_max = n;
        end

        % ------------------------------------------------------------
        part=21; subp=3; print_soln_body;

      end

      if abs(max_absval) > pivot_threshold
        break % for(layer)
      end
    end

    % ----------------------------------------------------------------
    if abs(max_absval) > pivot_threshold

      % Point accepted
      pt_next = last_pt_included + 1;

      points_shifted(:, [pt_next, pt_max]) = points_shifted(:, [pt_max, pt_next]);

      points_abs(:, [pt_next, pt_max]) = points_abs(:, [pt_max, pt_next]);

      fvalues(:, [pt_next, pt_max]) = fvalues(:, [pt_max, pt_next]);

      distances([pt_next, pt_max]) = distances([pt_max, pt_next]);

      pivot_values(pt_next) = max_absval;

      part=22; print_soln_body;

      % --------------------------------------------------------------
      % Normalize polynomial value
      fprintf(prob.fid_normalizePolynomial, ...
              [ '[ --> ' pad('rowPivotGaussianElimination()', 38) ']\n' ]);
      [pivot_polynomials(poly_i) prob] = ...
          normalize_polynomial(pivot_polynomials(poly_i), ...
                               points_shifted(:, pt_next), ...
                               prob);


      % --------------------------------------------------------------
      % Re-orthogonalize (just to make sure it still assumes
      % 0 in previous points). Unnecessary in infinite precision
      fprintf(prob.fid_orthogonalizeToOtherPolynomials, ...
              [ '[ --> ' pad('rowPivotGaussianElimination()[b]', 38) ']' ]);      
      [pivot_polynomials(poly_i) prob] = ...
          orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                                  poly_i, ...
                                                  points_shifted, ...
                                                  last_pt_included, ...
                                                  prob);

      part=23; print_soln_body;

      % --------------------------------------------------------------
      % Orthogonalize polynomials on present block (deffering
      % subsequent ones)
      [pivot_polynomials prob] = ...
        orthogonalize_block(pivot_polynomials, ...
                            points_shifted(:, poly_i), ...
                            poly_i, ...
                            block_beginning, poly_i, ...
                            prob);

      % --------------------------------------------------------------
      already_included(pt_max) = true;
      last_pt_included = pt_next;
      poly_i = poly_i + 1;

      str_pts = 'Points accepted (a/f orthogonalize_block)';
      part=24; subp=1;  % print_soln_body;

    else

      % --------------------------------------------------------------
      % These points don't render good pivot value for this
      % specific polynomial
      % Exchange some polynomials and try to advance...
      % Moving this polynomial to the end of the block
      pivot_polynomials(poly_i:block_end) = ...
          pivot_polynomials([poly_i+1:block_end, poly_i]);
      % Comment [1]:
      % If we are on the linear block, this means we won't be
      % able to build a Fully Linear model

      str_pts = 'Points exchanged (a/f pivot exchange)';
      part=24; subp=2;

    end
    print_soln_body;

  end

  % ------------------------------------------------------------------
  model.tr_center = 1;
  model.points_abs = points_abs(:, 1:last_pt_included);
  model.points_shifted = points_shifted(:, 1:last_pt_included);
  model.fvalues = fvalues(:, 1:last_pt_included);

  model.points_shifted

  cache_size = min(p_ini - last_pt_included, 3*dim^2);
  model.pivot_polynomials = pivot_polynomials;
  model.pivot_values = pivot_values;
  model.modeling_polynomials = {};

  % ------------------------------------------------------------------
  % Points not included
  model.cached_points = points_abs(:, last_pt_included+1:last_pt_included ...
                                   + cache_size);
  model.cached_fvalues = fvalues(:, last_pt_included+1:last_pt_included ...
                                 + cache_size);

  model_changed = last_pt_included < p_ini; % REMOVE ME

  part=25; print_soln_body;

end


