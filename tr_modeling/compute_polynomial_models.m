function polynomials = compute_polynomial_models(model)
    
    
    [dim, points_num] = size(model.points_abs);
    functions_num = size(model.fvalues, 1);
    
    linear_terms = dim+1;
    full_q_terms = (dim + 1)*(dim + 2)/2;
    lastwarn('');
    if  linear_terms < points_num && points_num < full_q_terms
        % Compute quadratic model
        polynomials = compute_quadratic_mn_polynomials(model.points_abs, ...
                                                       model.tr_center, ...
                                                       model.fvalues);
    end
    [~, wid] = lastwarn();
    if points_num <= linear_terms || points_num == full_q_terms || ...
            strcmp(wid, 'cmg:badly_conditioned_system')
        % Compute model with incomplete (complete) basis
        l_alpha = nfp_finite_differences(model.points_shifted, ...
                                         model.fvalues, ...
                                         model.pivot_polynomials(1: ...
                                                          points_num));
        for k = functions_num:-1:1
            polynomials{k}  = ...
                combine_polynomials(model.pivot_polynomials(1:points_num), ...
                                    l_alpha(k, :));
            polynomials{k} = shift_polynomial(polynomials{k}, ...
                                              model.points_shifted(:, ...
                                                              model.tr_center));
        end
    end
end
