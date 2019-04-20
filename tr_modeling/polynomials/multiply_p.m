function [polynomial prob] = multiply_p(polynomial, factor, prob)
% Multiplies a polynomial by a constant factor

polynomial.coefficients  = factor*polynomial.coefficients;

if (max(isnan(polynomial.coefficients)))
    error('cmg:nancoeff', 'NaN coefficient');
end

part=69; subp=1; print_soln_body;

end

