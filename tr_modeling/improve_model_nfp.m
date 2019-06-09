function [model, exitflag, prob] = improve_model_nfp(model, ...
                                               funcs, ...
                                               bl, bu, ...
                                               options, ...
                                               prob)

  % ------------------------------------------------------------------
  rel_pivot_threshold = options.pivot_threshold;
  tol_radius = options.tol_radius;
  radius_factor = options.radius_factor;

  % ------------------------------------------------------------------
  radius = model.radius;
  pivot_threshold = rel_pivot_threshold*min(1, radius);

  % ------------------------------------------------------------------
  % SHIFTED POINTS
  points_shifted = model.points_shifted;
  [dim, p_ini] = size(points_shifted);

  % ------------------------------------------------------------------
  % SHIFTED CENTER
  shift_center = model.points_abs(:, 1);
  tr_center = model.tr_center;

  % ------------------------------------------------------------------
  pivot_polynomials = model.pivot_polynomials;
  polynomials_num = length(pivot_polynomials);

  % ------------------------------------------------------------------
  if isempty(bl)
      bl = -inf(dim, 1);
  end
  if isempty(bu)
      bu = inf(dim, 1);
  end

  % ------------------------------------------------------------------
  bl_shifted = bl - shift_center;
  bu_shifted = bu - shift_center;
  tol_shift = 10*eps(max(1, max(abs(shift_center))));

  unshift_point = @(x) max(min(x + shift_center, bu), bl);

  % ------------------------------------------------------------------
  % Test if the model is already FL but old
  % Distance measured in inf norm
  tr_center_pt = points_shifted(:, tr_center);

  part=34; print_soln_body;

  A = norm(tr_center_pt, inf) > radius_factor*radius;
  B = p_ini > dim+1;
  if (A && B)

    str_mstat0='Model is old; rebuild needed';
    part=35; print_soln_body;
    exitflag = false; % Needs to rebuild

  else

    str_mstat0='Model is not old';

    % The model is not old
    C = p_ini < polynomials_num;
    if C

      % --------------------------------------------------------------
      % The model is not complete
      D = p_ini < dim + 1;
      if D
          % The model is not yet fully linear
          str_mstat1=['Model is not complete, i.e., not yet ' ...
            'fully linear (p_ini < dim+1)=(1)' ];
          block_beginning = 2;
          block_end = p_ini + 1;
      else
          % We can add a point to the quadratic block
          str_mstat1=['Add a point to quadratic block' ];
          block_beginning = dim + 2;
          block_end = p_ini + 1;
      end

      % --------------------------------------------------------------
      next_position = p_ini + 1;
      radius_used = radius;

      part=35; print_soln_body;

      % Possibly try with smaller radii
      for attempts = 1:3

        str_att0='For-loop[1]: (attempts<=3) Try smaller radius: ';
        part=36; subp=1; print_soln_body;

        % ------------------------------------------------------------
        % Iterate through available polynomials
        for poly_i = next_position : block_end

          str_att1=['For-loop[2]: (poly_i <= block_end) ' ...
                      'Iter through avail. polyn. (poly_i=' ];

          % ----------------------------------------------------------
          part=36; subp=2; print_soln_body;
          fprintf(prob.fid_orthogonalizeToOtherPolynomials, ...
                  [ '[ --> ' pad('improveModelNfp()[a]', 38) ']' ]);
          [polynomial prob] = ...
              orthogonalize_to_other_polynomials(...
                          pivot_polynomials, poly_i, ...
                          points_shifted, p_ini, prob);

          % ----------------------------------------------------------
          fprintf(prob.fid_pointNew, ...
                  [ '[ --> ' pad('improveModelNfp()[a]', 38) ']' ]);
          [new_points_shifted, new_pivots, point_found, prob] ...
              = point_new(polynomial, tr_center_pt, ...
                          radius_used, bl_shifted, bu_shifted, ...
                          pivot_threshold, prob);

          % ----------------------------------------------------------
          if point_found

            % --------------------------------------------------------
            for found_i = 1:length(new_points_shifted)

              new_point_shifted = new_points_shifted(:, found_i);
              new_pivot_value = new_pivots(found_i);

              new_point_abs = unshift_point(new_point_shifted);

              [new_fvalues, f_succeeded, prob] = ...
                  evaluate_new_fvalues(funcs, new_point_abs, prob);

              part=37; print_soln_body;
              if (prob.prev == 'ensureImprovement')
                fprintf(prob.fid_improveModelNfp, ...
                        [ '[ --> ' pad('ensureImprovement()[a]', 38) ']' ]);
              end
              part=34; print_soln_body;
              part=35; print_soln_body;
              part=36; subp=1; print_soln_body;
              part=38; print_soln_body;

              % ------------------------------------------------------
              if f_succeeded
                  part=39; print_soln_body; % loop3b
                  break
              else
                  true;
              end
            end
            part=40; print_soln_body; % loop3d

            % --------------------------------------------------------
            if f_succeeded
              % Stop trying pivot polynomials
              part=41; print_soln_body;
              break %(for poly_i)
            end

          end
          part=42; print_soln_body; % end-if1
            % Attempt another polynomial if didn't break
        end % end-for: (poly_i = next_position:block_end)
        part=45; print_soln_body; % chck-impr + loop2b

        % ------------------------------------------------------------
        if point_found && f_succeeded
          part=43; print_soln_body;
          break %(for attempts)

        elseif point_found
          part=44; print_soln_body;
          % Reduce radius if it didn't break
          radius_used = 0.5*radius_used;
          if radius_used < tol_radius
              break
          end
        else
            break
        end


      end % end-for: (attempts = 1:3)
      part=46; print_soln_body;

      % --------------------------------------------------------------
      if point_found && f_succeeded

        % Update this polynomial in the set
        pivot_polynomials(poly_i) = polynomial;

        % Swap polynomials
        pivot_polynomials([next_position, poly_i]) = ...
            pivot_polynomials([poly_i, next_position]);

        part=47; print_soln_body;

        ps = points_shifted;
        nps = new_point_shifted;
        pa = model.points_abs;
        fv = model.fvalues;
        part=48; print_soln_body;

        % ------------------------------------------------------------
        % Add point
        part=49; print_soln_body;
        points_shifted(:, next_position) = new_point_shifted;

        % ------------------------------------------------------------
        % Normalize polynomial value
        part=50; print_soln_body;
        fprintf(prob.fid_normalizePolynomial, ...
                [ '[ --> ' pad('improveModelNfp()[b]', 38) ']\n' ]);
        [pivot_polynomials(next_position) prob] = ...
            normalize_polynomial(pivot_polynomials(next_position), ...
                                 new_point_shifted, prob);

        % ------------------------------------------------------------
        % Re-orthogonalize
        part=51; print_soln_body;
        fprintf(prob.fid_orthogonalizeToOtherPolynomials, ...
                [ '[ --> ' pad('improveModelNfp()[b]', 38) ']' ]);
        pivot_polynomials(next_position) = ...
            orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                                    next_position, ...
                                                    points_shifted, ...
                                                    p_ini, ...
                                                    prob);

        % ------------------------------------------------------------
        % Orthogonalize polynomials on present block (deffering
        % subsequent ones)
        part=52; print_soln_body;
        fprintf(prob.fid_orthogonalizeBlock, ...
                [ '[ --> ' pad('improveModelNfp()[b]', 38) ']' ]);
        pivot_polynomials = orthogonalize_block(pivot_polynomials, ...
                                                new_point_shifted, ...
                                                next_position, ...
                                                block_beginning, ...
                                                p_ini, ...
                                                prob);

        % Update model and recompute polynomials
        part=53; print_soln_body;
        model.points_abs(:, next_position) = new_point_abs;

        model.points_shifted = points_shifted;
        model.fvalues(:, next_position) = new_fvalues;
        model.pivot_polynomials = pivot_polynomials;
        model.pivot_values(:, next_position) = new_pivot_value;
        model.modeling_polynomials = {};
        exitflag = true;

        ps = points_shifted;
        pa = model.points_abs;
        fv = model.fvalues;
        part=48; print_soln_body;

      else
        exitflag = false;
      end

    else % if: (p_ini < polynomials_num)

      str_mstat1='Model is already complete';
      part=35; print_soln_body;

      % The model is already complete,
      exitflag = false;

    end % end-if: (p_ini < polynomials_num)
  end

  part=54; print_soln_body;
end


