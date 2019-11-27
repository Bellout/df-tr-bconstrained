function print_iteration(iter, fval, rho, radius, points, prob)

    fprintf(1, '% 4d    % +10.3g    % 9.3g    % 9.3g    % 4d\n', iter, fval, rho, radius, points);

    % fprintf(prob.dbg_iters_fid, ...
    %         '% 4d    % +10.3g    % 9.3g    % 9.3g    % 4d\n', ...
    %         iter, fval, rho, radius, points);

    if isinf(rho)

      fprintf(prob.dbg_iters_fid, ...
              '%4d  % 4.3e  % 10s  % 4.3e  %3d\n', ...
              iter, fval, rho, radius, points);

    else

      fprintf(prob.dbg_iters_fid, ...
              '%4d  % 4.3e  % 4.3e  % 4.3e  %3d\n', ...
              iter, fval, rho, radius, points);

    end

end