function [x, fval] = trust_region_dbg(...
    funcs, initial_points, initial_fvalues, ...
    bl, bu, options, prob)
% TRUST_REGION - Derivative-free trust-region algorithm

% --------------------------------------------------------------------
defaultoptions = struct(...
    'tol_radius', 1e-5, ...
    'tol_f', 1e-6, ...
    'eps_c', 1e-5, ...
    'eta_0', 0, ...
    'eta_1', 0.05, ...
    'pivot_threshold', 1/16, ...
    'add_threshold', 100, ...
    'exchange_threshold', 1000,  ...
    'initial_radius', 1, ...
    'radius_max', 1e3, ...
    'radius_factor', 6, ...
    'gamma_inc', 2, ...
    'gamma_dec', 0.5, ...
    'criticality_mu', 100, ...
    'criticality_beta', 10, ...
    'criticality_omega', 0.5, ...
    'basis', 'diagonal hessian', ...
    'iter_max', 10000);

% --------------------------------------------------------------------
if nargin < 7
    prob = [];
end
if nargin < 6
    options = [];
end
options = parse_trust_region_inputs(options, defaultoptions);
if nargin < 5
    bu = [];
end
if nargin < 4
    bl = [];
end
if nargin < 3
    initial_fvalues = [];
end

% --------------------------------------------------------------------
part=100; subp=1; print_soln_body; % TrustRegionOptimization() -- 0
part=105; subp=1; print_soln_body; % setLowerUpperBounds() -- 1

debugging_on = false;
tol_radius = options.tol_radius;
tol_f = options.tol_f;
eps_c = options.eps_c;
eta_0 = options.eta_0;
eta_1 = options.eta_1;

gamma_0 = 0.0625;
gamma_1 = options.gamma_dec;
gamma_2 = options.gamma_inc;
radius_factor = options.radius_factor;
rel_pivot_threshold = options.pivot_threshold;

iter_max = options.iter_max;

initial_radius = options.initial_radius;
radius_max = options.radius_max;
dimension = size(initial_points, 1);

% --------------------------------------------------------------------
part=99;  subp=1; print_soln_body; % TrustRegionModel() -- 2
part=107; subp=1; print_soln_body; % areInitPointsComputed() -- 3 to false
part=108; subp=1; print_soln_body;  % areImprPointsComputed() -- 4
part=109; subp=1; print_soln_body;  % areReplacementPointsComputed() -- 5
part=110; subp=1; print_soln_body;  % isInitialized() -- 6
part=111; subp=1; print_soln_body;  % isImprovementNeeded() -- 7
part=112; subp=1; print_soln_body;  % isReplacementNeeded() -- 8
part=113; subp=1; print_soln_body;  % hasModelChanged() -- 9

% --------------------------------------------------------------------
if (~isempty(bl) && ~isempty(find(initial_points(:, 1) < bl, 1))) || ...
  (~isempty(bu) && ~isempty(find(initial_points(:, 1) > bu, 1)))

  if isempty(initial_fvalues)

     % Replace
     initial_points(:, 1) = ...
     project_to_bounds(initial_points(:, 1), bl, bu);

   else

     % Add
     initial_points = ...
     [project_to_bounds(initial_points(:, 1), bl, bu), initial_points];

     initial_fvalues(:, 1) = ...
     evaluate_new_fvalues(funcs, initial_points(:, 1));
     
  end
end
part=104; subp=1;print_soln_body; % computeInitialPoints() -- 10

% --------------------------------------------------------------------
% Compute 2nd point
n_initial_points = size(initial_points, 2);
if n_initial_points == 1

  % ------------------------------------------------------------------
  % Finding a random second point
  old_seed = rng('default');
  second_point = rand(size(initial_points));
  rng(old_seed);

  % ------------------------------------------------------------------
  while norm(second_point, inf) < rel_pivot_threshold
    % Second point must not be too close
    second_point = 2*second_point;
  end

  % ------------------------------------------------------------------
  second_point = (second_point - 0.5)*initial_radius;
  second_point = initial_points(:, 1) + second_point;

  if ~isempty(bu)
    second_point = min(bu, second_point);
  end

  if ~isempty(bl)
    second_point = max(bl, second_point);
  end

  % ------------------------------------------------------------------
  initial_points(:, 2) = second_point;
  n_initial_points = 2;

end
part=104; subp=2; print_soln_body; % computeInitialPoints() -- 10













% Set formats for x and f --------------------------------------------
part=0; print_soln_body;

% Set prob names -----------------------------------------------------
part=1; print_soln_body;

part=101; subp=1; print_soln_body; % iterate()
% !areInitPointsComputed -> true
% !isInitialized -> true
part=114; subp=1; print_soln_body; % getInitializationCases()

% Calculating function values for other points of the set
if length(initial_fvalues) < n_initial_points

  for k = 1:n_initial_points
    [initial_fvalues(:, k), succeeded] = ...
    evaluate_new_fvalues(funcs, initial_points(:, k));

    part=102; subp=1; print_soln_body; % handleEvaluatedCase()
    % Iteration, point, value
    
    if ~succeeded
      error('cmg:bad_starting_point', 'Bad starting point');
    end
  end
end

part=107; subp=2; print_soln_body; % areInitPointsComputed() to true

% --------------------------------------------------------------------
% Print initial points + obj.fvals to file
part=2; print_soln_body;

% --------------------------------------------------------------------
% Initializing model structure
model = tr_model(initial_points, initial_fvalues, initial_radius);

% --------------------------------------------------------------------
% Rebuild model
part=101; subp=2; print_soln_body; % iterate()
% areInitPointsComputed, !areImprovementPointsComputed
% !areReplacementPointsComputed, !isInitialized


fprintf(prob.fid_rebuildModel, ... 
        [ STARTSTR '[ --> ' pad('iterate()[a]', 38) ']' ]);
model = rebuild_model(model, options, prob);

part=107; subp=2; print_soln_body; % areInitPointsComputed() -- 3 to true
part=108; subp=3; print_soln_body; % areImprPointsComputed() -- 4 to false
part=109; subp=3; print_soln_body; % areReplacementPointsComputed() -- 5 to false
part=110; subp=3; print_soln_body; % isInitialized() -- 6 to false

% --------------------------------------------------------------------
% Print model data: model.tr_center, model.tr_radius,
% points_shifted, model.pivot_polynomials.coefficients,
% model.pivot_values
part=3; print_soln_body;

% --------------------------------------------------------------------
% Move to best point
fprintf(prob.fid_moveToBestPoint, ... 
        [ STARTSTR '[ --> ' pad('iterate()[a]', 38) ']' ]);
prob.prev = '[a]';
model = move_to_best_point(model, bl, bu, [], prob);

% --------------------------------------------------------------------
% basis = band_prioritizing_basis(size(model.points_shifted, 1));
% fprintf(prob.fid_computePolynomialModels, STARTSTR);
fprintf(prob.fid_computePolynomialModels, ...
        [ STARTSTR '[ --> ' pad('iterate()[a]', 38) ']' ]);
[ model.modeling_polynomials, prob ] = ...
compute_polynomial_models(model, prob);

% fprintf(['\npoints_abs:\n' repmat('%22.12e %22.12e\n',1,2) '\n'], model.points_abs);
% fprintf(['\npoints_shifted:\n' repmat('%22.12e %22.12e\n',1,2) '\n'], model.points_shifted);
% fprintf(['\nmodel.modeling_polynomials{1}.coefficients:\n' repmat('%22.12e',1,6) '\n\n'], model.modeling_polynomials{1}.coefficients);

% --------------------------------------------------------------------
% Print model data: model.modeling_polynomials.coefficients,
% model.modeling_polynomials.dimension
part=4; print_soln_body;

% --------------------------------------------------------------------
part=101; subp=3; print_soln_body; % iterate()
% hasOnlyOnePoint

if size(model.points_abs, 2) < 2

  part=101; subp=4; print_soln_body; % iterate()
  % ensureImprovement

  fprintf(prob.fid_ensureImprovement, [ STARTSTR '[ --> ' pad('iterate()[a]', 38) ']' ]);
  [model, exitflag, prob] = ...
  ensure_improvement(model, funcs, bl, bu, options, prob);
  part=118; subp=1; print_soln_body; % getImprovementCases() -- 20
  part=119; subp=1; print_soln_body; % getReplacementCases() -- 21
end

% part=101; subp=5; print_soln_body; % iterate()
% areInitPointsComputed
% isImprovementNeeded
% areImprovementPointsComputed
% !isInitialized

% part=101; subp=6; print_soln_body; % iterate()
% areInitPointsComputed
% isReplacementNeeded
% areReplacementPointsComputed
% !isInitialized

isImprovementNeeded=0;


% ====================================================================
% Start opt.loop

% --------------------------------------------------------------------
rho = 0;
iter = 1;

fval_current = model.fvalues(1);
x_current = model.points_abs(:, model.tr_center); 
% BUG: model.fvalues does do correspond to model.tr_center index

% --------------------------------------------------------------------
sum_rho = 0;
sum_rho_sqr = 0;
delay_reduction = 0;


% ====================================================================
for iter = 1 : iter_max

  % <<<<<<<<<<<<<<<<< COUNTER 1 >>>>>>>>>>>>>>>>>>>>
  fprintf(prob.fid_iterate, STARTSTR);
  fprintf(prob.fid_iterate, COUNTSTR, 1);
  part=101; subp=7; print_soln_body; % iterate()  
  % x_current, fval_current, tr_center

  part=101; subp=11; print_soln_body; % iterate()
  % isImprovementNeeded
  % areImprovementPointsComputed
  % isReplacementNeeded
  % areReplacementPointsComputed





  % ------------------------------------------------------------------
  if (model.radius < tol_radius)
    break
  end

  % ------------------------------------------------------------------
  if true || is_lambda_poised(model, options)

    % Move among points that are part of the model
    fprintf(prob.fid_moveToBestPoint, ...
        [ STARTSTR '[ --> ' pad('iterate()[b]', 38) ']' ]);
    prob.prev = '[b]';
    model = move_to_best_point(model, bl, bu, [], prob);

    % fprintf(prob.fid_computePolynomialModels, STARTSTR);
    fprintf(prob.fid_computePolynomialModels, ...
            [ STARTSTR '[ --> ' pad('iterate()[b]', 38) ']' ]);
    model.modeling_polynomials = compute_polynomial_models(model, prob);

    fval_current = model.fvalues(1, model.tr_center);
    x_current = model.points_abs(:, model.tr_center);

    % <<<<<<<<<<<<<<<<< COUNTER 2 >>>>>>>>>>>>>>>>>>>>
    fprintf(prob.fid_iterate, COUNTSTR, 2);    
    part=101; subp=7; print_soln_body; % iterate()
    % x_current, fval_current, tr_center

    [err_model, prob] = check_interpolation(model, prob);

  end

  % ------------------------------------------------------------------
  % Criticality step -- if we are possibly close to the optimum
  criticality_step_performed = false;
  cW1 = norm(measure_criticality(model, bl, bu, prob)) <= eps_c;
  part=101; subp=8; print_soln_body; % iterate()

  if cW1
    model = criticality_step(model, funcs, bl, bu, options, prob);
    criticality_step_performed = true;

    cW2 = norm(measure_criticality(model, bl, bu, prob)) < tol_f;
    if cW2
      part=101; subp=9; print_soln_body; % iterate()
      break;
    end

  end
  iteration_model_fl = is_lambda_poised(model, options);

  % ------------------------------------------------------------------
  % Print summary
  print_iteration(iter, fval_current, rho, model.radius, ...
                  size(model.points_abs, 2), prob);

  % ------------------------------------------------------------------
  % Compute step
  [trial_point, predicted_red] = solve_tr_subproblem(model, bl, bu, ...
                                                     options, prob);
  trial_step = trial_point - x_current;

  % ------------------------------------------------------------------
  cS = predicted_red < tol_radius*1e-2;
  cT = predicted_red < tol_radius*abs(fval_current);  
  cU = norm(trial_step) < tol_radius;
  cV = predicted_red < tol_f*abs(fval_current)*1e-3;         
  part=101; subp=12; print_soln_body; % iterate()



  if (cS || (cT && cU) || cV)

    rho = -inf;
    fprintf(prob.fid_ensureImprovement, ...
            [ STARTSTR '[ --> ' pad('iterate()[b]', 38) ']' ]);
    [model, mchange_flag] = ensure_improvement(model, funcs, ...
                                               bl, bu, options, prob);
  else
    % ----------------------------------------------------------------
    % Evaluate objective at trial point
    fval_trial = evaluate_new_fvalues(funcs, trial_point);
    part=101; subp=13; print_soln_body; % iterate()



    % Actual reduction
    ared = fval_current - fval_trial;
    % Agreement factor
    rho = ared/(predicted_red);
    % Acceptance of the trial point

    % <<<<<<<<<<<<<<<<< COUNTER 1: HANDLEEVALUATEDCASE >>>>>>>>>>>>>>>>>>>>
    fprintf(prob.fid_handleEvaluatedCase, STARTSTR);
    fprintf(prob.fid_handleEvaluatedCase, COUNTSTR, 1);
    part=102; subp=2; print_soln_body; %% handleEvaluatedCase()
    part=102; subp=3; print_soln_body; %% handleEvaluatedCase()
    % eta_1, ared_, rho_, x_current

    cX = rho > eta_1;
    if cX
      % --------------------------------------------------------------
      % Successful iteration
      fval_current = fval_trial;
      x_current = trial_point;
      % Including this new point as the TR center
      [model, mchange_flag] = change_tr_center(model, trial_point, ...
                                               fval_trial, options, prob);

      part=102; subp=4; print_soln_body; %% handleEvaluatedCase()
      % (rho_ > eta_1), mchange_flag_, fval_trial_, trial_point_

      % --------------------------------------------------------------
      % this mchange_flag is not being used (rho > eta_1)
      cY = (~iteration_model_fl && mchange_flag == 4);
      if cY
        
        % Had to rebuild a model that wasn't even Fully Linear
        % This shouldn't happen
        fprintf(prob.fid_ensureImprovement, ...
                [ STARTSTR '[ --> ' pad('iterate()[c]', 38) ']' ]);
        [model, mchange_flag] = ensure_improvement(model, funcs, ...
                                                   bl, bu, options, prob);

        % this mchange_flag is not being used (rho > eta_1)
        part=102; subp=5; print_soln_body; %% handleEvaluatedCase()
        % mchange_flag, ~iteration_model_fl

      end

    else
      % --------------------------------------------------------------
      fprintf(prob.fid_tryToAddPoint, ...
              [ STARTSTR '[ --> ' pad('handleEvaluatedCase()[a]', 38) ']' ]);
      [model, mchange_flag] = try_to_add_point(model, trial_point, fval_trial, ...
                                               funcs, bl, bu, options, prob);

    % <<<<<<<<<<<<<<<<< FAKE COUNTER 1 >>>>>>>>>>>>>>>>>>>>
    % REPEATE BC WE NEED TO BREAK THE ITERATE LOOP TO CONPUTE
    % THE FUNCTION FUNCTION VALUES 
    part=101; subp=10; print_soln_body; % iterate()

     % if mchange_flag == 4, we had to rebuild the model
     % and the radius will be reduced
     part=102; subp=4; print_soln_body; %% handleEvaluatedCase()
    end
    % ----------------------------------------------------------------
    sum_rho = sum_rho + rho;
    sum_rho_sqr = sum_rho_sqr + rho^2;
  end

  % ------------------------------------------------------------------
  % From time to time a step may end a bit outside the TR
  step_size = min(model.radius, norm(trial_step, inf));

  % ------------------------------------------------------------------
  % Radius update
  if rho > eta_1
      
      radius_inc = max(1, gamma_2*(step_size/model.radius));
      model.radius = min(radius_inc*model.radius, radius_max);

  elseif (iteration_model_fl && (rho == -inf || mchange_flag == 4 || criticality_step_performed))

      % A good model should have provided a better point
      % We reduce the radius, since the error is related to the
      % radius
      % | f(x) - m(x) | < K*(radius)^2
      % rho == -inf -> too short step size
      % mchange_flag == 4 -> Couldn't add point, had to rebuild model
      if model.radius <= 2*tol_radius/gamma_1
          delay_reduction = delay_reduction + 1;
      else
          delay_reduction = 0;
      end

      if delay_reduction >= 3 || delay_reduction == 0 || criticality_step_performed
          gamma_dec = gamma_1;
          model.radius = gamma_dec*model.radius;
          delay_reduction = 0;
      end
  end

  iter = iter + 1;
  if debugging_on
      iter
  end
  iter;
end

% --------------------------------------------------------------------
x = model.points_abs(:, model.tr_center);
fval = model.fvalues(1, model.tr_center);



