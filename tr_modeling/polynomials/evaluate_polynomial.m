function value = evaluate_polynomial(polynomial, point)
% Evaluates polynomial in given point

[ nr nc ] = size(polynomial.coefficients);
fid = fopen('polyn_coeff_prob1_orig.txt','a');
fprintf(fid, [ repmat('%22.12e ', 1, nr) '\n'] , polynomial.coefficients);
fclose(fid);

% ----------------------------------------------------------
[c, g, H] = coefficients_to_matrices(polynomial.dimension, ...
                                     polynomial.coefficients);

terms = [c, g'*point, 0.5*(point'*H*point)];
terms = sort(terms);

value = (terms(1) + terms(2)) + terms(3);


end

