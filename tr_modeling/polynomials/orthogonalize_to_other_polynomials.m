function [polynomial prob] = ...
        orthogonalize_to_other_polynomials(all_polynomials, ...
                                           poly_i, points, ...
                                           last_pt, prob)

  polynomial = all_polynomials(poly_i);
  for n = 1 : last_pt
    if n ~= poly_i
        [polynomial prob] = zero_at_point(polynomial, ...
                                   all_polynomials(n), ...
                                   points(:, n), ...
                                   prob);
    end
  end

  part=121; subp=1; print_soln_body;
    
end

    