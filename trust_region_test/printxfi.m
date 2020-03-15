function [] = printxfi(x, fval, prob)
  frmtx = '%12.6e ';
  frmtf = '%12.6e ';

  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, '%s\n', prob.pn);

  fprintf(prob.dbg_iters_fid, [ 'x0 = ' repmat(frmtx, 1, size(x, 1)) '\n' ], x(:,1)');
  fprintf(prob.dbg_iters_fid, [ 'f0 = ' repmat(frmtf, size(fval, 1), 1) '\n' ], fval(1));

  fprintf(prob.dbg_iters_fid, [ 'x1 = ' repmat(frmtx, 1, size(x, 1)) '\n' ], x(:,2)');
  fprintf(prob.dbg_iters_fid, [ 'f1 = ' repmat(frmtf, size(fval, 1), 1) '\n' ], fval(2));  

  fprintf(prob.dbg_iters_fid, '%s\n%s\n', prob.flnstr, prob.lbl);

end