function [polynomial_shifted prob] = shift_polynomial(polynomial, s, prob)
    
    [c, g, H] = get_matrices(polynomial);

    c_mod = c + g'*s + 0.5*(s'*H*s);
    g_mod = g + H*s;
    
    polynomial_shifted = matrices_to_polynomial(c_mod, g_mod, H);

    part=21; print_soln_body;
    
end
