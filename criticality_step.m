function [model, prob] = ...
  criticality_step(model, funcs, ...
    bl, bu, options, prob)

% CRITICALITY_STEP -- ensures model is sufficiently poised and with
% a radius comparable to the gradient

% --------------------------------------------------------------------
mu = options.criticality_mu; % factor between radius and
                             % criticality measure

omega = options.criticality_omega; % factor used to reduce radius
beta = options.criticality_beta; % to ensure the final radius
                                 % reduction is not drastic

tol_radius = options.tol_radius; % tolerance of TR algorithm
tol_f = options.tol_f;

% --------------------------------------------------------------------
initial_radius = model.radius;
A = ~is_lambda_poised(model, options);
B = is_old(model, options);
while (A || B)

    [model, model_changed, prob] = ensure_improvement(model, ...
                                                      funcs, bl, bu, ...
                                                      options, prob);

    model.modeling_polynomials = compute_polynomial_models(model, prob);
    
    if ~model_changed
        warning('cmg:model_didnt_change', 'Model didnt change');
        break
    end
end

% --------------------------------------------------------------------

crit_measure = mu*measure_criticality(model, bl, bu, prob);
part=23; print_soln_body;

% --------------------------------------------------------------------
while (model.radius > crit_measure)
    
    model.radius = omega*model.radius;

    % ----------------------------------------------------------------
    while ~is_lambda_poised(model, options) || is_old(model, options)
        
        [model, model_changed, prob] = ensure_improvement(model, ...
                                                          funcs, bl, bu, ...
                                                          options, prob);

        [model.modeling_polynomials prob] = compute_polynomial_models(model, prob);
       
        if ~model_changed
            warning('cmg:model_didnt_change', 'Model didnt change');
            break
        end

    end
    
    % ----------------------------------------------------------------
    C = model.radius < tol_radius;
    D = norm(measure_criticality(model, bl, bu, prob));
    E = (beta*D < tol_f);
    F = model.radius < 100*tol_radius;
    G = (C || E && F);
    if (G)
        % Better break.
        % Not the end of this algorithm, but satisfies 
        % stopping condition for outer algorithm anyway...
        part=24; print_soln_body;
        break;
    end
end

% --------------------------------------------------------------------
% The final radius is increased not to make the reduction drastic
H = norm(measure_criticality(model, bl, bu, prob));
I = beta*H;
J = max(model.radius, I);
K = min(J, initial_radius);
model.radius = K;
part=25; print_soln_body;

end