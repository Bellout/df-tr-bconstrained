function [polynomials prob] = compute_polynomial_models(model, prob)
  
  % ------------------------------------------------------------------
  % fprintf('%s\n', 'Calling compute_polynomial_models');
  [dim, points_num] = size(model.points_abs);
  functions_num = size(model.fvalues, 1);
  
  linear_terms = dim + 1;
  full_q_terms = (dim + 1)*(dim + 2) / 2;
  lastwarn('');
  part=66; subp=1; print_soln_body;

  % ------------------------------------------------------------------
  cA = (linear_terms < points_num);
  cB = (points_num < full_q_terms);
  part=66; subp=2; print_soln_body;    
  if cA && cB

    % ----------------------------------------------------------------
    % Compute quadratic model
    % fprintf('%s\n', 'Calling compute quadratic model');
    [polynomials prob] = ...
        compute_quadratic_mn_polynomials(model.points_abs, ...
                                         model.tr_center, ...
                                         model.fvalues, ...
                                         prob);
  end
  
  % ------------------------------------------------------------------
  [~, wid] = lastwarn();
  cC = (points_num <= linear_terms);
  cD = (points_num == full_q_terms);
  cE = strcmp(wid, 'cmg:badly_conditioned_system');
  
  part=66; subp=3; print_soln_body;
  
  if cC || cD || cE

    % if (cC)
    %   fprintf('%s\n', 'cC = (points_num <= linear_terms)');
    % end

    % if (cD)
    %   fprintf('%s\n', 'cD = (points_num == full_q_terms)');
    % end

    % if (cE)
    %   fprintf('%s\n', wid);
    %   fprintf('%s\n', 'cmg:badly_conditioned_system');
    % end

    % ----------------------------------------------------------------
    % Compute model with incomplete (complete) basis
    % fprintf('%s\n', 'Compute model with incomplete (complete) basis');
    fprintf(prob.fid_nfpFiniteDifferences, ...
            [ '[ --> ' pad('computePolynomialModels()', 38) ']' ]);
    [l_alpha prob] = ...
        nfp_finite_differences(model.points_shifted, ...
                               model.fvalues, ...
                               model.pivot_polynomials(1:points_num), ...
                               prob);
    
    % ----------------------------------------------------------------
    for k = functions_num : -1 : 1
        
      [polynomials{k} prob]  = ...
          combine_polynomials(model.pivot_polynomials(1:points_num), ...
                              l_alpha(k, :), prob);

      fprintf(prob.fid_shiftPolynomial, ...
              [ '[ --> ' pad('computePolynomialModels()', 38) ']' ]);
      [polynomials{k} prob] = ...
        shift_polynomial(polynomials{k}, ...
          model.points_shifted(:, model.tr_center), prob);

    end
    part=66; subp=4; print_soln_body;
  end
  
  part=66; subp=5; print_soln_body;
end
