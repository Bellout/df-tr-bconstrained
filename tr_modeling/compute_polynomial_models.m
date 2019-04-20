function [polynomials prob] = compute_polynomial_models(model, prob)
    
    % fprintf('%s\n', 'Calling compute_polynomial_models');
    [dim, points_num] = size(model.points_abs);
    functions_num = size(model.fvalues, 1);
    
    linear_terms = dim+1;
    full_q_terms = (dim + 1)*(dim + 2)/2;
    lastwarn('');

    part=66; subp=1; print_soln_body;

    ca = (linear_terms < points_num);
    cb = (points_num < full_q_terms);
    if  ca && cb

        part=66; subp=2; print_soln_body;
        % Compute quadratic model
        % fprintf('%s\n', 'Calling compute quadratic model');
        [polynomials prob] = ...
            compute_quadratic_mn_polynomials(model.points_abs, ...
                                             model.tr_center, ...
                                             model.fvalues, ...
                                             prob);
    end
    [~, wid] = lastwarn();

    cc = (points_num <= linear_terms);
    cdd = (points_num == full_q_terms);
    ce = strcmp(wid, 'cmg:badly_conditioned_system');
    if cc || cdd || ce

        % Compute model with incomplete (complete) basis
        % fprintf('%s\n', 'Compute model with incomplete (complete) basis');
        [l_alpha prob] = ...
            nfp_finite_differences(model.points_shifted, ...
                                   model.fvalues, ...
                                   model.pivot_polynomials(1:points_num), ...
                                   prob);
        
        for k = functions_num:-1:1
            
            [polynomials{k} prob]  = ...
                combine_polynomials(model.pivot_polynomials(1:points_num), ...
                                    l_alpha(k, :), prob);

            fprintf(prob.fid_shiftPolynomial, ['\n[ computePolynomialModels() ]\n']);
            [polynomials{k} prob] = shift_polynomial(polynomials{k}, ...
                                                     model.points_shifted(:, model.tr_center),...
                                                     prob);
        end
        part=66; subp=3; print_soln_body;
        % fprintf(['\nl_alpha:\n' repmat('%22.12e',1,2) '\n'], l_alpha);
    end
end
