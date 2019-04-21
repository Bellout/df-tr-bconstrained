function print_iteration(iter, fval, rho, radius, points, prob)

    fprintf(1, '% 4d    % +10.3g    % 9.3g    % 9.3g    % 4d\n', iter, fval, rho, radius, points);
    fprintf(prob.dbg_file_fid, '% 4d    % +10.3g    % 9.3g    % 9.3g    % 4d\n', iter, fval, rho, radius, points);

end