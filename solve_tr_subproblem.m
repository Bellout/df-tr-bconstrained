function [trial_point, trial_decrease, prob] = ...
  solve_tr_subproblem(model, ...
                      bl, bu, ...
                      options, ...
                      prob)

  % SOLVE_TR_SUBPROBLEM --- approximately solves trust-region
  % subproblem.

  % ------------------------------------------------------------------
  obj_pol_o = model.modeling_polynomials{1};
  x_tr_center = model.points_abs(:, model.tr_center);

  fprintf(prob.fid_shiftPolynomial, [ '[ --> ' pad('solveTrSubproblem()', 38) ']' ]);
  obj_pol_s = shift_polynomial(obj_pol_o, -x_tr_center, prob); % Shift to origin
  radius = model.radius;

  obj_pol = obj_pol_s;

  % ------------------------------------------------------------------
  % Print polynomial [-polynomial_max] (input data)
  % part=0; print_soln_body;
  % part=6; print_soln_body; % C++ POINT SOLVE TR SUBPROBLEM

  % ------------------------------------------------------------------  
  fprintf(prob.fid_minimizeTr, [ '[ --> ' pad('solveTrSubproblem()', 38) ']' ]);
  [trial_point, trial_fval, exitflag, prob] = ...
      minimize_tr(obj_pol, x_tr_center, radius, ...
                  bl, bu, prob, true);

  % ------------------------------------------------------------------
  current_fval = model.fvalues(1, model.tr_center);

  trial_decrease = current_fval - trial_fval;

  part=14; subp=1; print_soln_body;

  % ------------------------------------------------------------------
  if current_fval <= trial_fval
     1;
  end

  % ------------------------------------------------------------------
  tol_interp = max(1e-8, eps(max(1, max(model.fvalues(1, :))))*1e3);
  n_points = size(model.points_abs, 2);

  for k = 1:n_points

    fprintf(prob.fid_evaluatePolynomial, [ '[ --> ' pad('solveTrSubproblem()', 38) ']' ]);
    [val prob] = evaluate_polynomial(obj_pol, model.points_abs(:, k), prob);
    error_interp = abs(val - model.fvalues(1, k));

    part=14; subp=2; print_soln_body;
    if error_interp > tol_interp
        1;
    end

  end

  % ------------------------------------------------------------------
  % Print polynomial [-polynomial_max] (input data)
  % part=0; print_soln_body;
  % part=9; print_soln_body; % Trial point found

end
