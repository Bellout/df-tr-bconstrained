function [model, exitflag, prob] = ensure_improvement(model, ...
                                                funcs, ...
                                                bl, bu, ...
                                                options, ...
                                                prob)

  % ------------------------------------------------------------------
  [model_complete prob] = is_complete(model, prob);
  model_fl = is_lambda_poised(model, options);
  [model_old prob] = is_old(model, options, prob);
  success = false;

  % ------------------------------------------------------------------  
  if ~model_complete && (~model_old || ~model_fl)

    part=56; print_soln_body;
    % Calculate a new point to add
    fprintf('%s\n', 'Calling improve_model_nfp');
    [model, success, prob] = improve_model_nfp(model, ...
                                         funcs, ...
                                         bl, bu, ...
                                         options, ...
                                         prob);
    if success
        exitflag = 1;
    end

  elseif model_complete && ~model_old

    part=57; print_soln_body;
    % Replace some point with a new one that improves geometry
    fprintf('%s\n', 'Calling choose_and_replace_point');
    [model, success, prob] = choose_and_replace_point(model, ...
                                                funcs, ...
                                                bl, bu, ...
                                                options, ...
                                                prob);
    if success
        exitflag = 2;
    end

  end

  % ------------------------------------------------------------------
  if ~success

    part=58; print_soln_body;
    [model, changed, prob] = rebuild_model(model, options, prob); 

    % ----------------------------------------------------------------
    if ~changed
      if ~model_complete

        % Improve model
        part=59; print_soln_body;
        fprintf('%s\n', 'Calling improve_model_nfp2');
        [model, success, prob] = improve_model_nfp(model, ...
                                             funcs, ...
                                             bl, bu, ...
                                             options, ...
                                             prob);
      else

        % Replace point
        part=60; print_soln_body;
        fprintf('%s\n', 'Calling choose_and_replace_point2');
        [model, success, prob] = choose_and_replace_point(model, ...
                                                    funcs, ...
                                                    bl, bu, ...
                                                    options, ...
                                                    prob);
      end
    else
      part=61; print_soln_body;
      success = true;
    end

    % ----------------------------------------------------------------
    if model_old
      part=62; print_soln_body;
      exitflag = 3;
    else
      part=63; print_soln_body;
      exitflag = 4;
    end
  end
  part=64; print_soln_body;
end
