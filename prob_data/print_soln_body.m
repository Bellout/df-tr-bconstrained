
ENDSTRNN = [ repmat('-', 1, 60) '\n\n\n' ];
ENDSTRN = [ repmat('-', 1, 60) '\n\n' ];
ENDSTR = [ repmat('-', 1, 60) '\n' ];
STARTSTR = [ repmat('=', 1, 60) '\n' ];

COUNTSTR = [ repmat('<', 1, 28) ' %02.0f ' repmat('>', 1, 28) '\n' ];

m22_12 = prob.m22_12;

switch(part)

case 0

  % ------------------------------------------------------------------
  % Set formats for x and f
  mf = '%20.16f';
  mE = '%20.16E';
  m22_12 = '%20.10e';
  tab = '            ';
  % tab = '';

  ln = repmat('=',1,30);
  ln2 = repmat('-',1,30);

case 1

  % ------------------------------------------------------------------
  frmt1 = [ repmat(mf, 1, size(initial_points,1)) '\n'];
  frmt1_cpp = ...
  [ repmat([mf ', '], 1, size(initial_points,1)-1) [mf '; \n']];

  frmt2 = [ mf '\n' ];
  frmt2_cpp = [ mf ';\n\n' ];
  frmt3 = [ repmat('%12.1f ', 1, size(old_seed.State,1)) '\n\n'];

  % ------------------------------------------------------------------
  % Print prob name
  fprintf(prob.fid, ['\n' tab '// ' ln ln ln '\n'], prob.pn);
  fprintf(prob.fid, [tab '// ' ln '  %s  ' ln '\n'], prob.pn);
  fprintf(prob.fid, [tab '// ' ln ln ln '\n\n'], prob.pn);
  fprintf(prob.fid, [tab '%s.name = "%s";\n' ], prob.pn, prob.pn);

  % ------------------------------------------------------------------
  % Print seed
  fprintf(prob.fid, [tab '// seed.Type: ' '%s\n'], old_seed.Type);
  fprintf(prob.fid, [tab '// seed.Seed: ' '%6.0f\n'], old_seed.Seed);
  fprintf(prob.fid, [tab '// seed.State:' frmt3], old_seed.State);

case 2

  % ------------------------------------------------------------------
  % Print initial points + obj.fvals to file
  fprintf(prob.fid, [tab '// --- %s ---\n'], 'Initial points');

  for ii = 1 : size(initial_points, 2)
    fprintf(prob.fid, ...
            [tab '// x' num2str(ii) ': ' frmt1], initial_points(:, ii));
    fprintf(prob.fid, ...
            [tab '// f' num2str(ii) ': ' frmt2], initial_fvalues(:, ii));
  end

  % fprintf(prob.fid,'\n');

  % ------------------------------------------------------------------
  tlt = [ 'C++ [PRINT RESIZE] INITIAL POINTS' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.xm.resize(' ...
    num2str(size(initial_points, 1)) ',' ...
    num2str(size(initial_points, 2)) ');']);

  fprintf(prob.fid, '%s\n\n', ...
    [tab prob.pn '.fm.resize(' ...
    num2str(size(initial_fvalues, 1)) ',' ...
    num2str(size(initial_fvalues, 2)) ');']);

  % ------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR INITIAL POINTS

  for ii = 1 : size(initial_points, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.xm.col(' num2str(ii-1) ') << ' frmt1_cpp], ...
            initial_points(:, ii));
    fprintf(prob.fid, ...
            [tab prob.pn '.fm.col(' num2str(ii-1) ') << ' frmt2_cpp], ...
            initial_fvalues(:, ii));
  end

case 3

  % ------------------------------------------------------------------
  %  Collect data

  xm = model.points_abs;
  fm = model.fvalues;

  cm = model.tr_center;
  rm = model.radius;

  sm = model.points_shifted;

  % model.pivot_polynomials;
  % -> 1×6 struct array with fields: dimension, coefficients
  pm = model.pivot_polynomials;
  vm = model.pivot_values;

  % --------------------------------------------------------------------
  tlt = [ 'C++ [PRINT RESIZE] TR_CENTER, TR_RADIUS, POINTS_SHIFTED' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.cm.resize(' ...
    num2str(size(cm, 1)) ',' ...
    num2str(size(cm, 2)) '); // model.tr_center [index]']);

  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.rm.resize(' ...
    num2str(size(rm, 1)) ',' ...
    num2str(size(rm, 2)) '); // model.tr_radius']);

  fprintf(prob.fid, '%s\n\n', ...
    [tab prob.pn '.sm.resize(' ...
    num2str(size(sm, 1)) ',' ...
    num2str(size(sm, 2)) '); // points_shifted']);

  % --------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_cm = [ repmat([mf ', '], 1, size(cm,1)-1) [mf '; \n']];
  frmt_rm = [ repmat([mf ', '], 1, size(rm,1)-1) [mf '; \n']];
  frmt_sm = [ repmat([mf ', '], 1, size(sm,1)-1) [mf '; \n']];

  % --------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR TR_CENTER, TR_RADIUS, POINTS_SHIFTED
  fprintf(prob.fid, [tab '// Trust region center:\n']);
  for ii = 1 : size(cm, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.cm.col(' num2str(ii-1) ') << ' frmt_cm], ...
            cm(:, ii));
  end

  fprintf(prob.fid, [tab '// Trust region radius:\n']);
  for ii = 1 : size(rm, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.rm.col(' num2str(ii-1) ') << ' frmt_rm], ...
            rm(:, ii));
  end

  fprintf(prob.fid, [tab '// Points shifted:\n']);
  for ii = 1 : size(sm, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.sm.col(' num2str(ii-1) ') << ' frmt_sm], ...
            sm(:, ii));
  end

  % --------------------------------------------------------------------
  tlt = [ 'C++ [PRINT RESIZE] CALLS FOR PIVOT_POLYNOMIALS.COEFFICIENTS, ' ...
  'PIVOT_POLYNOMIALS.DIMENSION, MODEL.PIVOT_VALUES' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  % Matrix ([6x6]) of column vectors ([6x1])
  fprintf(prob.fid, [tab '// Matrix ([6x6]) of column vectors ([6x1])\n']);
  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.pcm.resize(' ...
    num2str(size(pm(1).coefficients, 1)) ',' ...
    num2str(size(pm, 2)) '); // model.pivot_polynomials.coefficients']);

  % Matrix ([1x6]) of column vectors ([1x1])
  fprintf(prob.fid, [tab '// Matrix ([1x6]) of column vectors ([1x1])\n']);
  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.pdm.resize(' ...
    num2str(size(pm(1).dimension, 1)) ',' ...
    num2str(size(pm, 2)) '); // model.pivot_polynomials.dimension']);

  % Column vector ([6x1])
  fprintf(prob.fid, [tab '// Column vector ([6x1])\n']);
  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.vm.resize(' ...
    num2str(size(vm, 2)) ',' ...
    num2str(size(vm, 1)) '); // model.pivot_values']);

  % --------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_pcm = [ repmat([mf ', '], 1, size(pm(1).coefficients,1)-1) [mf '; \n']];
  frmt_pdm = [ repmat([mf ', '], 1, size(pm(1).dimension,1)-1) [mf '; \n']];
  frmt_vm = [ repmat([mf ', '], 1, size(vm,2)-1) [mf '; \n']];

  % --------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR PIVOT_POLYNOMIALS.COEFFICIENTS,
  % PIVOT_POLYNOMIALS.DIMENSION, MODEL.PIVOT_VALUES
  fprintf(prob.fid, '\n');
  fprintf(prob.fid, [tab '// Pivot polynomials (coeff):\n']);
  for ii = 1 : size(pm, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.pcm.col(' num2str(ii-1) ') << ' frmt_pcm], ...
            pm(ii).coefficients);
  end

  fprintf(prob.fid, [tab '// Pivot polynomials (dim):\n']);
  for ii = 1 : size(pm, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.pdm.col(' num2str(ii-1) ') << ' frmt_pdm], ...
            pm(ii).dimension);
  end

  fprintf(prob.fid, [tab '// Pivot values:\n']);
  for ii = 1 : size(vm, 1)
    fprintf(prob.fid, ...
            [tab prob.pn '.vm.col(' num2str(ii-1) ') << ' frmt_vm], ...
            vm(ii,:));
  end

case 4

  % ------------------------------------------------------------------
  %  Collect data

  % model.modeling_polynomials:
  % cell struct containing structs -> {[1×1 struct]}
  % each struct constains fields:
  % dimension: [double]
  % coefficients: [6×1 double]

  mp = model.modeling_polynomials;

  % --------------------------------------------------------------------
  tlt = [ 'C++ [PRINT RESIZE] MODELING COEFFICIENTS' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  % Matrix ([6x6]) of column vectors ([6x1])
  fprintf(prob.fid, [tab '// Matrix ([6x6]) of column vectors ([6x1])\n']);
  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.mcm.resize(' ...
    num2str(size(mp{1}.coefficients, 1)) ',' ...
    num2str(size(mp, 2)) '); // model.modeling_polynomials.coefficients']);

  % Matrix ([1x6]) of column vectors ([1x1])
  fprintf(prob.fid, [tab '// Matrix ([1x6]) of column vectors ([1x1])\n']);
  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.mdm.resize(' ...
    num2str(size(mp{1}.dimension, 1)) ',' ...
    num2str(size(mp, 2)) '); // model.modeling_polynomials.dimension']);

  % --------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_mcm = [ repmat([mf ', '], 1, size(mp{1}.coefficients,1)-1) [mf '; \n']];
  frmt_mdm = [ repmat([mf ', '], 1, size(mp{1}.dimension,1)-1) [mf '; \n']];

  % --------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR MODELING_POLYNOMIALS.COEFFICIENTS,
  % MODELING_POLYNOMIALS.DIMENSION
  fprintf(prob.fid, '\n');
  fprintf(prob.fid, [tab '// Modeling polynomials (coeff):\n']);
  for ii = 1 : size(mp, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.mcm.col(' num2str(ii-1) ') << ' frmt_mcm], ...
            mp{ii}.coefficients);
  end

  fprintf(prob.fid, [tab '// Pivot polynomials (dim):\n']);
  for ii = 1 : size(mp, 2)
    fprintf(prob.fid, ...
            [tab prob.pn '.mdm.col(' num2str(ii-1) ') << ' frmt_mdm], ...
            mp{ii}.dimension);
  end

case 5

  % ------------------------------------------------------------------
  %  Collect data
  pnp = polynomial;

  % ------------------------------------------------------------------
  tlt = [ 'C++ POINT NEW FUNCTION ' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.pnp.resize(' ...
    num2str(size(pnp.coefficients, 1)) ',' ...
    num2str(size(pnp.coefficients, 2)) ');']);

  % ------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_pnp = [ repmat([mf ', '], 1, size(pnp.coefficients,1)-1) [mf '; \n']];

  % ------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR NEW POINT POLYNOMIALS.COEFFICIENTS,
  fprintf(prob.fid, [tab '// Polynomial [-polynomial_max] (input data):\n']);
  fprintf(prob.fid, ...
        [tab prob.pn '.pnp.col(' num2str(1-1) ') << ' frmt_pnp], ...
        pnp.coefficients);
  fprintf(prob.fid, [tab prob.pn '.v_pnp.push_back(' prob.pn '.pnp);\n' ]);

case 6

  % ------------------------------------------------------------------
  %  Collect data
  obp = obj_pol ;

  % ------------------------------------------------------------------
  tlt = [ 'C++ POINT SOLVE TR SUBPROBLEM ' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  fprintf(prob.fid, '%s\n', ...
    [tab prob.pn '.obp.resize(' ...
    num2str(size(obp.coefficients, 1)) ',' ...
    num2str(size(obp.coefficients, 2)) ');']);

  % ------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_obp = [ repmat([mf ', '], 1, size(obp.coefficients,1)-1) [mf '; \n']];

  % ------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR NEW POINT POLYNOMIALS.COEFFICIENTS,
  fprintf(prob.fid, [tab '// Polynomial [-polynomial_max] (input data):\n']);
  fprintf(prob.fid, ...
        [tab prob.pn '.obp.col(' num2str(1-1) ') << ' frmt_obp], ...
        obp.coefficients);
  fprintf(prob.fid, [tab prob.pn '.v_obp.push_back(' prob.pn '.obp);\n' ]);

case 7

  % ------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_newp = [ repmat([mf ', '], 1, size(new_points,1)-1) [mf '; \n']];

  % ------------------------------------------------------------------
  fprintf(prob.fid, '\n');
  fprintf(prob.fid, [tab '// New points (output data) - > new_points = [new_point_max, new_point_min];:\n']);
  fprintf(prob.fid, [tab '// ' frmt_newp ], new_points);

case 9

  % ------------------------------------------------------------------
  % tlt = [ 'C++ SOLVE TR SUBPROBLEM (POST) ' ];
  % fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  % ------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_trlp = [ repmat([mf ', '], 1, size(trial_point,1)-1) [mf '; \n']];

  % ------------------------------------------------------------------
  fprintf(prob.fid, [tab '// Trial point found (output data):\n']);
  fprintf(prob.fid, [tab '// ' frmt_trlp ], trial_point);




















case 8

  % ------------------------------------------------------------------
  % minimize_tr()

  % C++ [FORMAT]
  m22_12 = prob.m22_12;
  frmt_bnd  = [ '[' repmat([m22_12 ', '], 1, size(bl_mod,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(x,1)-1) [m22_12 ' ] \n']];
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(polynomial.coefficients,2)-1) [m22_12 ' ] \n']];
  frmt_tr_c = [ '[' repmat([m22_12 ', '], 1, size(x_tr_center,1)-1) [m22_12 ' ] \n']];

  % ------------------------------------------------------------------
  fprintf(prob.dbg_file_fid, '\n%s', 'minimizeTr');
  fprintf(prob.fid_minimizeTr, ['[ minimizeTr() ]\n']);

  fprintf(prob.fid_minimizeTr, ['radius                         [' m22_12 ' ]\n' ], radius);
  fprintf(prob.fid_minimizeTr, ['x_tr_center.lpNorm<Infinity>() [' m22_12 ' ]\n' ], tol_arg);
  fprintf(prob.fid_minimizeTr, ['tol_tr                         [' m22_12 ' ]\n' ], tol_tr);
  fprintf(prob.fid_minimizeTr, ['p.coeffs                       ' frmt_p ], polynomial.coefficients');

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug x0 + bounds_mod:\n']);
  fprintf(prob.fid_minimizeTr, ['x0 = x_tr_center               ' frmt_x ], x0);
  fprintf(prob.fid_minimizeTr, ['bl_mod                         ' frmt_bnd ], bl_mod);
  fprintf(prob.fid_minimizeTr, ['bu_mod                         ' frmt_bnd ], bu_mod);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_minimizeTr, ['c:      [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_minimizeTr, ['g:      ' frmt_g ], g);
  fprintf(prob.fid_minimizeTr, ['H:      ' frmt_H ], H);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug computed gx, xHx values:\n']);
  fprintf(prob.fid_minimizeTr, ['gx:    [ ' [m22_12 ' ]\n'] ], gx);
  fprintf(prob.fid_minimizeTr, ['xHx:   [ ' [m22_12 ' ]\n'] ], xHx);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug xsol, fval [fmincon/SNOPT]:\n']);
  fprintf(prob.fid_minimizeTr, ['xsol:     ' frmt_x ], x);
  fprintf(prob.fid_minimizeTr, ['fval:     [' [m22_12 ' ]\n'] ], fval);
  fprintf(prob.fid_minimizeTr, ['exitflag: [ %i ]\n' ], exitflag);

  fprintf(prob.fid_minimizeTr, ENDSTRNN);

case 10



case 11

  % ------------------------------------------------------------------
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(model.points_abs,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n\n%s', 'checkInterpolation[0]');
  fprintf(prob.fid_checkInterpolation, ['[ checkInterpolation() ]\n']);
  fprintf(prob.fid_checkInterpolation, ['radius         [ ' m22_12 ' ]\n' ], model.radius);
  fprintf(prob.fid_checkInterpolation, ['tol_1          [ ' m22_12 ' ]\n' ], tol_1);
  fprintf(prob.fid_checkInterpolation, ['tol_2          [ ' m22_12 ' ]\n' ], tol_2);
  fprintf(prob.fid_checkInterpolation, ['idx_tr_center  [ %i ]\n' ], model.tr_center);
  fprintf(prob.fid_checkInterpolation, ['n_points       [ %i ]\n' ], n_points);
  fprintf(prob.fid_checkInterpolation, ['x_tr_center    ' frmt_x ], model.points_abs(:, model.tr_center)');

  for c = size(h,2):-1:1
    fprintf(prob.fid_checkInterpolation, ['h(:, c)      ' frmt_x ], h(:, c));
  end

case 12

  % ------------------------------------------------------------------
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

  % fprintf(prob.dbg_file_fid, '\n%s', 'checkInterpolation[1]');
  % fprintf(prob.fid_checkInterpolation, '\n');
  % fprintf(prob.fid_checkInterpolation, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_checkInterpolation, ['c:      [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_checkInterpolation, ['g:      ' frmt_g ], g);
  fprintf(prob.fid_checkInterpolation, ['H:      ' frmt_H ], H);

case 13

  % ------------------------------------------------------------------
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_A    = [ '[' repmat([m22_12 ', '], 1, size(A,1)-1) [m22_12 ' ] \n']];

  % fprintf(prob.dbg_file_fid, '\n%s', 'checkInterpolation[2]');

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['cval        [' [m22_12 ' ]\n'] ], this_value);
  fprintf(prob.fid_checkInterpolation, ['cdiff       [' [m22_12 ' ]\n'] ], difference);
  fprintf(prob.fid_checkInterpolation, ['max_diff    [' [m22_12 ' ]\n'] ], max_diff);

  fprintf(prob.fid_checkInterpolation, ENDSTR);
  fprintf(prob.fid_checkInterpolation, ['A: fvalues(k, :)      ' frmt_A ], A);
  fprintf(prob.fid_checkInterpolation, ['B: max(fvalues(k, :)) [' [m22_12 ' ]\n'] ], B);
  fprintf(prob.fid_checkInterpolation, ['C: tol_1*B            [' [m22_12 ' ]\n'] ], C);
  fprintf(prob.fid_checkInterpolation, ['D: max(C, tol_2)      [' [m22_12 ' ]\n'] ], D);

  fprintf(prob.fid_checkInterpolation, ENDSTR);

case 14

  % ------------------------------------------------------------------
  % solveTrSubproblem()

  m22_12 = prob.m22_12;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(obj_pol.coefficients,2)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(x_tr_center,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(current_fval,1)-1) [m22_12 ' ] \n']];

  switch subp

  case 1

    fprintf(prob.dbg_file_fid, '\n%s\n', 'solveTrSubproblem[0]');

    fprintf(prob.fid_solveTrSubproblem, [ '[ solveTrSubproblem() ]\n'] );
    fprintf(prob.fid_solveTrSubproblem, [ 'idx_tr_center          [ %i ]\n'], model.tr_center);
    fprintf(prob.fid_solveTrSubproblem, [ 'tr_center_pt           ' frmt_x ], x_tr_center');
    fprintf(prob.fid_solveTrSubproblem, [ 'orig.p.coeffs          ' frmt_p ], obj_pol_o.coefficients');
    fprintf(prob.fid_solveTrSubproblem, [ 'shifted.p.coeffs       ' frmt_p ], obj_pol_s.coefficients');

    fprintf(prob.fid_solveTrSubproblem, [ 'current_f              ' frmt_f ], current_fval);
    fprintf(prob.fid_solveTrSubproblem, [ 'trial_f                ' frmt_f ], trial_fval);
    fprintf(prob.fid_solveTrSubproblem, [ '(current_f <= trial_f) [ %i ]\n\n'], (current_fval <= trial_fval));

  case 2

    % fprintf(prob.dbg_file_fid, '\n%s', 'solveTrSubproblem[1]');

    fprintf(prob.fid_solveTrSubproblem, [ 'points_abs_#%i          ' frmt_x ], k, model.points_abs(:, k)');
    fprintf(prob.fid_solveTrSubproblem, [ 'f_poly(points_abs_#%i)  ' frmt_f ], k, val);
    fprintf(prob.fid_solveTrSubproblem, [ 'f_real(points_abs_#%i)  ' frmt_f ], k, model.fvalues(1, k));

    fprintf(prob.fid_solveTrSubproblem, [ 'err_interp             ' frmt_f ], error_interp);
    fprintf(prob.fid_solveTrSubproblem, [ 'tol_interp             ' frmt_f ], tol_interp);
    fprintf(prob.fid_solveTrSubproblem, [ '(err_ip > tol_ip)      [ %i ]\n' ], (error_interp > tol_interp));

    fprintf(prob.fid_solveTrSubproblem, ENDSTRNN);

  end


case 15

  % ------------------------------------------------------------------
  % reCenterPoints() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'reCenterPoints[0]');

  fprintf(prob.fid_reCenterPoints, STARTSTR);
  fprintf(prob.fid_reCenterPoints, [ '[ --> ' pad('rebuildModel()', 38) ']' ]);
  fprintf(prob.fid_reCenterPoints, ['[ reCenterPoints() ]\n']);

  fprintf(prob.fid_reCenterPoints, ['\nValues b/f reCentering\n']);
  fprintf(prob.fid_reCenterPoints, [ 'dim                    [ %i ]\n' ], size(points_abs,1));
  fprintf(prob.fid_reCenterPoints, [ 'n_points               [ %i ]\n' ], size(points_abs,2));
  fprintf(prob.fid_reCenterPoints, [ 'tr_center              [ %i ]\n' ], model.tr_center);
  fprintf(prob.fid_reCenterPoints, ENDSTR);

  fprintf(prob.fid_reCenterPoints, ['all_points [b/f]     ' frmt_x ], points_abs);
  fprintf(prob.fid_reCenterPoints, ['all_fvalues [b/f]    ' frmt_f ], fvalues');
  fprintf(prob.fid_reCenterPoints, ENDSTR);

case 16

  % ------------------------------------------------------------------
  % reCenterPoints() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'reCenterPoints[1]');
      fprintf(prob.fid_reCenterPoints, ['distances [b/f]      ' frmt_f ], distances');
      % fprintf(prob.fid_reCenterPoints, ['index_vector [b/f]   ' frmt_f ], pt_order');
      
      fprintf(prob.fid_reCenterPoints, ['dist.sz                [ %i ]\n' ], size(distances,2));

    case 2
      fprintf(prob.fid_reCenterPoints, ['idxvec.sz              [ %i ]\n' ], size(pt_order,2));
      fprintf(prob.fid_reCenterPoints, ['points_shifted [b/f] ' frmt_x ], points_shifted);
      fprintf(prob.fid_reCenterPoints, ENDSTR);

    case 3

      fprintf(prob.fid_reCenterPoints, ['Values a/f reCentering\n']);
      fprintf(prob.fid_reCenterPoints, ['all_points [a/f]     ' frmt_x ], points_abs);
      fprintf(prob.fid_reCenterPoints, ['all_fvalues [a/f]    ' frmt_f ], fvalues');
      fprintf(prob.fid_reCenterPoints, ENDSTR);

      fprintf(prob.fid_reCenterPoints, ['distances [a/f]      ' frmt_f ], distances'); 
      fprintf(prob.fid_reCenterPoints, ['index_vector [a/f]   ' frmt_f ], pt_order');

      fprintf(prob.fid_reCenterPoints, ['points_shifted [a/f] ' frmt_x ], points_shifted);
      fprintf(prob.fid_reCenterPoints, ENDSTR);
  end






case 17

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(pivot_values,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s\n\n', 'rowPivotGaussianElimination[0]');


  % fprintf(prob.fid_rowPivotGaussianElimination, '\n\n');
  fprintf(prob.fid_rowPivotGaussianElimination, STARTSTR);

  fprintf(prob.fid_rowPivotGaussianElimination, [ '[ --> ' pad('rebuildModel()', 38) ']' ]);
  fprintf(prob.fid_rowPivotGaussianElimination, ['[ rowPivotGaussianElimination() ]\n']);
  % fprintf(prob.fid_rowPivotGaussianElimination, ['rebuildModel() -> rowPivotGaussianElimination()\n']);

  fprintf(prob.fid_rowPivotGaussianElimination, ['\nValues b/f rowPivotGaussianElimination\n']);

  fprintf(prob.fid_rowPivotGaussianElimination, ['poly_i          [ %i ]\n' ], poly_i);
  fprintf(prob.fid_rowPivotGaussianElimination, ['last_pt_incld   [ %i ]\n' ], last_pt_included);
  fprintf(prob.fid_rowPivotGaussianElimination, ['dim             [ %i ]\n' ], dim);

  fprintf(prob.fid_rowPivotGaussianElimination, ['all_points      ' frmt_x ], points_abs);
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_fvalues     ' frmt_f ], fvalues');
  fprintf(prob.fid_rowPivotGaussianElimination, ['fvalues         ' frmt_f ], model.fvalues');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_values    ' frmt_p ], pivot_values);
  fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted);

  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

case 18

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[1]');

  fprintf(prob.fid_rowPivotGaussianElimination, ['iter            [ %i ]\n' ], iter);
  fprintf(prob.fid_rowPivotGaussianElimination, ['polynomials_num [ %i ]\n' ], polynomials_num);
  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

  % fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_threshold ' frmt_f ], pivot_threshold');
  fprintf(prob.fid_rowPivotGaussianElimination, ['farthest_pt     ' frmt_f ], distances(end));
  fprintf(prob.fid_rowPivotGaussianElimination, ['radius          ' frmt_f ], radius);

  fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], piv_p');
  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

case 19

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  switch subp
    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[2]-Linear');
    case 2
      fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[2]-Quad');
  end

  fprintf(prob.fid_rowPivotGaussianElimination, ['%s\n'], str_blck);
  fprintf(prob.fid_rowPivotGaussianElimination, ['max_layer       ' frmt_f ], maxlayer);
  fprintf(prob.fid_rowPivotGaussianElimination, ['dist_farthest_pt' frmt_f ], distances(end)/radius);

  fprintf(prob.fid_rowPivotGaussianElimination, ['iter            [ %i ]\n' ], iter);
  fprintf(prob.fid_rowPivotGaussianElimination, ['block_beginning [ %i ]\n' ], block_beginning);
  fprintf(prob.fid_rowPivotGaussianElimination, ['block_end       [ %i ]\n' ], block_end);
  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

case 20

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_l    = [ '[' repmat([m22_12 ', '], 1, size(all_layers,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(pivot_values,1)-1) [m22_12 ' ] \n']];

  % fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[3]');
  fprintf(prob.fid_rowPivotGaussianElimination, '%s\n', 'all_layers.setLinSpaced');
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_layers      ' frmt_l ], all_layers);
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_values    ' frmt_p ], pivot_values);
  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

case 21

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_shifted(:, n),1)-1) [m22_12 ' ] \n']];

  switch subp
    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[4]-break');
      fprintf(prob.fid_rowPivotGaussianElimination, ['n               [ %i ]\n' ], n);
      fprintf(prob.fid_rowPivotGaussianElimination, ['dist_max        [ %i ]\n' ], dist_max);
      fprintf(prob.fid_rowPivotGaussianElimination, ['p_ini           [ %i ]\n' ], p_ini);


    case 2

      fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[4]');
      fprintf(prob.fid_rowPivotGaussianElimination, ['n               [ %i ]\n' ], n);
      fprintf(prob.fid_rowPivotGaussianElimination, ['poly_i          [ %i ]\n' ], poly_i);
      fprintf(prob.fid_rowPivotGaussianElimination, ['p.size()        [ %i ]\n' ], length(pivot_polynomials));

    case 3

      % fprintf(prob.fid_rowPivotGaussianElimination, '\n');
      % fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[4]');
      fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);
      fprintf(prob.fid_rowPivotGaussianElimination, ['n               [ %i ]\n' ], n);
      fprintf(prob.fid_rowPivotGaussianElimination, ['distances(n)    ' frmt_f ], distances(n));
      fprintf(prob.fid_rowPivotGaussianElimination, ['val             ' frmt_f ], val);

      fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], piv_p');
      fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted(:, n));
      fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

  end



case 22

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_shifted(:, n),1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[5]');

  fprintf(prob.fid_rowPivotGaussianElimination, 'abs(max_absval) > pivot_threshold\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pt_next         [ %i ]\n' ], pt_next);
  fprintf(prob.fid_rowPivotGaussianElimination, ['pt_max          [ %i ]\n' ], pt_max);


  if (pt_next ~= pt_max)
    fprintf(prob.fid_rowPivotGaussianElimination, 'pt_next != pt_max\n');
    fprintf(prob.fid_rowPivotGaussianElimination, ['all_points      ' frmt_x ], points_abs);
    fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted(:, n));
    fprintf(prob.fid_rowPivotGaussianElimination, ['all_fvalues     ' frmt_f ], fvalues');
    fprintf(prob.fid_rowPivotGaussianElimination, ['distances       ' frmt_f ], distances');
  end

  fprintf(prob.fid_rowPivotGaussianElimination, ['max_absval       ' frmt_f ], max_absval);
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_values     ' frmt_p ], pivot_values);
  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

case 23
  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[6]');
  fprintf(prob.fid_rowPivotGaussianElimination, 'orthogonalizeToOtherP\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], piv_p');

case 24
  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;

  [pr pc] = size(pivot_polynomials); % [1 6]
  frmt_p  = [ '[' repmat([m22_12 ', '], 1, size(pivot_polynomials(1).coefficients,2)-1) [m22_12 ' ] \n']];

  switch subp
    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[7] - orthogonalize_block');
    case 2
     fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[7] - pivot exchange');
  end

  switch subp
    case 1
      fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);
      fprintf(prob.fid_rowPivotGaussianElimination, ['%s\n'], str_pts);
      fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);
    case 2
      fprintf(prob.fid_rowPivotGaussianElimination, ['%s\n'], str_pts);
      fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);
  end

  fprintf(prob.fid_rowPivotGaussianElimination, ['poly_i          [ %i ]\n' ], poly_i);
  fprintf(prob.fid_rowPivotGaussianElimination, ['last_pt_incld   [ %i ]\n' ], last_pt_included);
  fprintf(prob.fid_rowPivotGaussianElimination, ['dim             [ %i ]\n' ], dim);

  for (ii=1:6)
    p = pivot_polynomials(ii).coefficients;
    fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], p');
    fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);
  end

case 25
  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(pivot_values,1)-1) [m22_12 ' ] \n']];

  % fprintf(prob.dbg_file_fid, '\n%s', 'rowPivotGaussianElimination[8]');
  fprintf(prob.fid_rowPivotGaussianElimination, '\nValues a/f rowPivotGaussianElimination\n');

  fprintf(prob.fid_rowPivotGaussianElimination, ['poly_i          [ %i ]\n' ], poly_i);
  fprintf(prob.fid_rowPivotGaussianElimination, ['last_pt_incld   [ %i ]\n' ], last_pt_included);
  fprintf(prob.fid_rowPivotGaussianElimination, ['dim             [ %i ]\n' ], dim);

  fprintf(prob.fid_rowPivotGaussianElimination, ['all_points      ' frmt_x ], points_abs);
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_fvalues     ' frmt_f ], fvalues');
  fprintf(prob.fid_rowPivotGaussianElimination, ['fvalues         ' frmt_f ], model.fvalues');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_values    ' frmt_p ], pivot_values);
  fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted);

  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);
  fprintf(prob.fid_rowPivotGaussianElimination, ['points_abs      ' frmt_x ], model.points_abs);

  fprintf(prob.fid_rebuildModel, ['[ rebuildModel() ]\n']);
  fprintf(prob.fid_rebuildModel, ['last_pt_included [ %i ]\n' ], last_pt_included);
  fprintf(prob.fid_rebuildModel, ['n_points         [ %i ]\n' ], p_ini);
  fprintf(prob.fid_rebuildModel, ENDSTR);

  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);






































case 26

  % ------------------------------------------------------------------ 17
  % moveToBestPoint()
    m22_12 = prob.m22_12;

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'moveToBestPoint[0]');

      % fprintf(prob.fid_moveToBestPoint, STARTSTR);
      fprintf(prob.fid_moveToBestPoint, ['[ moveToBestPoint() ]\n']);
      fprintf(prob.fid_moveToBestPoint, ['idx_tr_center [ %i ]\n'], model.tr_center);
      fprintf(prob.fid_moveToBestPoint, ['idx_best_i    [ %i ]\n'], best_i);

    case 2
      m22_12 = prob.m22_12;
      % fprintf(prob.dbg_file_fid, '\n%s', 'moveToBestPoint[1]');
      fprintf(prob.fid_moveToBestPoint, ['idx_tr_center [ %i ]\n'], model.tr_center);

      fprintf(prob.fid_moveToBestPoint, ENDSTR);


    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'moveToBestPoint[2]');
      fprintf(prob.fid_moveToBestPoint, ENDSTR);

  end


case 28

  % ------------------------------------------------------------------
  % measureCriticality()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(grad,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n\n%s\n', 'measureCriticality[0]');
  fprintf(prob.dbg_file_fid, '\n\n%s\n', ...
          '============================================================');

  fprintf(prob.fid_measureCriticality, ['[ measureCriticality() ]\n']);
  % fprintf(prob.fid_measureCriticality, ['Debug p-matrices g:\n']);
  fprintf(prob.fid_measureCriticality, ['g  ' frmt_g ], grad);
  % fprintf(prob.fid_measureCriticality, '\n');
  fprintf(prob.fid_measureCriticality, ['x_center             ' frmt_g ], x_center');
  fprintf(prob.fid_measureCriticality, ['A: (x_center - grad) ' frmt_g ], A');
  fprintf(prob.fid_measureCriticality, ['B: max(bl, A)        ' frmt_g ], B');
  fprintf(prob.fid_measureCriticality, ['C: min(bu, B)        ' frmt_g ], C');
  fprintf(prob.fid_measureCriticality, ['D: C - x_center      ' frmt_g ], m');

  fprintf(prob.fid_measureCriticality, ENDSTR);

case 29

  % ------------------------------------------------------------------
  % shiftPolynomial()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(s,1)-1) [m22_12 ' ] \n']];
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'shiftPolynomial[0]');
  fprintf(prob.fid_shiftPolynomial, ['[ shiftPolynomial() ]\n']);
  fprintf(prob.fid_shiftPolynomial, ['s:      ' frmt_x ], s);

  fprintf(prob.fid_shiftPolynomial, '\n');
  fprintf(prob.fid_shiftPolynomial, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_shiftPolynomial, ['c:      [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_shiftPolynomial, ['g:      ' frmt_g ], g);
  fprintf(prob.fid_shiftPolynomial, ['H:      ' frmt_H ], H);

  fprintf(prob.fid_shiftPolynomial, '\n');
  fprintf(prob.fid_shiftPolynomial, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_shiftPolynomial, ['c_mod:  [' [m22_12 ' ]\n'] ], c_mod);
  fprintf(prob.fid_shiftPolynomial, ['g_mod:  ' frmt_g ], g_mod);

  fprintf(prob.fid_shiftPolynomial, ENDSTRNN);

case 30

  % ------------------------------------------------------------------
  % getModelMatrices()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'getModelMatrices[0]');
  fprintf(prob.fid_getModelMatrices, ['[ getModelMatrices() ]\n']);
  % fprintf(prob.fid_getModelMatrices, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_getModelMatrices, ['c:  [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_getModelMatrices, ['g:  ' frmt_g ], g);
  fprintf(prob.fid_getModelMatrices, ['H:  ' frmt_H ], H);

  fprintf(prob.fid_getModelMatrices, ENDSTR);

case 31

  % ------------------------------------------------------------------
  % criticalityStep()

  m22_12 = prob.m22_12;

  switch subp

    case 1
        fprintf(prob.dbg_file_fid, '\n%s', 'criticalityStep[0]');
        fprintf(prob.fid_criticalityStep, ['[ criticalityStep() ]\n']);

    case 2
        % fprintf(prob.dbg_file_fid, '\n%s', 'criticalityStep[1]');
        fprintf(prob.fid_criticalityStep, '\n');
        fprintf(prob.fid_criticalityStep, ['A: ~is_lambda_poised() [' [m22_12 ' ]\n'] ], ~is_lambda_poised(model, options));
        fprintf(prob.fid_criticalityStep, ['B: is_old()            [' [m22_12 ' ]\n'] ], is_old(model, options, prob));

    case 3

   end

  % fprintf(prob.fid_criticalityStep, ['x_center             ' frmt_x ], model.x_tr_center');
  % fprintf(prob.fid_criticalityStep, ['crit_measure         ' frmt_x ], crit_measure);

case 32

  % ------------------------------------------------------------------
  % criticalityStep()

  m22_12 = prob.m22_12;
  % fprintf(prob.dbg_file_fid, '\n%s', 'criticalityStep[2]');
  fprintf(prob.fid_criticalityStep, ['[ criticalityStep() -> break]\n']);

  fprintf(prob.fid_criticalityStep, '\n');
  fprintf(prob.fid_criticalityStep, ['C: (radius < tol_rad)  [' [m22_12 ' ]\n'] ], C);
  fprintf(prob.fid_criticalityStep, ['D: norm(measr_crit)    [' [m22_12 ' ]\n'] ], D);
  fprintf(prob.fid_criticalityStep, ['E: (beta*B < tol_f)    [' [m22_12 ' ]\n'] ], E);
  fprintf(prob.fid_criticalityStep, ['F: (rad < 100*tol_rad) [' [m22_12 ' ]\n'] ], F);
  fprintf(prob.fid_criticalityStep, ['G: (A || C && D)  <-?  [' [m22_12 ' ]\n'] ], G);

case 33

  % ------------------------------------------------------------------
  % criticalityStep()

  m22_12 = prob.m22_12;
  % fprintf(prob.dbg_file_fid, '\n%s', 'criticalityStep[3]');
  fprintf(prob.fid_criticalityStep, '\n');
  fprintf(prob.fid_criticalityStep, ['H: norm(masr_crit)  [' [m22_12 ' ]\n'] ], H);
  fprintf(prob.fid_criticalityStep, ['I: beta*A           [' [m22_12 ' ]\n'] ], I);
  fprintf(prob.fid_criticalityStep, ['J: max(radius, B)   [' [m22_12 ' ]\n'] ], J);
  fprintf(prob.fid_criticalityStep, ['K: min(C, init_rad) [' [m22_12 ' ]\n'] ], K);

  fprintf(prob.fid_criticalityStep, ENDSTRNN);






case 34

  % ------------------------------------------------------------------
  % improveModelNfp()

  m22_12 = prob.m22_12;
  frmt_ps = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_sc = [ '[' repmat([m22_12 ', '], 1, size(shift_center,1)-1) [m22_12 ' ] \n']];
  frmt_scs = [ '[' repmat(['%22s' ', '], 1, size(shift_center,1)-1) ['%22s' ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[0]');
  fprintf(prob.fid_improveModelNfp, ['[ improveModelNfp() ]\n']);
  fprintf(prob.fid_improveModelNfp, ['shift_center     ' frmt_sc ], shift_center);

  if(abs(bl_shifted(1)) == Inf)
    fprintf(prob.fid_improveModelNfp, ['bl_shifted       [                 -inf,               -inf  ]\n' ]);
    fprintf(prob.fid_improveModelNfp, ['bu_shifted       [                  inf,                inf  ]\n' ]);
  else
    fprintf(prob.fid_improveModelNfp, ['bl_shifted       ' frmt_sc ], bl_shifted);
    fprintf(prob.fid_improveModelNfp, ['bu_shifted       ' frmt_sc ], bu_shifted);
  end

  fprintf(prob.fid_improveModelNfp, ['#points_shifted  [ %i ]\n' ], size(points_shifted,2));
  fprintf(prob.fid_improveModelNfp, ['points_shifted   ' frmt_ps ], points_shifted);
  fprintf(prob.fid_improveModelNfp, ['tr_center_pt     ' frmt_ps ], tr_center_pt);

  % fprintf(prob.fid_improveModelNfp, ['tol_shift       [' [m22_12 ' ]\n'] ], tol_shift);

case 35

  % ------------------------------------------------------------------
  % improveModelNfp()

  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[1]');
  fprintf(prob.fid_improveModelNfp, '\n');
  fprintf(prob.fid_improveModelNfp, ['A: (tr_center_pt.lpNorm<Inf>() > radius_fac*radius) [ %i ]\n'], A);
  fprintf(prob.fid_improveModelNfp, ['B: (p_ini > dim+1)                                  [ %i ]\n'], B);

  fprintf(prob.fid_improveModelNfp, ['\n%s\n'], str_mstat0);
  fprintf(prob.fid_improveModelNfp, ['C: (p_ini < polynomials_num)                        [ %i ]\n'], C);
  fprintf(prob.fid_improveModelNfp, ['D: (p_ini < dim + 1)                                [ %i ]\n'], D);
  fprintf(prob.fid_improveModelNfp, ['%s\n'], str_mstat1);

case 36
  % ------------------------------------------------------------------
  % improveModelNfp()
switch subp
  case 1
    fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[2]');
    fprintf(prob.fid_improveModelNfp, ['%s %i/3\n'], str_att0, attempts);

  case 2
    fprintf(prob.fid_improveModelNfp, ['%s %i)\n'], str_att1, poly_i);
    fprintf(prob.fid_improveModelNfp, ['Re-orthogonalize (orthogonalizeToOtherPolynomials)\n']);
end

case 37
  % ------------------------------------------------------------------
  % improveModelNfp()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(new_pivot_value,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[3]');

  fprintf(prob.fid_improveModelNfp, '\n');
  fprintf(prob.fid_improveModelNfp, ['%i new pts/pivot-pts found (T/F:%i)\n'], ...
          size(new_points_shifted,2), point_found);
  fprintf(prob.fid_improveModelNfp, ['For-loop[3]: (found_i < nfp_new_points_shifted_.cols()) (%i/%i)\n'], ...
          found_i, length(new_points_shifted));

  fprintf(prob.fid_improveModelNfp, ['nfp_new_point_shifted ' frmt_x ], new_point_shifted);
  fprintf(prob.fid_improveModelNfp, ['nfp_new_point_abs     ' frmt_x ], new_point_abs);
  fprintf(prob.fid_improveModelNfp, ['nfp_new_pivots        ' frmt_p ], new_pivot_value);
  fprintf(prob.fid_improveModelNfp, 'uuid#0: {00000000-0000-0000-0000-000000000000}\n');

  fprintf(prob.fid_improveModelNfp, '\nnew_case -> impr_case\n');
  fprintf(prob.fid_improveModelNfp, 'Return-for-loop[3]: issue return->iterate()\n');
  fprintf(prob.fid_improveModelNfp, '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n');

  % fprintf(prob.fid_improveModelNfp, ['nfp_new_point_abs     ' frmt_f ], new_fvalues');

case 38
  % ------------------------------------------------------------------
  % improveModelNfp()

  m22_12 = prob.m22_12;
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(new_point_shifted,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[4]');
  fprintf(prob.fid_improveModelNfp, ['%s %i)\n'], str_att1, poly_i);

  fprintf(prob.fid_improveModelNfp, '\nUsing previously computed pts/pivot-vals\n');
  fprintf(prob.fid_improveModelNfp, ['For-loop[3]: (found_i < nfp_new_points_shifted_.cols()) (%i/%i)\n'], ...
          found_i, length(new_points_shifted));

  fprintf(prob.fid_improveModelNfp, 'uuid#0: {00000000-0000-0000-0000-000000000000}\n');
  fprintf(prob.fid_improveModelNfp, ['nfp_new_point_abs#%i  ' frmt_x ], ...
          size(new_point_abs,2)-1, new_point_abs);
    fprintf(prob.fid_improveModelNfp, ['nfp_new_fvalues#%i    ' frmt_f ], ...
          size(new_fvalues,1)-1, new_fvalues);

  fprintf(prob.fid_improveModelNfp, '\nc->GetState(): PEND\n');
  fprintf(prob.fid_improveModelNfp, 'Setting -> setAreImprPointsComputed(false)\n');

case 39
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[5]');
  fprintf(prob.fid_improveModelNfp, ['\nBreak-for-loop[3]: (found_i < new_points_shifted.cols()) '...
          'since f_succeeded.all()=%i\n'], f_succeeded);

case 40
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[6]');
  fprintf(prob.fid_improveModelNfp, 'End-for-loop[3]: (found_i < new_points_shifted.cols())\n');

case 41
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[7]');
  fprintf(prob.fid_improveModelNfp, '\nBreak-if: (point_found)\n');
  fprintf(prob.fid_improveModelNfp, 'Stop trying pivot polynomials for poly_i=(%i)\n', poly_i);

case 42
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[8]');
  fprintf(prob.fid_improveModelNfp, '\nEnd-if: (point_found)\n');

case 43
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[9]');
  fprintf(prob.fid_improveModelNfp, 'Break-for-loop[1]: (attempts<=3)\n');

case 44
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[10]');
  fprintf(prob.fid_improveModelNfp, '\nReduce radius if it did not break\n');

case 45
  % ------------------------------------------------------------------
  % improveModelNfp()
  % fprintf(prob.fid_improveModelNfp, '\n!areImprovementPointsComputed()[2] -> false\n');
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[11]');
  fprintf(prob.fid_improveModelNfp, 'End-for-loop[2]: (poly_i <= block_end)\n', poly_i);

case 46
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[12]');
  fprintf(prob.fid_improveModelNfp, 'End-for-loop[1]: (attempts<=3)\n');

case 47
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[13]');
  fprintf(prob.fid_improveModelNfp, 'Setting -> setAreImprPointsComputed(false)\n');
  fprintf(prob.fid_improveModelNfp, 'Update this polynomial in set\n');
  fprintf(prob.fid_improveModelNfp, 'Swap polynomials\n');

case 48
  % ------------------------------------------------------------------
  % improveModelNfp()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[14]');
  fprintf(prob.fid_improveModelNfp, '\n------------------------------------------\n');
  fprintf(prob.fid_improveModelNfp, 'If: (nfp_point_found_ && f_succeeded.all()\n');
  fprintf(prob.fid_improveModelNfp, 'pivot_polynomials_.sz():       %i\n', ...
          length(pivot_polynomials(poly_i).coefficients));

  fprintf(prob.fid_improveModelNfp, 'poly_i:                        %i\n', poly_i);
  fprintf(prob.fid_improveModelNfp, 'next_position:                 %i\n', next_position);

  % points_shifted_
  fprintf(prob.fid_improveModelNfp, 'points_shifted_.cols():        %i\n', size(ps,2));
  fprintf(prob.fid_improveModelNfp, 'points_shifted_.rows():        %i\n', size(ps,1));
  for ii=1:size(ps, 2)
    fprintf(prob.fid_improveModelNfp, ['points_shifted_#%i:             ' frmt_x ], ii, ps(:,ii)');
  end

  % nfp_new_point_shifted
  fprintf(prob.fid_improveModelNfp, 'nfp_new_point_shifted_.cols(): %i\n', size(nps,2));
  fprintf(prob.fid_improveModelNfp, 'nfp_new_point_shifted_.rows(): %i\n', size(nps,1));
  for ii=1:size(nps, 2)
    fprintf(prob.fid_improveModelNfp, ['nfp_new_point_shifted_#%i:      ' frmt_x ], ii, nps(:,ii)');
  end

  % points_abs
  fprintf(prob.fid_improveModelNfp, 'points_abs_.cols():            %i\n', size(pa,2));
  fprintf(prob.fid_improveModelNfp, 'points_abs_.rows():            %i\n', size(pa,1));
  for ii=1:size(pa, 2)
    fprintf(prob.fid_improveModelNfp, ['points_abs_#%i:                 ' frmt_x ], ii, pa(:,ii)');
  end

  % fvalues -> switch of dims (fv = model.fvalues;)
  fprintf(prob.fid_improveModelNfp, 'fvalues_.cols():               %i\n', size(fv,1));
  fprintf(prob.fid_improveModelNfp, 'fvalues_.rows():               %i\n', size(fv,2));
  for ii=1:size(fv, 2)
    fprintf(prob.fid_improveModelNfp, ['fvalues_#%i:                    ' frmt_f ], ii, fv(:,ii)');
  end
  fprintf(prob.fid_improveModelNfp, ENDSTR);

  % fprintf(prob.fid_improveModelNfp, '------------------------------------------\n\n');

  % fprintf(prob.fid_improveModelNfp, ['nfp_new_point_shifted ' frmt_x ], new_point_shifted);

case 49
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[15]');
  fprintf(prob.fid_improveModelNfp, 'Add point\n');

case 50
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[16]');
  fprintf(prob.fid_improveModelNfp, 'Normalize polynomial value\n');

case 51
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[17]');
  fprintf(prob.fid_improveModelNfp, ['Re-orthogonalize (orthogonalizeToOtherPolynomials)\n']);

case 52
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[18]');
  fprintf(prob.fid_improveModelNfp, [ 'Orthogonalize polynomials on present '...
          'block -- (deffering subsequent ones)\n' ]);

case 53
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[19]');
  fprintf(prob.fid_improveModelNfp, 'Update model and recompute polynomials\n');
  fprintf(prob.fid_improveModelNfp, 'Resize points_abs_\n');
  fprintf(prob.fid_improveModelNfp, 'Resize fvalues_\n');

case 54
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.dbg_file_fid, '\n%s', 'improveModelNfp[20]');

  fprintf(prob.fid_improveModelNfp, 'exit_flag=%i\n', exitflag);
  fprintf(prob.fid_improveModelNfp, '=====================================\n\n\n');

case 55
  % ------------------------------------------------------------------
  % improveModelNfp()

  % fprintf(prob.fid_minimizeTr, ENDSTRNN);











case 56
  % ------------------------------------------------------------------
  % ensureImprovement()
  m22_12 = prob.m22_12;
  ps = model.points_shifted;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(ps,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[0]');

  fprintf(prob.fid_ensureImprovement, ['[ ensureImprovement() ]\n']);
  fprintf(prob.fid_ensureImprovement, ['Calculate a new point to add\n']);

  fprintf(prob.fid_ensureImprovement, ['(!model_complete):         [ %i ]\n'], ~model_complete);
  fprintf(prob.fid_ensureImprovement, ['(!model_old || !model_fl): [ %i ]\n'], (~model_old || ~model_fl));
  fprintf(prob.fid_ensureImprovement, ['Call improveModelNfp()\n']);

  % points_shifted_
  fprintf(prob.fid_ensureImprovement, 'points_shifted_.cols():        %i\n', size(ps,2));
  fprintf(prob.fid_ensureImprovement, 'points_shifted_.rows():        %i\n', size(ps,1));
  for ii=1:size(ps, 2)
    fprintf(prob.fid_ensureImprovement, ['points_shifted_#%i:             ' frmt_x ], ii, ps(:,ii)');
  end

case 57
  % ------------------------------------------------------------------
  % ensureImprovement()
  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[1]');
  fprintf(prob.fid_ensureImprovement, ['Replace some point with new one improving geometry\n']);
  fprintf(prob.fid_ensureImprovement, ['Call chooseAndReplacePoint()\n']);

case 58
  % ------------------------------------------------------------------
  % ensureImprovement()
  switch subp

    case 1
      fprintf(prob.fid_ensureImprovement, ['[ ensureImprovement() ]\n']);
      fprintf(prob.fid_ensureImprovement, [ '(!success):      [ %i ]\n' ], cC);
      fprintf(prob.fid_ensureImprovement, [ 'exit_flag:       [ %i ]\n' ], exitflag);

    case 2
      fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[2]');
      fprintf(prob.fid_ensureImprovement, ['Rebuild model -> rebuildModel()\n']);

  end

case 59
  % ------------------------------------------------------------------
  % ensureImprovement()
  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[3]');
  fprintf(prob.fid_ensureImprovement, ['(!model_changed):         [ %i ]\n'], ~model_changed);
  fprintf(prob.fid_ensureImprovement, ['(!model_complete):        [ %i ]\n'], (~model_complete));
  fprintf(prob.fid_ensureImprovement, ['Improve model -> improveModelNfp()\n']);

case 60
  % ------------------------------------------------------------------
  % ensureImprovement()
  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[4]');
  fprintf(prob.fid_ensureImprovement, ['Replace point -> chooseAndReplacePoint()\n']);

case 61
  % ------------------------------------------------------------------
  % ensureImprovement()
  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[5]');
  fprintf(prob.fid_ensureImprovement, ['model_changed is true (success = %i)\n'], success);
  fprintf(prob.fid_ensureImprovement, ['(!!! exitflag not set for this outcome !!!))\n']);
  fprintf(prob.fid_ensureImprovement, ['[After call of improve_model_nfp() is model is ' ...
  'not complete, or choose_and_replace_point()\n']);

case 62
  % ------------------------------------------------------------------
  % ensureImprovement()
  msg = [ 'Model is old'];

  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[6]');
  fprintf(prob.fid_ensureImprovement, [ 'exit_flag=%i\n' ], exitflag);
  fprintf(prob.fid_ensureImprovement, [ '[ %s ]\n' ], msg);

case 63
  % ------------------------------------------------------------------
  % ensureImprovement()
  msg = [ 'Model has changed/is new'];

  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[7]');
  fprintf(prob.fid_ensureImprovement, [ 'exit_flag=%i\n' ], exitflag);
  fprintf(prob.fid_ensureImprovement, [ '[ %s ]\n' ], msg);

case 64
  % ------------------------------------------------------------------
  % ensureImprovement()
  msg = [ 'Success after improveModelNfp() or chooseAndReplacePoint()'];

  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[8]');
  fprintf(prob.fid_ensureImprovement, [ 'exit_flag=%i\n' ], exitflag);
  fprintf(prob.fid_ensureImprovement, [ '[ %s ]\n' ], msg);

  fprintf(prob.fid_ensureImprovement, ENDSTR);
  % fprintf(prob.fid_ensureImprovement, STARTSTR);

case 65
  % ------------------------------------------------------------------
  % ensureImprovement()
  fprintf(prob.dbg_file_fid, '\n%s', 'ensure_improvement[9]');
  fprintf(prob.fid_ensureImprovement, 'exit_flag=%i [after choose_and_replace_point]\n', exitflag);

  fprintf(prob.fid_ensureImprovement, ENDSTR);
  fprintf(prob.fid_ensureImprovement, STARTSTR);








case 66
  % ------------------------------------------------------------------
  % computePolynomialModels()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(model.tr_center,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(model.fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(model.points_abs,1)-1) [m22_12 ' ] \n']];

switch subp

  case 1
    fprintf(prob.dbg_file_fid, '\n\n%s\n', 'computePolynomialModels[0]');

    fprintf(prob.fid_computePolynomialModels, ['[ computePolynomialModels() ]\n']);
    fprintf(prob.fid_computePolynomialModels, ['linear terms:    [ %i ]\n'], linear_terms);
    fprintf(prob.fid_computePolynomialModels, ['full quad terms: [ %i ]\n'], full_q_terms);
    fprintf(prob.fid_computePolynomialModels, ['points_num:      [ %i ]\n'], points_num);

    fprintf(prob.fid_computePolynomialModels, ['points_abs_:      ' frmt_p ], model.points_abs);
    fprintf(prob.fid_computePolynomialModels, ['points_shifted_:  ' frmt_p ], model.points_shifted);

  case 2
    % fprintf(prob.dbg_file_fid, '\n%s', 'computePolynomialModels[1]');
    fprintf(prob.fid_computePolynomialModels, ['\nCompute quadratic model\n']);
    fprintf(prob.fid_computePolynomialModels, ['(linear_terms < points_num):  [ %i ]\n'], cA);
    fprintf(prob.fid_computePolynomialModels, ['(points_num < full_q_terms):  [ %i ]\n'], cB);
    fprintf(prob.fid_computePolynomialModels, ['tr_center_:                   [ %i ]\n'], model.tr_center);

  case 3
    % fprintf(prob.dbg_file_fid, '\n%s', 'computePolynomialModels[2]');
    fprintf(prob.fid_computePolynomialModels, ['\nCompute model w/ incomplete (complete) basis\n']);
    fprintf(prob.fid_computePolynomialModels, ['(points_num <= linear_terms): [ %i ]\n'], cC);
    fprintf(prob.fid_computePolynomialModels, ['(points_num == full_q_terms): [ %i ]\n'], cD);
    fprintf(prob.fid_computePolynomialModels, ['cmg:badly_conditioned_system: [ %i ]\n'], cE);
    fprintf(prob.fid_computePolynomialModels, ['last warning:                 [ %s  ]\n'], wid);

  case 4
    % fprintf(prob.dbg_file_fid, '\n%s', 'computePolynomialModels[3]');
    fprintf(prob.fid_computePolynomialModels, ['l_alpha:     ' frmt_x ], l_alpha');

  case 5

    fprintf(prob.fid_computePolynomialModels, ['points_abs_  ' frmt_p ], model.points_abs);
    fprintf(prob.fid_computePolynomialModels, ['p[0].coeffs: ' frmt_x ], ...
            polynomials{1}.coefficients');
    fprintf(prob.fid_computePolynomialModels, ENDSTR);

end

case 67
  % ------------------------------------------------------------------
  % evaluatePolynomial()

  m22_12 = prob.m22_12;
  frmt_p = [ '[' repmat([m22_12 ', '], 1, size(polynomial.coefficients,1)-1) [m22_12 ' ] \n']];
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(point,1)-1) [m22_12 ' ] \n']];

  TAB = [ repmat(' ', 1, 45) ];

  switch subp

    case 1
    fprintf(prob.dbg_file_fid, '%s --', 'evaluatePolynomial[0]');
    % fprintf(prob.fid_evaluatePolynomial, ['\n[ evaluatePolynomial() ]\n']);
    fprintf(prob.fid_evaluatePolynomial, ['p:  ' frmt_p ], polynomial.coefficients);
    fprintf(prob.fid_evaluatePolynomial, [ TAB 'ps: ' frmt_x ], point);

    % fprintf(prob.fid_evaluatePolynomial, ['c: ' m22_12 ' gx: ' m22_12 ' .5xHx: ' m22_12 '\n'], ...
    %         terms(1), terms(2), terms(3));
    % fprintf(prob.fid_evaluatePolynomial, ENDSTRNN);

  end

case 68
  % ------------------------------------------------------------------
  % addPolynomial()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(p1.coefficients,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '%s --', 'addPolynomial[0]');
      fprintf(prob.fid_addPolynomial, ['[ addPolynomial() ]\n']);
      fprintf(prob.fid_addPolynomial, ['p1: ' frmt_x ], p1.coefficients);
      fprintf(prob.fid_addPolynomial, ['p2: ' frmt_x ], p2.coefficients);
      fprintf(prob.fid_addPolynomial, ['ps: ' frmt_x ], polynomial.coefficients);

      fprintf(prob.fid_addPolynomial, ENDSTR);

  end


case 69
  % ------------------------------------------------------------------
  % multiplyPolynomial()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(polynomial.coefficients,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '%s --', 'multiplyPolynomial[0]');
      fprintf(prob.fid_multiplyPolynomial, ['[ multiplyPolynomial() ]\n']);
      fprintf(prob.fid_multiplyPolynomial, ['ps: ' frmt_x ], polynomial.coefficients);

      fprintf(prob.fid_multiplyPolynomial, ENDSTR);

  end

case 70
  % ------------------------------------------------------------------
  % nfpFiniteDifferences()
  m22_12 = prob.m22_12;
  frmt_a = [ '[' repmat([m22_12 ', '], 1, size(l_alpha,1)-1) [m22_12 ' ] \n']];
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(points,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s\n', 'nfpFiniteDifferences[0]');
      fprintf(prob.fid_nfpFiniteDifferences, ['[ nfpFiniteDifferences() ]\n']);
      fprintf(prob.fid_nfpFiniteDifferences, ['fvalues_:    ' frmt_a ], l_alpha');
      fprintf(prob.fid_nfpFiniteDifferences, ['points:      ' frmt_x ], points);
      fprintf(prob.fid_nfpFiniteDifferences, ENDSTR);

    case 2
      fprintf(prob.fid_nfpFiniteDifferences, ['m = dim+1:   [ %i ]\n'], dim+1);
      fprintf(prob.fid_nfpFiniteDifferences, ['points_num:  [ %i ]\n'], points_num);

    case 3
      fprintf(prob.fid_nfpFiniteDifferences, ['l_alpha(m):   ' frmt_a ], l_alpha(:, m));
      fprintf(prob.fid_nfpFiniteDifferences, ['l_alpha(n):   ' frmt_a ], l_alpha(:, n));
      fprintf(prob.fid_nfpFiniteDifferences, ['val:          ' frmt_a ], val);

    case 4
      fprintf(prob.fid_nfpFiniteDifferences, ['l_alpha:      ' frmt_a ], l_alpha');
      fprintf(prob.fid_nfpFiniteDifferences, ENDSTR);

  end

case 71
  % ------------------------------------------------------------------
  % isComplete()
  % part=71; subp=1; print_soln_body;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(model.points_abs,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'isComplete[0]');
      fprintf(prob.fid_isComplete, ['[ isComplete() ]\n']);
      fprintf(prob.fid_isComplete, ['points_abs_.cols():        [ %i ]\n'], points_num);
      fprintf(prob.fid_isComplete, ['max_terms:                 [ %i ]\n'], max_terms);
      fprintf(prob.fid_isComplete, ['(points_num >= max_terms): [ %i ]\n'], result);

      fprintf(prob.fid_isComplete, ['points_abs:           ' frmt_x ], model.points_abs);



      fprintf(prob.fid_isComplete, ENDSTR);

  end

case 72
  % ------------------------------------------------------------------
  % isOld()
  m22_12 = prob.m22_12;
  frmt_f = [ '[' repmat([m22_12 ', '], 1, size(radius_factor,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'isOld[0]');
      fprintf(prob.fid_isOld, ['\n[ isOld() ]\n']);
      fprintf(prob.fid_isOld, ['distance.lpNorm<Inf>:      ' frmt_f ], distance);
      fprintf(prob.fid_isOld, ['tr_rad_fac:                ' frmt_f ], radius_factor);
      fprintf(prob.fid_isOld, ['(dist > tr_rad_fac):       [ %i ]\n'], result);

      fprintf(prob.fid_isOld, ENDSTRNN);

  end

case 73
  % ------------------------------------------------------------------
  % computeQuadraticMNPolynomials()
  m22_12 = prob.m22_12;
  frmt_ps = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 0
      fprintf(prob.dbg_file_fid, '\n%s', 'computeQuadraticMNPolynomials[0]');
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['[ computeQuadraticMNPolynomials() ]\n']);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['center_i:                      [ %i ]\n'], center_i);

    case 1
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['m:                             [ %i ]\n'], m);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['m2:                            [ %i ]\n'], m2);

    case 2
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['points_abs_:                   ' frmt_ps ], points);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['fvalues_:                      ' frmt_f ], fvalues');

      fprintf(prob.fid_computeQuadraticMNPolynomials, ['ps = points_shifted:           ' frmt_ps ], points_shifted);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['fvalues_diff:                  ' frmt_f ], fvalues_diff');

      fprintf(prob.fid_computeQuadraticMNPolynomials, ['M = 0.5*(M.^2) + M; M=ps''*ps  [' [m22_12 ' ]\n'] ], M);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'computeQuadraticMNPolynomials[1]');
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['Solve symmetric system\n']);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['M_rcond                        [' [m22_12 ' ]\n'] ], M_rcond);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['mult_mn                        [' [m22_12 ' ]\n'] ], mult_mn);

      fprintf(prob.fid_computeQuadraticMNPolynomials, ENDSTRNN);

    case 4
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['Badly conditioned system\n']);

    case 5

  end

case 74
  % ------------------------------------------------------------------
  % chooseAndReplacePoint()

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'chooseAndReplacePoint[0]');
      fprintf(prob.fid_chooseAndReplacePoint, ['[ chooseAndReplacePoint() ]\n']);

      fprintf(prob.fid_chooseAndReplacePoint, ENDSTRNN);

  end

case 75
  % ------------------------------------------------------------------
  % pointNew()

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'pointNew[0]');
      fprintf(prob.fid_pointNew, ['[ pointNew() ]\n']);

      fprintf(prob.fid_pointNew, ENDSTRNN);

  end

case 76
  % ------------------------------------------------------------------
  % tryToAddPoint()

  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];
  frmt_cf = [ '[' repmat([m22_12 ', '], 1, size(model.cached_fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_cp = [ '[' repmat([m22_12 ', '], 1, size(model.cached_points,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'tryToAddPoint[0]');
      fprintf(prob.fid_tryToAddPoint, ['[ tryToAddPoint() ]\n']);
      % fprintf(prob.fid_tryToAddPoint, ['exit_flag:         [ %i ]\n' ], exitflag);

    case 2
      fprintf(prob.fid_tryToAddPoint, ['(~is_complete)     [ %i ]\n'], condA);
      fprintf(prob.fid_tryToAddPoint, ['points_abs:           ' frmt_x ], model.points_abs);

      fprintf(prob.fid_tryToAddPoint, ['[ Call AddPoint() ]\n']);
      fprintf(prob.fid_tryToAddPoint, ['rel_piv_threshold: [' [m22_12 ' ]\n'] ], relative_pivot_threshold);
      fprintf(prob.fid_tryToAddPoint, ['new_fvalues:       ' frmt_f ], new_fvalues);
      fprintf(prob.fid_tryToAddPoint, ['new_point:         ' frmt_x ], new_point);

    case 3

      fprintf(prob.fid_tryToAddPoint, ['(!point_added):    [ %i ]\n'], ~point_added);
      fprintf(prob.fid_tryToAddPoint, ['[ Call ensureImprovement() ]\n']);
      fprintf(prob.fid_tryToAddPoint, ['cached_fvalues     ' frmt_cf ], model.cached_fvalues');
      fprintf(prob.fid_tryToAddPoint, ['cached_points      ' frmt_cp ], model.cached_points);

    case 4
      % fprintf(prob.dbg_file_fid, '\n%s', 'tryToAddPoint[3]');
      fprintf(prob.fid_tryToAddPoint, ['exit_flag:         [ %i ]\n' ], exitflag);
      fprintf(prob.fid_tryToAddPoint, ENDSTR);

  end

case 77
  % ------------------------------------------------------------------
  % addPoint()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'addPoint[0]');

      fprintf(prob.fid_addPoint, ['[ addPoint() ]\n']);
      fprintf(prob.fid_addPoint, ['pivot_threshold:      [' [m22_12 ' ]\n'] ], pivot_threshold);
      fprintf(prob.fid_addPoint, ['new_point_shifted:    ' frmt_x ], new_point_shifted);
      fprintf(prob.fid_addPoint, ['shift_center:         ' frmt_x ], shift_center);
      fprintf(prob.fid_addPoint, ENDSTR);

      fprintf(prob.fid_addPoint, ['points_shifted:       ' frmt_x ], points_shifted);
      fprintf(prob.fid_addPoint, ENDSTR);
      fprintf(prob.fid_addPoint, ['points_abs:           ' frmt_x ], model.points_abs);
      fprintf(prob.fid_addPoint, ENDSTR);
      fprintf(prob.fid_addPoint, ['pivot_values:     ' frmt_f ], model.pivot_values);
      fprintf(prob.fid_addPoint, ENDSTR);

      fprintf(prob.fid_addPoint, ['next_position:        [ %i ]\n'], next_position);
      fprintf(prob.fid_addPoint, ['(next_position == 1): [ %i ]\n'], cB);
      fprintf(prob.fid_addPoint, ENDSTR);

    case 2
      fprintf(prob.fid_addPoint, ['next_position:     [ %i ]\n'], next_position);
      fprintf(prob.fid_addPoint, ['exit_flag:         [ %i ]\n'], exitflag);
      fprintf(prob.fid_addPoint, ['tr_center_:        [ %i ]\n'], model.tr_center);

    case 3
      fprintf(prob.fid_addPoint, ['next_position < poly_num: [ %i ]\n'], cC);
      fprintf(prob.fid_addPoint, ['next_position <= dim:     [ %i ]\n'], cD);
      fprintf(prob.fid_addPoint, ['pivot_value:              ' frmt_f ], pivot_value);
      fprintf(prob.fid_addPoint, ENDSTR);

      fprintf(prob.fid_addPoint, ['block_beginning:          [ %i ]\n'], block_beginning);
      fprintf(prob.fid_addPoint, ['block_end:                [ %i ]\n'], block_end);
      fprintf(prob.fid_addPoint, ['success:                  [ %i ]\n'], success);
      fprintf(prob.fid_addPoint, ENDSTR);

    case 4
      piv_p = pivot_polynomials(next_position).coefficients;
      frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

      fprintf(prob.fid_addPoint, ['[ normalizePolynomial() ]\n']);
      fprintf(prob.fid_addPoint, ['next_position:     [ %i ]\n'], next_position);
      fprintf(prob.fid_addPoint, ['new_point_shifted: ' frmt_x ], new_point_shifted);
      fprintf(prob.fid_addPoint, ['pivot_p.coeffs     ' frmt_p ], piv_p');
      fprintf(prob.fid_addPoint, ENDSTR);

    case 5
      piv_p = pivot_polynomials(next_position).coefficients;
      frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

      fprintf(prob.fid_addPoint, ['[ orthogonalizeToOtherPolynomials() ]\n']);
      fprintf(prob.fid_addPoint, ['next_position:     [ %i ]\n'], next_position);
      fprintf(prob.fid_addPoint, ['new_point_shifted: ' frmt_x ], new_point_shifted);
      fprintf(prob.fid_addPoint, ['pivot_p.coeffs     ' frmt_p ], piv_p');
      fprintf(prob.fid_addPoint, ENDSTR);

    case 6
      piv_p = pivot_polynomials(next_position).coefficients;
      frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

      fprintf(prob.fid_addPoint, ['[ orthogonalizeBlock() ]\n']);
      fprintf(prob.fid_addPoint, ['next_position:     [ %i ]\n'], next_position);
      fprintf(prob.fid_addPoint, ['block_beginning:   [ %i ]\n'], block_beginning);
      fprintf(prob.fid_addPoint, ['next_position-1:   [ %i ]\n'], next_position-1);
      fprintf(prob.fid_addPoint, ['new_point_shifted: ' frmt_x ], new_point_shifted);
      fprintf(prob.fid_addPoint, ENDSTR);

    case 7
      fprintf(prob.fid_addPoint, ['mod status:        [ %s ]\n'], ' ');
      fprintf(prob.fid_addPoint, ['exit_flag:         [ %i ]\n'], exitflag);
      fprintf(prob.fid_addPoint, ENDSTR);

    case 8
      fprintf(prob.fid_addPoint, ['mod status:        [ %s ]\n'], 'model full');
      fprintf(prob.fid_addPoint, ['exit_flag:         [ %i ]\n'], exitflag);
      fprintf(prob.fid_addPoint, ENDSTR);

    case 9
      fprintf(prob.fid_addPoint, ['exit_flag:         [ %i ]\n'], exitflag);
      fprintf(prob.fid_addPoint, ['next_position:     [ %i ]\n'], next_position);

      fprintf(prob.fid_addPoint, ['fvalues:          ' frmt_f ], model.fvalues);
      fprintf(prob.fid_addPoint, ENDSTR);
      fprintf(prob.fid_addPoint, ['pivot_values:     ' frmt_f ], model.pivot_values);
      fprintf(prob.fid_addPoint, ENDSTR);

      fprintf(prob.fid_addPoint, ['points_shifted:       ' frmt_x ], model.points_shifted);
      fprintf(prob.fid_addPoint, ENDSTR);
      fprintf(prob.fid_addPoint, ['points_abs:           ' frmt_x ], model.points_abs);
      fprintf(prob.fid_addPoint, STARTSTR);



  end

case 78
  % ------------------------------------------------------------------
  % changeTrCenter()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'changeTrCenter[0]');
      fprintf(prob.fid_changeTrCenter, ['[ changeTrCenter() ]\n']);

      % fprintf(prob.dbg_file_fid, '\n%s', 'changeTrCenter[1]');
      fprintf(prob.fid_changeTrCenter, ['rel_piv_threshold: [' [m22_12 ' ]\n'] ], options.pivot_threshold);
      fprintf(prob.fid_changeTrCenter, ['(!is_complete):    [ %i ]\n'], condA);
      fprintf(prob.fid_changeTrCenter, ['exit_flag:         [ %i ]\n'], exitflag);

      fprintf(prob.fid_changeTrCenter, ['points_abs:           ' frmt_x ], model.points_abs);
      fprintf(prob.fid_changeTrCenter, ['points_shifted:       ' frmt_x ], model.points_shifted);

    case 2

      fprintf(prob.fid_changeTrCenter, ['new_fvalue:        [' [m22_12 ' ]\n'] ], new_fvalues);
      fprintf(prob.fid_changeTrCenter, ['exit_flag:         [ %i ]\n'], exitflag);
      fprintf(prob.fid_changeTrCenter, ['new_point:         ' frmt_x ], new_point);

    case 3

    case 4

      fprintf(prob.fid_changeTrCenter, ['new_fvalue:        [' [m22_12 ' ]\n'] ], new_fvalues);
      fprintf(prob.fid_changeTrCenter, ['exit_flag:         [ %i ]\n'], exitflag);
      fprintf(prob.fid_changeTrCenter, ['new_point:         ' frmt_x ], new_point);

    case 5

    case 6
      % fprintf(prob.fid_addPoint, ENDSTRNN);

  end









case 99
  % ------------------------------------------------------------------ 2
  % TrustRegionModel()
  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s\n', 'TrustRegionModel[0]');
      fprintf(prob.fid_TrustRegionModel, ['[ TrustRegionModel() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_TrustRegionModel, ENDSTRNN);

  end

case 100
  % ------------------------------------------------------------------
  % TrustRegionOptimization()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'TrustRegionOptimization[0]');
      fprintf(prob.fid_TrustRegionOptimization, ['[ TrustRegionOptimization() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_TrustRegionOptimization, ENDSTRNN);

  end

case 101
  % ------------------------------------------------------------------
  % iterate()

  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, 1),1)-1) [m22_12 ' ] \n']];
  % frmt_f = [ '[' repmat([m22_12 ', '], 1, size(initial_fvalues(:, 1),1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.fid_iterate, STARTSTR);
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[0]');
      fprintf(prob.fid_iterate, ['[ iterate() ]\n']);
      fprintf(prob.fid_iterate, ['Iteration#    [ %i ]\n'], 0);
      fprintf(prob.fid_iterate, ['!areInitPointsComputed [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!isInitialized         [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ENDSTR);

    case 2
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[1]');
      fprintf(prob.fid_iterate, ['areInitPointsComputed         [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!areImprovementPointsComputed [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!areReplacementPointsComputed [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!isInitialized                [ %i ]\n'], 1);

    case 3
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[2]');
      fprintf(prob.fid_iterate, ['hasOnlyOnePoint               [ %i ]\n'], size(model.points_abs, 2) < 2);

    case 4
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[3]');
      fprintf(prob.fid_iterate, ['[ ensureImprovement ]\n']);

    case 5
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[4]');
      fprintf(prob.fid_iterate, ['areInitPointsComputed         [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['isImprovementNeeded           [ %i ]\n'], ~isImprovementNeeded);
      fprintf(prob.fid_iterate, ['areImprovementPointsComputed  [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!isInitialized                [ %i ]\n'], 1);

    case 6
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[4]');
      fprintf(prob.fid_iterate, ['areInitPointsComputed         [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['isReplacementNeeded           [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['areReplacementPointsComputed  [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!isInitialized                [ %i ]\n'], 1);

    case 7
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[4]');

      frmt_x = [ '[' repmat([m22_12 ', '], 1, size(x_current,1)-1) [m22_12 ' ] \n']];
      frmt_f = [ '[' repmat([m22_12 ', '], 1, size(fval_current,1)-1) [m22_12 ' ] \n']];

      fprintf(prob.fid_iterate, ['Iteration#    [ %i ]\n'], iter);
      fprintf(prob.fid_iterate, ['x_current:    ' frmt_x ], x_current);
      fprintf(prob.fid_iterate, ['fval_current: ' frmt_f ], fval_current);
      fprintf(prob.fid_iterate, ['tr_center:    [ %i ]\n'], model.tr_center);

      fprintf(prob.fid_iterate, ['points_shifted  ' frmt_x ], model.points_shifted);
      fprintf(prob.fid_iterate, ENDSTR);
      fprintf(prob.fid_iterate, ['points_abs      ' frmt_x ], model.points_abs);

    case 8
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[5]');
      fprintf(prob.fid_iterate, ENDSTR);
      fprintf(prob.fid_iterate, ['norm(measure_crit) <= eps_c:    [ %i ]\n'], cW1);
      fprintf(prob.fid_iterate, ['model_criticality:              ' frmt_f ], model_criticality);

    case 9
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[6]');
      fprintf(prob.fid_iterate, ENDSTR);
      fprintf(prob.fid_iterate, ['norm(measure_crit) < tol_f:     [ %i ]\n'], cW2);

    case 10 % FAKE COUNTER 1

      frmt_x = [ '[' repmat([m22_12 ', '], 1, size(x_current,1)-1) [m22_12 ' ] \n']];
      frmt_f = [ '[' repmat([m22_12 ', '], 1, size(fval_current,1)-1) [m22_12 ' ] \n']];

      areImprovementPointsComputed = [0 1];

      for k=areImprovementPointsComputed
        fprintf(prob.fid_iterate, STARTSTR);
        fprintf(prob.fid_iterate, COUNTSTR, 1);

        fprintf(prob.fid_iterate, ['Iteration#    [ %i ]\n'], iter+1);
        fprintf(prob.fid_iterate, ['x_current:    ' frmt_x ], x_current);
        fprintf(prob.fid_iterate, ['fval_current: ' frmt_f ], fval_current);
        fprintf(prob.fid_iterate, ['tr_center:    [ %i ]\n'], model.tr_center);

        fprintf(prob.fid_iterate, ['points_shifted  ' frmt_x ], model.points_shifted);
        fprintf(prob.fid_iterate, ENDSTR);
        fprintf(prob.fid_iterate, ['points_abs      ' frmt_x ], model.points_abs);

        fprintf(prob.fid_iterate, ENDSTR);
        fprintf(prob.fid_iterate, ['!isImprovementNeeded           [ %i ]\n'], 0);
        fprintf(prob.fid_iterate, ['!areImprovementPointsComputed  [ %i ]\n'], ~k);
        fprintf(prob.fid_iterate, ['!isReplacementNeeded           [ %i ]\n'], 1);
        fprintf(prob.fid_iterate, ['!areReplacementPointsComputed  [ %i ]\n'], 1);
      end






    case 11
      fprintf(prob.fid_iterate, ENDSTR);
      fprintf(prob.fid_iterate, ['!isImprovementNeeded           [ %i ]\n'], ~isImprovementNeeded);
      fprintf(prob.fid_iterate, ['!areImprovementPointsComputed  [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!isReplacementNeeded           [ %i ]\n'], 1);
      fprintf(prob.fid_iterate, ['!areReplacementPointsComputed  [ %i ]\n'], 1);

    case 12
      fprintf(prob.dbg_file_fid, '\n\n%s', 'iterate[3]');
      fprintf(prob.fid_iterate, ENDSTR);
      fprintf(prob.fid_iterate, ['pred_red < tol_rad*1e-2:        [ %i ]\n'], cS);
      fprintf(prob.fid_iterate, ['pred_red < tol_rad*|f_curr|:    [ %i ]\n'], cT);
      fprintf(prob.fid_iterate, ['norm(trial_step) < tol_rad:     [ %i ]\n'], cU);
      fprintf(prob.fid_iterate, ['pred_red < tol_f*|f_curr|*1e-3: [ %i ]\n'], cV);

    case 13
      fprintf(prob.fid_iterate, ENDSTR);
      fprintf(prob.fid_iterate, ['x_current:    ' frmt_x ], x_current);
      fprintf(prob.fid_iterate, ['fval_current: ' frmt_f ], fval_current);
      fprintf(prob.fid_iterate, ['trial_point:  ' frmt_x ], trial_point);
      fprintf(prob.fid_iterate, ['fval_trial:   ' frmt_f ], fval_trial);

  end





case 102
  % ------------------------------------------------------------------
  % handleEvaluatedCase()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, k),1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(initial_fvalues(:, k),1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'handleEvaluatedCase[0]');
      fprintf(prob.fid_handleEvaluatedCase, ['[ handleEvaluatedCase() ]\n']);
      fprintf(prob.fid_handleEvaluatedCase, ['Iteration#    [ %i ]\n'], 0);
      fprintf(prob.fid_handleEvaluatedCase, ['point:        ' frmt_x ], initial_points(:, k));
      fprintf(prob.fid_handleEvaluatedCase, ['fvalue:       ' frmt_f ], initial_fvalues(:, k));
      fprintf(prob.fid_handleEvaluatedCase, ENDSTR);

    case 2
      fprintf(prob.dbg_file_fid, '\n%s', 'handleEvaluatedCase[1]');
      fprintf(prob.fid_handleEvaluatedCase, ['[ handleEvaluatedCase() ]\n']);
      fprintf(prob.fid_handleEvaluatedCase, ['Iteration#    [ %i ]\n'], iter);
      fprintf(prob.fid_handleEvaluatedCase, ['x_current:    ' frmt_x ], x_current);
      fprintf(prob.fid_handleEvaluatedCase, ['fval_current: ' frmt_f ], fval_current);
      fprintf(prob.fid_handleEvaluatedCase, ['trial_point:  ' frmt_x ], trial_point);
      fprintf(prob.fid_handleEvaluatedCase, ['fval_trial:   ' frmt_f ], fval_trial);
      fprintf(prob.fid_handleEvaluatedCase, ENDSTR);

    case 3

      % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, 1),1)-1) [m22_12 ' ] \n']];
      % frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(initial_fvalues(:, 1),1)-1) [m22_12 ' ] \n']];
      fprintf(prob.fid_handleEvaluatedCase, ['eta_1         ' frmt_f ], eta_1);
      fprintf(prob.fid_handleEvaluatedCase, ['ared_         ' frmt_f ], ared);
      fprintf(prob.fid_handleEvaluatedCase, ['rho_          ' frmt_f ], rho);
      fprintf(prob.fid_handleEvaluatedCase, ['x_current:    ' frmt_x ], x_current);
      fprintf(prob.fid_handleEvaluatedCase, ENDSTR);

    case 4
      fprintf(prob.fid_handleEvaluatedCase, ['[ Call changeTrCenter() ]\n']);
      fprintf(prob.fid_handleEvaluatedCase, ['(rho_ > eta_1) [ %i ]\n'], cX);
      fprintf(prob.fid_handleEvaluatedCase, ['mchange_flag_  [ %i ]\n'], mchange_flag);
      fprintf(prob.fid_handleEvaluatedCase, ['fval_trial_:   ' frmt_f ], fval_trial);
      fprintf(prob.fid_handleEvaluatedCase, ['trial_point_:  ' frmt_x ], trial_point);
      fprintf(prob.fid_handleEvaluatedCase, ENDSTR);

    case 5
      fprintf(prob.fid_handleEvaluatedCase, ['[ Call ensureImprovement() ]\n']);
      fprintf(prob.fid_handleEvaluatedCase, ['(!iteration_model_fl_ && mchange_flag_ == 4) [ %i ]\n'], cY);
      fprintf(prob.fid_handleEvaluatedCase, ['mchange_flag_        [ %i ]\n'], mchange_flag);
      fprintf(prob.fid_handleEvaluatedCase, ['!iteration_model_fl_ [ %i ]\n'], ~iteration_model_fl);
  end

case 103
  % ------------------------------------------------------------------
  % updateRadius()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'updateRadius[0]');
      fprintf(prob.fid_updateRadius, ['[ updateRadius() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_updateRadius, ENDSTRNN);

  end

case 104
  % ------------------------------------------------------------------
  % computeInitialPoints()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, 1),1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'computeInitialPoints[0]');
      fprintf(prob.fid_computeInitialPoints, ['[ computeInitialPoints() ]-cgmat\n']);
      fprintf(prob.fid_computeInitialPoints, ['init_point:        ' frmt_x ], initial_points(:, 1));

      fprintf(prob.fid_addInitializationCase, ['init_point:        ' frmt_x ], initial_points(:, 1));


    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'computeInitialPoints[1]');
      fprintf(prob.fid_computeInitialPoints, ['scnd_point:        ' frmt_x ], initial_points(:, 2));
      fprintf(prob.fid_computeInitialPoints, ENDSTRNN);

      fprintf(prob.fid_addInitializationCase, ['scnd_point:        ' frmt_x ], initial_points(:, 1));

    case 3

  end

case 105
  % ------------------------------------------------------------------
  % setLowerUpperBounds()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(bu,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'setLowerUpperBounds[0]');
      fprintf(prob.fid_setLowerUpperBounds, ['[ setLowerUpperBounds() ]\n']);
      fprintf(prob.fid_setLowerUpperBounds, ['bl:        ' frmt_x ], bl);
      fprintf(prob.fid_setLowerUpperBounds, ['bl:        ' frmt_x ], bu);

      fprintf(prob.fid_setLowerUpperBounds, ENDSTRNN);
  end

case 106
  % ------------------------------------------------------------------
  % IsFinished()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'IsFinished[0]');
      fprintf(prob.fid_IsFinished, ['[ IsFinished() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_IsFinished, ENDSTRNN);

  end

case 107
  % ------------------------------------------------------------------ 3
  % areInitPointsComputed()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, ' -- %s', 'areInitPointsComputed[0]');
      fprintf(prob.fid_areInitPointsComputed, ['[ areInitPointsComputed() ]-cgmat\n']);
      fprintf(prob.fid_areInitPointsComputed, ['init_points_computed_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'areInitPointsComputed[1]');
      fprintf(prob.fid_areInitPointsComputed, ['[ areInitPointsComputed() ]\n']);
      fprintf(prob.fid_areInitPointsComputed, ['init_points_computed_: [ %i ]\n'], 1);
      % fprintf(prob.fid_areInitPointsComputed, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'areInitPointsComputed[1]');
      fprintf(prob.fid_areInitPointsComputed, ['init_points_computed_: [ %i ]\n'], 0);
      % fprintf(prob.fid_areInitPointsComputed, ENDSTRNN);

  end

case 108
  % ------------------------------------------------------------------ 4
  % areImprPointsComputed()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, ' -- %s', 'areImprPointsComputed[0]');
      fprintf(prob.fid_areImprPointsComputed, ['[ areImprPointsComputed() ]-cgmat\n']);
      fprintf(prob.fid_areImprPointsComputed, ['impr_points_computed_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'areImprPointsComputed[1]');
      fprintf(prob.fid_areImprPointsComputed, ['impr_points_computed_: [ %i ]\n'], 1);
      fprintf(prob.fid_areImprPointsComputed, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'areImprPointsComputed[2]');
      fprintf(prob.fid_areImprPointsComputed, ['impr_points_computed_: [ %i ]\n'], 0);
      fprintf(prob.fid_areImprPointsComputed, ENDSTRNN);

  end

case 109
  % ------------------------------------------------------------------ 5
  % areReplacementPointsComputed()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, ' -- %s', 'areReplacementPointsComputed[0]');
      fprintf(prob.fid_areReplacementPointsComputed, ['[ areReplacementPointsComputed() ]-cgmat\n']);
      fprintf(prob.fid_areReplacementPointsComputed, ['repl_points_computed_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'areReplacementPointsComputed[1]');
      fprintf(prob.fid_areReplacementPointsComputed, ['repl_points_computed_: [ %i ]\n'], 1);
      fprintf(prob.fid_areReplacementPointsComputed, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'areReplacementPointsComputed[2]');
      fprintf(prob.fid_areReplacementPointsComputed, ['repl_points_computed_: [ %i ];\n'], 0);
      fprintf(prob.fid_areReplacementPointsComputed, ENDSTRNN);

  end

case 110
  % ------------------------------------------------------------------ 6
  % isInitialized()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n -- %s', 'isInitialized[0]');
      fprintf(prob.fid_isInitialized, ['[ isInitialized() ]-cgmat\n']);
      fprintf(prob.fid_isInitialized, ['is_initialized_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'isInitialized[1]');
      fprintf(prob.fid_isInitialized, ['is_initialized_: [ %i ]\n'], 1);
      fprintf(prob.fid_isInitialized, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'isInitialized[2]');
      fprintf(prob.fid_isInitialized, ['is_initialized_: [ %i ]\n'], 0);
      fprintf(prob.fid_isInitialized, ENDSTRNN);

  end

case 111
  % ------------------------------------------------------------------ 7
  % isImprovementNeeded()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, ' -- %s', 'isImprovementNeeded[0]');
      fprintf(prob.fid_isImprovementNeeded, ['[ isImprovementNeeded() ]-cgmat\n']);
      fprintf(prob.fid_isImprovementNeeded, ['needs_improvement_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'isImprovementNeeded[1]');
      fprintf(prob.fid_isImprovementNeeded, ['needs_improvement_: [ %i ]\n'], 1);
      fprintf(prob.fid_isImprovementNeeded, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'isImprovementNeeded[2]');
      fprintf(prob.fid_isImprovementNeeded, ['needs_improvement_: [ %i ]\n'], 0);
      fprintf(prob.fid_isImprovementNeeded, ENDSTRNN);

  end

case 112
  % ------------------------------------------------------------------ 8
  % isReplacementNeeded()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, ' -- %s', 'isReplacementNeeded[0]');
      fprintf(prob.fid_isReplacementNeeded, ['[ isReplacementNeeded() ]-cgmat\n']);
      fprintf(prob.fid_isReplacementNeeded, ['needs_replacement_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'isReplacementNeeded[1]');
      fprintf(prob.fid_isReplacementNeeded, ['needs_replacement_: [ %i ]\n'], 1);
      fprintf(prob.fid_isReplacementNeeded, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'isReplacementNeeded[2]');
      fprintf(prob.fid_isReplacementNeeded, ['needs_replacement_: [ %i ]\n'], 0);
      fprintf(prob.fid_isReplacementNeeded, ENDSTRNN);

  end

case 113
  % ------------------------------------------------------------------ 9
  % hasModelChanged()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'hasModelChanged[0]');
      fprintf(prob.fid_hasModelChanged, ['[ hasModelChanged() ]-cgmat\n']);
      fprintf(prob.fid_hasModelChanged, ['model_changed_: [ %i ]\n'], 0);

    case 2
      % fprintf(prob.dbg_file_fid, '\n%s', 'hasModelChanged[1]');
      fprintf(prob.fid_hasModelChanged, ['model_changed_: [ %i ]\n'], 1);
      fprintf(prob.fid_hasModelChanged, ENDSTRNN);

    case 3
      % fprintf(prob.dbg_file_fid, '\n%s', 'hasModelChanged[2]');
      fprintf(prob.fid_hasModelChanged, ['model_changed_: [ %i ]\n'], 0);
      fprintf(prob.fid_hasModelChanged, ENDSTRNN);

  end


case 114
  % ------------------------------------------------------------------
  % getInitializationCases()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'getInitializationCases[0]');
      fprintf(prob.fid_getInitializationCases, ['[ getInitializationCases() ]-cgmat\n']);
      fprintf(prob.fid_getInitializationCases, ['#cases: [ %i ]\n'], n_initial_points);
      fprintf(prob.fid_getInitializationCases, ENDSTRNN);

  end

case 115
  % ------------------------------------------------------------------
  % projectToBounds()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'projectToBounds[0]');
      fprintf(prob.fid_projectToBounds, ['[ projectToBounds() ]-cgmat\n']);

    case 2

    case 3

      fprintf(prob.fid_projectToBounds, ENDSTRNN);

  end

case 116
  % ------------------------------------------------------------------
  % setUpTempAllPoints()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'setUpTempAllPoints[0]');
      fprintf(prob.fid_setUpTempAllPoints, ['[ setUpTempAllPoints() ]\n']);

      fprintf(prob.fid_setUpTempAllPoints, ['points_abs:        ' frmt_x ], points_abs);
      fprintf(prob.fid_setUpTempAllPoints, ['fvalues:           ' frmt_f ], fvalues);

    case 2

    case 3

      fprintf(prob.fid_setUpTempAllPoints, ENDSTRNN);

  end



case 117
  % ------------------------------------------------------------------
  % nfpBasis()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'nfpBasis[0]');

      fprintf(prob.fid_nfpBasis, [ '[ --> ' pad('rebuildModel()', 38) ']' ]);
      fprintf(prob.fid_nfpBasis, ['[ nfpBasis() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_nfpBasis, ENDSTRNN);

  end


case 118
  % ------------------------------------------------------------------
  % getImprovementCases()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1
      fprintf(prob.dbg_file_fid, '\n%s', 'getImprovementCases[0]');
      fprintf(prob.fid_getImprovementCases, ['[ getImprovementCases() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_getImprovementCases, ENDSTRNN);

  end


case 119
  % ------------------------------------------------------------------
  % getReplacementCases()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'getReplacementCases[0]');
      fprintf(prob.fid_getReplacementCases, ['[ getReplacementCases() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_getReplacementCases, ENDSTRNN);

  end

case 120
  % ------------------------------------------------------------------
  % coefficientsToMatrices()
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(coefficients,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(coefficients,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'coefficientsToMatrices');
      fprintf(prob.fid_coefficientsToMatrices, ['[ coefficientsToMatrices() ]\n']);

      fprintf(prob.fid_coefficientsToMatrices, ...
              ['p.size():       [' [m22_12 ' ]\n'] ], size(coefficients,1));
      fprintf(prob.fid_coefficientsToMatrices, ...
              ['p[0].coeffs:    ' frmt_x ], coefficients');

    case 2

      frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
      frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

      fprintf(prob.fid_coefficientsToMatrices, ['Debug p-matrices c, g, H:\n']);
      fprintf(prob.fid_coefficientsToMatrices, ['c:      [' [m22_12 ' ]\n'] ], c);
      fprintf(prob.fid_coefficientsToMatrices, ['g:      ' frmt_g ], g);
      fprintf(prob.fid_coefficientsToMatrices, ['H:      ' frmt_H ], H);
      fprintf(prob.fid_coefficientsToMatrices, ENDSTR);

    case 3

  end

case 121
  % ------------------------------------------------------------------
  % orthogonalizeToOtherPolynomials()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'orthogonalizeToOtherPolynomials');
      fprintf(prob.fid_orthogonalizeToOtherPolynomials, ['[ orthogonalizeToOtherPolynomials() ]\n']);
      fprintf(prob.fid_orthogonalizeToOtherPolynomials, ['poly_i:            [ %i ]\n'], poly_i);
      fprintf(prob.fid_orthogonalizeToOtherPolynomials, ['last_pt_included:  [ %i ]\n'], last_pt);

      fprintf(prob.fid_orthogonalizeToOtherPolynomials, ENDSTR);

    case 2

    case 3

  end

case 122
  % ------------------------------------------------------------------
  % choosePivotPolynomial()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(incumbent_point,1)-1) [m22_12 ' ] \n']];
  frmt_s    = [ '[' repmat([m22_12 ', '], 1, size(points,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'choosePivotPolynomial');
      fprintf(prob.fid_choosePivotPolynomial, ['[ choosePivotPolynomial() ]\n']);
      fprintf(prob.fid_choosePivotPolynomial, ['last_point:        [ %i ]\n'], last_point);
      fprintf(prob.fid_choosePivotPolynomial, ['success:           [ %i ]\n'], success);
      fprintf(prob.fid_choosePivotPolynomial, ['pivot_value:       [  ' m22_12 ' ]\n'], pivot_value);

      fprintf(prob.fid_choosePivotPolynomial, ['incumbent_point:   ' frmt_x ], incumbent_point);
      fprintf(prob.fid_choosePivotPolynomial, ['points_shifted:    ' frmt_s ], points);
      fprintf(prob.fid_choosePivotPolynomial, ENDSTR);

    case 2
      fprintf(prob.fid_choosePivotPolynomial, ['k:                 [ %i ]\n'], k);

    case 3
      fprintf(prob.fid_choosePivotPolynomial, ['pivot_value:       [  ' m22_12 ' ]\n'], val);



  end

case 123
  % ------------------------------------------------------------------
  % findBestPoint()
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_s    = [ '[' repmat([m22_12 ', '], 1, size(points,1)-1) [m22_12 ' ] \n']];

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'findBestPoint');
      fprintf(prob.fid_findBestPoint, ['[ findBestPoint() ]\n']);

      fprintf(prob.fid_findBestPoint, ['fvalues:           ' frmt_f ], fvalues');
      fprintf(prob.fid_findBestPoint, ['points_abs:        ' frmt_s ], points);
      fprintf(prob.fid_findBestPoint, ['min_f:             ' frmt_f ], min_f);
      fprintf(prob.fid_findBestPoint, ['best_i:            [ %i ]\n'], best_i);

      fprintf(prob.fid_findBestPoint, ENDSTR);

    case 2

    case 3

  end

case 124
  % ------------------------------------------------------------------
  % orthogonalizeBlock()

  switch subp

    case 1

      fprintf(prob.dbg_file_fid, '\n%s', 'orthogonalizeBlock');
      fprintf(fid_orthogonalizeBlock, ['[ orthogonalizeBlock() ]\n']);

  end


end
