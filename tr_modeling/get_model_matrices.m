function [c, g, H, prob] = get_model_matrices(model, m, prob)
%GET_MODEL_POLYNOMIAL Summary of this function goes here
%   Detailed explanation goes here

    [c, g, H] = get_matrices(model.modeling_polynomials{m + 1});
    part=30; print_soln_body;
    

end

