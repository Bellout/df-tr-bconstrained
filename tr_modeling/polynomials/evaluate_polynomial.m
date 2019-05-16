function [ value prob ] = evaluate_polynomial(polynomial, point, prob)
% Evaluates polynomial in given point

[ nr nc ] = size(polynomial.coefficients);

% ----------------------------------------------------------
% fprintf(prob.fid_evaluatePolynomial, ...
%         [ repmat('%22.12e ', 1, nr) '\n'] , polynomial.coefficients);

% fprintf([ repmat('%22.12e ', 1, nr) '\n'] , polynomial.coefficients);

% ----------------------------------------------------------
fprintf(prob.fid_coefficientsToMatrices, ...
        [ '[ --> ' pad('evaluatePolynomial()', 38) ']' ]);
[c, g, H] = coefficients_to_matrices(polynomial.dimension, ...
                                     polynomial.coefficients, prob);

terms = [c, g'*point, 0.5*(point'*H*point)];
part=67; subp=1; print_soln_body;

terms = sort(terms);
value = (terms(1) + terms(2)) + terms(3);

end

