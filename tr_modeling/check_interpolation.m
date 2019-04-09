function [max_diff, prob] = check_interpolation(model, prob)

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
n_functions = size(model.fvalues, 1); % Only 1 function = one rowvector

part=0; print_soln_body;
part=11; print_soln_body;

% ----------------------------------------------------------
for k = 1:n_functions
    [c, g, H] = get_model_matrices(model, k-1);
    part=12; print_soln_body;

    for m = 1:n_points

        % --------------------------------------------------
        this_value = c + g'*h(:, m) + 0.5*(h(:, m)'*H*h(:, m));

        % --------------------------------------------------
        difference = abs(model.fvalues(k, m) - this_value);
        if difference > max_diff
            max_diff = difference;
        end

        % --------------------------------------------------
        A = model.fvalues(k, :);
        B = max(A);
        C = tol_1*B;
        D =  max(C, tol_2);
        part=13; print_soln_body;

        if abs(difference) > D
            warning('cmg:tr_interpolation_error', 'Interpolation error');
        end
    end
end

