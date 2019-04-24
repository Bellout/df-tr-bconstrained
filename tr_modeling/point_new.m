function [new_points, new_pivot_values, point_found, prob] = ...
      point_new(polynomial, x_tr_center, radius, bl, bu, ...
                pivot_threshold, prob)

  % ------------------------------------------------------------------
  % Print polynomial [-polynomial_max] (input data)
  part=0; print_soln_body;
  part=5; print_soln_body;  

  % ------------------------------------------------------------------
  fprintf(prob.fid_minimizeTr, ['[ pointNew() ]\n']);
  [new_point_min, pivot_min, exitflag_min, prob] = minimize_tr(polynomial, ...
                                                    x_tr_center, ...
                                                    radius, bl, bu, ...
                                                    prob, true);

  [polynomial_max prob] = multiply_p(polynomial, -1, prob);

  % ------------------------------------------------------------------
  [new_point_max, pivot_max, exitflag_max, prob] = ...
  minimize_tr(polynomial_max, ...
              x_tr_center, ...
              radius, bl, bu, ...
              prob, true);

  % ------------------------------------------------------------------
  if (exitflag_min >= 0) && (abs(pivot_min) >= pivot_threshold)

      if (exitflag_max >= 0) && (abs(pivot_max)  >= abs(pivot_min))
          new_points = [new_point_max, new_point_min];
          new_pivot_values = [pivot_max, pivot_min];
          point_found = true;

      elseif (exitflag_max >= 0) && (abs(pivot_max)  >= pivot_threshold)
          new_points = [new_point_min, new_point_max];
          new_pivot_values = [pivot_min, pivot_max];
          point_found = true;

      else
          new_points = new_point_min;
          new_pivot_values = pivot_min;
          point_found = true;
      end

  % ------------------------------------------------------------------
  elseif (exitflag_max >= 0) && (abs(pivot_max)  >= pivot_threshold)
      new_points = new_point_max;
      new_pivot_values = pivot_max;
      point_found = true;

  else
      point_found = false;
      new_points = [];
      new_pivot_values = 0;

  end

  % ------------------------------------------------------------------
  % Print new points found (output data)
  part=0; print_soln_body;
  part=7; print_soln_body; 

end
