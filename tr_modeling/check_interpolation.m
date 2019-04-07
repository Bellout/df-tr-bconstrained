function max_diff = check_interpolation(model)

% ----------------------------------------------------------
% Tolerance
if model.radius < 1e-3 
    tol_1 = 100*eps;
else
    tol_1 = 10*eps;
end
tol_2 = 10*sqrt(eps);

% ----------------------------------------------------------
% Remove shift center from all points
h = model.points_abs;
n_points = size(h, 2);
if n_points < model.tr_center
   1; 
end
for m = n_points:-1:1
    h(:, m) = h(:, m) - model.points_abs(:, model.tr_center);
end

% ----------------------------------------------------------
max_diff = -1;
n_functions = size(model.fvalues, 1);

for k = 1:n_functions
    [c, g, H] = get_model_matrices(model, k-1);

    for m = 1:n_points

        % --------------------------------------------------
        this_value = c + g'*h(:, m) + 0.5*(h(:, m)'*H*h(:, m));
        fprintf(['\nh(:, m):\n' repmat('%22.12e',1,2) '\n'], h(:, m));
        fprintf(['\ncval:\n' repmat('%22.12e',1,1) '\n'], this_value);

        % --------------------------------------------------
        difference = abs(model.fvalues(k, m) - this_value);
        if difference > max_diff
            max_diff = difference;
        end

        % --------------------------------------------------
        conda =  max(tol_1*max(abs(model.fvalues(k, :))), tol_2);
        fprintf(['\nconda:\n' repmat('%22.12e',1,1) '\n'], conda);

        if abs(difference) > conda
            warning('cmg:tr_interpolation_error', 'Interpolation error');
        end
    end
end
