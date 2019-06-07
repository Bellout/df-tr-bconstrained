function [model, exitflag, prob] = ...
  ensure_improvement(model, funcs, bl, bu, ...
                     options, prob)

  % ------------------------------------------------------------------
  [model_complete prob] = is_complete(model, prob);
  model_fl = is_lambda_poised(model, options);
  [model_old prob] = is_old(model, options, prob);
  success = false;

  if ~model_complete && (~model_old || ~model_fl)

    % ----------------------------------------------------------------
    part=56; print_soln_body;
    % Calculate a new point to add
    % fprintf('%s\n', 'Calling improve_model_nfp');
    fprintf(prob.fid_improveModelNfp, ...
            [ '[ --> ' pad('ensureImprovement()[a]', 38) ']' ]);
    [model, success, prob] = improve_model_nfp(model, funcs, ...
                                         bl, bu, options, prob);

    if success
        exitflag = 1;
    end

  elseif model_complete && ~model_old

    % ----------------------------------------------------------------
    part=57; print_soln_body;
    % Replace some point with a new one that improves geometry
    % fprintf('%s\n', 'Calling choose_and_replace_point');
    fprintf(prob.fid_chooseAndReplacePoint, ...
            [ '[ --> ' pad('ensureImprovement()[a]', 38) ']' ]);
    [model, success, prob] = choose_and_replace_point(model, funcs, ...
                                                bl, bu, options, prob);

    if success
        exitflag = 2;
        % exit_flag=%i [after choose_and_replace_point]
        part=65; print_soln_body;
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
        % fprintf('%s\n', 'Calling improve_model_nfp2');
        fprintf(prob.fid_improveModelNfp, ...
                [ '[ --> ' pad('ensureImprovement()[b]', 38) ']' ]);
        [model, success, prob] = improve_model_nfp(model, funcs, ...
                                             bl, bu, options, prob);

      else

        % Replace point
        part=60; print_soln_body;
        % fprintf('%s\n', 'Calling choose_and_replace_point2');
        fprintf(prob.fid_chooseAndReplacePoint, ...
                [ '[ --> ' pad('ensureImprovement()[b]', 38) ']' ]);        
        [model, success, prob] = choose_and_replace_point(model, funcs, ...
                                                    bl, bu, options, prob);

      end
    else
      success = true;
      % After call of improve_model_nfp() is model is
      % not complete, or choose_and_replace_point()
      part=61; print_soln_body;
    end

    % ----------------------------------------------------------------
    if model_old
      exitflag = 3;
      % exit_flag=%i [after model is old
      part=62; print_soln_body;
    else
      exitflag = 4;
      % exit_flag=%i [after model has changed/is new]
      part=63; print_soln_body;
    end
  end

  % ------------------------------------------------------------------
  % exit_flag=%i [is no success after improve_model_nfp()
  % or choose_and_replace_point()
  part=64; print_soln_body;
end
