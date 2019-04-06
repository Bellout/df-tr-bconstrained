function [model, exitflag, prob] = ...
  try_to_add_point(model, new_point, ...
                   new_fvalues, funcs, ...
                   bl, bu, options, prob)

  % Step was not accepted. Smaller effort in including point
  point_added = false;
  
  % ------------------------------------------------------------------
  if ~is_complete(model)
    % Add this point
    relative_pivot_threshold = options.add_threshold;
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

    % ----------------------------------------------------------------
    % Either add a geometry improving point or rebuild model
    [model, exitflag, prob] = ensure_improvement(model, ...
                                           funcs, ...
                                           bl, bu, ...
                                           options, ...
                                           prob);

  else
    exitflag = 1;
  end

end