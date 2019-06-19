function m = measure_criticality(model, bl, bu, prob)
    % MEASURE_CRITICALITY gives the gradient of the model, calculated
    % in absolute coordinates in the current point.
    %
    %    - In the present work, the polynomial model is being calculated
    %    scaled, inside a ball of radius 1. Thus it has to be rescaled to
    %    absolute coordinates.
    %    
    %    - If one desires handle constraints, other criticality
    %    measures need to be considered

    if nargin < 2 || isempty(bl)
        bl = -inf;
    end
    if nargin < 3 || isempty(bu)
        bu = inf;
    end
    % Just the gradient, measured on the tr_center
      fprintf(prob.fid_getModelMatrices, ...
          [ '[ --> ' pad('measureCriticality()', 38) ']' ]);
    [c, grad, H, prob] = get_model_matrices(model, 0, prob);
    
    % Projected gradient
    x_center = model.points_abs(:, model.tr_center);
    
    A = (x_center - grad);
    B = max(bl, A);
    C = min(bu, B);
    m = C - x_center;

    part=28; print_soln_body;

end
