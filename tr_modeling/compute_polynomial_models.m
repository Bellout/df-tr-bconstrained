function [polynomials prob] = compute_polynomial_models(model, prob)
    
    fprintf('%s\n', 'Calling compute_polynomial_models');
    [dim, points_num] = size(model.points_abs);
    functions_num = size(model.fvalues, 1);
    
    linear_terms = dim+1;
    full_q_terms = (dim + 1)*(dim + 2)/2;
    lastwarn('');

    if  linear_terms < points_num && points_num < full_q_terms

        % Compute quadratic model
        fprintf('%s\n', 'Calling compute quadratic model');
        [polynomials prob] = compute_quadratic_mn_polynomials(model.points_abs, ...
                                                       model.tr_center, ...
                                                       model.fvalues, ...
                                                       prob);
    end
    [~, wid] = lastwarn();
    if points_num <= linear_terms || points_num == full_q_terms || ...
            strcmp(wid, 'cmg:badly_conditioned_system')

        % Compute model with incomplete (complete) basis
        fprintf('%s\n', 'Compute model with incomplete (complete) basis');
        [l_alpha prob] = nfp_finite_differences(model.points_shifted, ...
                                         model.fvalues, ...
                                         model.pivot_polynomials(1: ...
                                                          points_num), ...
                                         prob);
        for k = functions_num:-1:1
            
            [polynomials{k} prob]  = ...
                combine_polynomials(model.pivot_polynomials(1:points_num), ...
                                    l_alpha(k, :), prob);

            [polynomials{k} prob] = shift_polynomial(polynomials{k}, ...
                                                     model.points_shifted(:, model.tr_center),...
                                                     prob);
        end
        fprintf(['\nl_alpha:\n' repmat('%22.12e',1,2) '\n'], l_alpha);
    end
end
