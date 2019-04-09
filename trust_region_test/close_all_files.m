function close_all_files(prob)
% close_all_files.m

fclose(prob.fid_checkInterpolation);
fclose(prob.fid_evaluatePolynomial);
fclose(prob.fid_minimizeTr);
fclose(prob.fid_solveTrSubproblem);
fclose(prob.fid_reCenterPoints);