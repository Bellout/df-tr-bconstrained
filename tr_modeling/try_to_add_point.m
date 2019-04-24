function [model, exitflag, prob] = ...
  try_to_add_point(model, new_point, ...
                   new_fvalues, funcs, ...
                   bl, bu, options, prob)

  fprintf('%s\n', 'Calling try_to_add_point');
  % Step was not accepted. Smaller effort in including point
  point_added = false;
  part=76; subp=1; print_soln_body;
  
  % ------------------------------------------------------------------
  if ~is_complete(model, prob)

    % Add this point
    relative_pivot_threshold = options.add_threshold;
    
    part=76; subp=2; print_soln_body;
    fprintf(prob.fid_addPoint, ['[ tryToAddPoint() ]\n']);
    [model, point_added, prob] = add_point(model, new_point, ...
                                     new_fvalues, ...
                                     relative_pivot_threshold, ...
                                     prob);
  end

  % ------------------------------------------------------------------
  if ~point_added

    % Save information about this new point, just not to lose
    model.cached_points = [new_point, model.cached_points];
    model.cached_fvalues = [new_fvalues, model.cached_fvalues];

    part=76; subp=3; print_soln_body;
    % ----------------------------------------------------------------
    % Either add a geometry improving point or rebuild model
    fprintf(prob.fid_ensureImprovement, ['[ tryToAddPoint() ]\n']);
    [model, exitflag, prob] = ensure_improvement(model, ...
                                           funcs, ...
                                           bl, bu, ...
                                           options, ...
                                           prob);

  else
    exitflag = 1;
  end

end