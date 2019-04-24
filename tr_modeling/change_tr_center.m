function [model, exitflag, prob] = ...
    change_tr_center(model, new_point, ...
                     new_fvalues, options, prob)

    point_added = false;
    point_exchanged = false;
    part=78; subp=1; print_soln_body;

    if ~is_complete(model, prob)

        % Add this point
        part=78; subp=2; print_soln_body;
        fprintf(prob.fid_addPoint, ['[ changeTrCenter() ]\n']);
        relative_pivot_threshold = options.pivot_threshold;
        [model, point_added, prob] = add_point(model, ...
                                               new_point, ...
                                               new_fvalues, ...
                                               relative_pivot_threshold, ...
                                               prob);
    end

    if point_added
        % Function add_point adds this as the last.
        % Now we have to set as TR center
        model.tr_center = size(model.points_abs, 2); % Last among
                                                     % the points
        exitflag = 1;
        part=78; subp=3; print_soln_body;                                                     

    else
        relative_pivot_threshold = options.pivot_threshold;

        part=78; subp=4; print_soln_body;
        fprintf(prob.fid_addPoint, ['[ changeTrCenter() ]\n']);
        [model, point_exchanged, pt_i, prob] = exchange_point(model, ...
                                                        new_point, ...
                                                        new_fvalues, ...
                                                        relative_pivot_threshold, ...
                                                        prob);
        if point_exchanged
            model.tr_center = pt_i;
            point_exchanged = true;
            exitflag = 2;
        else

            % add_point and exchange_point failed
            % We still need to add this new point as TR center
            % Model needs rebuilding
            part=78; subp=5; print_soln_body;            
            model.points_abs(:, end+1) = new_point;
            model.fvalues(:, end+1) = new_fvalues;
            model.tr_center = size(model.points_abs, 2); % Last
            [model, changed, prob] = rebuild_model(model, options, prob);
            exitflag = 4;
        end
    end
%     % Recompute polynomials
%     % basis = pivot_polynomials; % Needs tests
%     basis = band_prioritizing_basis(size(model.points_shifted, 1)); % Hopefully more accurate
%                                           % than using pivots
%     warning('');
%     % Always recompute on this function
%     model.modeling_polynomials = ...
%         recompute_polynomial_models(model.points_shifted, model.fvalues, ...
%                                     basis);
%     [~, wid] = lastwarn();
%     if strcmp(wid, 'cmg:badly_conditioned_system')
%         check = true;
%     else
%         check = false;
%     end
%     [dim, points_num] = size(model.points_abs);
%     if points_num > dim + 1
%        mp1 = shift_polynomial(model.modeling_polynomials{1}, -model.points_abs(:, 1));
%        p2 = compute_quadratic_mn_polynomials(model.points_abs, model.tr_center, model.fvalues);
%        mp2 = shift_polynomial(p2{1}, -model.points_abs(:, model.tr_center));
%        error1 = 0;
%        error2 = 0;
%        for m = 1:points_num
%            error1 = error1 + abs(evaluate_polynomial(mp1, model.points_abs(:, m)) - model.fvalues(1, m));
%            error2 = error2 + abs(evaluate_polynomial(mp2, model.points_abs(:, m)) - model.fvalues(1, m));
%        end
%        if check
%            1;
%        end
%     end

part=78; subp=6; print_soln_body;
end