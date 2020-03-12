function [] = printxf(x, fval, tc, prob)
  frmtx = '%12.6e  ';
  frmtf = '%12.6e';

  fprintf(prob.dbg_iters_fid, '%s', prob.flnstr);
  fprintf(prob.dbg_iters_fid, [ '\nx* = ' repmat(frmtx, 1, size(x, 1))], x');
  fprintf(prob.dbg_iters_fid, [ '\nf* = ' repmat(frmtf, size(fval, 2), 1)], fval);
  fprintf(prob.dbg_iters_fid, [ '\ntc: %s' ], tc);

  fprintf([ '\nx* = ' repmat(frmtx, 1, size(x, 1))], x);
  fprintf([ '\nf* = ' repmat(frmtf, size(fval, 2), 1)], fval);
end