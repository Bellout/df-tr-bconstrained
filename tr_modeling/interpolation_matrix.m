function [M prob] = interpolation_matrix(polynomials, points, prob)

    prob.cf = 'interpolation_matrix';

    M = zeros(size(points, 2), length(polynomials));
    for m = 1:size(points, 2)
        for n = 1:length(polynomials)
            fprintf(prob.fid_evaluatePolynomial, ['\n[ --> interpolationMatrix ]\n']);
            [M(m, n) prob] = evaluate_polynomial(polynomials(n), points(:, m), prob);
        end
    end
end