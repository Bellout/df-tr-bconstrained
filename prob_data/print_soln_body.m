
ENDSTR = [ repmat('-', 1, 60) '\n\n\n' ];
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

  fprintf(prob.fid_minimizeTr, ENDSTR);

case 10  



case 11

  % ------------------------------------------------------------------ 
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(model.points_abs,1)-1) [m22_12 ' ] \n']];

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

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_checkInterpolation, ['c:      [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_checkInterpolation, ['g:      ' frmt_g ], g);
  fprintf(prob.fid_checkInterpolation, ['H:      ' frmt_H ], H);

case 13

  % ------------------------------------------------------------------ 
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_A    = [ '[' repmat([m22_12 ', '], 1, size(A,2)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['cval        [' [m22_12 ' ]\n'] ], this_value);
  fprintf(prob.fid_checkInterpolation, ['cdiff       [' [m22_12 ' ]\n'] ], difference);
  fprintf(prob.fid_checkInterpolation, ['max_diff    [' [m22_12 ' ]\n'] ], max_diff);

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['A: fvalues(k, :)      ' frmt_A ], A');
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

    % fprintf(prob.fid_solveTrSubproblem, '\n');
    fprintf(prob.fid_solveTrSubproblem, [ '[ solveTrSubproblem() ]\n'] );
    fprintf(prob.fid_solveTrSubproblem, [ 'idx_tr_center          [ %i ]\n'], model.tr_center);
    fprintf(prob.fid_solveTrSubproblem, [ 'tr_center_pt           ' frmt_x ], x_tr_center');
    fprintf(prob.fid_solveTrSubproblem, [ 'orig.p.coeffs          ' frmt_p ], obj_pol_o.coefficients');
    fprintf(prob.fid_solveTrSubproblem, [ 'shifted.p.coeffs       ' frmt_p ], obj_pol_s.coefficients');

    fprintf(prob.fid_solveTrSubproblem, [ 'current_f              ' frmt_f ], current_fval);
    fprintf(prob.fid_solveTrSubproblem, [ 'trial_f                ' frmt_f ], trial_fval);
    fprintf(prob.fid_solveTrSubproblem, [ '(current_f <= trial_f) [ %i ]\n\n'], (current_fval <= trial_fval));

  case 2

    fprintf(prob.fid_solveTrSubproblem, [ 'points_abs_#%i          ' frmt_x ], k, model.points_abs(:, k)');
    fprintf(prob.fid_solveTrSubproblem, [ 'f_poly(points_abs_#%i)  ' frmt_f ], k, val);
    fprintf(prob.fid_solveTrSubproblem, [ 'f_real(points_abs_#%i)  ' frmt_f ], k, model.fvalues(1, k));

    fprintf(prob.fid_solveTrSubproblem, [ 'err_interp             ' frmt_f ], error_interp);
    fprintf(prob.fid_solveTrSubproblem, [ 'tol_interp             ' frmt_f ], tol_interp);
    fprintf(prob.fid_solveTrSubproblem, [ '(err_ip > tol_ip)      [ %i ]\n' ], (error_interp > tol_interp));

    fprintf(prob.fid_solveTrSubproblem, ENDSTR);

  end


case 15

  % ------------------------------------------------------------------
  % reCenterPoints() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_reCenterPoints, ['[ reCenterPoints() ]\n']);
  fprintf(prob.fid_reCenterPoints, ['rebuildModel() -> reCenterPoints()\n']);

  fprintf(prob.fid_reCenterPoints, ['\nValues b/f reCentering\n']);
  fprintf(prob.fid_reCenterPoints, ['all_points      ' frmt_x ], points_abs);
  fprintf(prob.fid_reCenterPoints, ['all_fvalues     ' frmt_f ], fvalues');

case 16

  % ------------------------------------------------------------------
  % reCenterPoints() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_reCenterPoints, ['\nValues a/f reCentering\n']);
  fprintf(prob.fid_reCenterPoints, ['all_points      ' frmt_x ], points_abs);
  fprintf(prob.fid_reCenterPoints, ['all_fvalues     ' frmt_f ], fvalues');

  fprintf(prob.fid_reCenterPoints, '\nPoints shifted / distances\n');
  fprintf(prob.fid_reCenterPoints, ['points_shifted  ' frmt_x ], points_shifted);
  fprintf(prob.fid_reCenterPoints, ['distances       ' frmt_f ], distances');

  fprintf(prob.fid_reCenterPoints, ENDSTR);

case 17

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, ['[ rowPivotGaussianElimination() ]\n']);
  fprintf(prob.fid_rowPivotGaussianElimination, ['rebuildModel() -> rowPivotGaussianElimination()\n']);

  fprintf(prob.fid_rowPivotGaussianElimination, ['\nValues b/f rowPivotGaussianElimination\n']);
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_points      ' frmt_x ], points_abs);
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_fvalues     ' frmt_f ], fvalues');
  fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted);

case 18

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_threshold ' frmt_f ], pivot_threshold');
  fprintf(prob.fid_rowPivotGaussianElimination, ['farthest_pt     ' frmt_f ], distances(end));
  fprintf(prob.fid_rowPivotGaussianElimination, ['dist_farthest_pt' frmt_f ], distances(end)/radius);

  fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], piv_p');

case 19

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, ['\n%s\n'], str_blck);
  fprintf(prob.fid_rowPivotGaussianElimination, ['max_layer       ' frmt_f ], maxlayer);
  fprintf(prob.fid_rowPivotGaussianElimination, ['dist_farthest_pt' frmt_f ], distances(end)/radius);

  fprintf(prob.fid_rowPivotGaussianElimination, ['iter            ' frmt_f ], iter);
  fprintf(prob.fid_rowPivotGaussianElimination, ['block_beginning ' frmt_f ], block_beginning);
  fprintf(prob.fid_rowPivotGaussianElimination, ['block_end       ' frmt_f ], block_end);

case 20

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_l    = [ '[' repmat([m22_12 ', '], 1, size(all_layers,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(pivot_values,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_layers      ' frmt_l ], all_layers);
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_values    ' frmt_p ], pivot_values);

case 21

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()
  
  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_shifted(:, n),1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['n               ' frmt_f ], n);
  fprintf(prob.fid_rowPivotGaussianElimination, ['distances(n)    ' frmt_f ], distances(n));
  fprintf(prob.fid_rowPivotGaussianElimination, ['val             ' frmt_f ], val);

  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], piv_p');
  fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted(:, n));

case 22

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()
  
  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];

  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_shifted(:, n),1)-1) [m22_12 ' ] \n']];

  if (pt_next ~= pt_max)
    fprintf(prob.fid_rowPivotGaussianElimination, '\n');
    fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted(:, n));
    fprintf(prob.fid_rowPivotGaussianElimination, ['all_points      ' frmt_x ], points_abs);
    fprintf(prob.fid_rowPivotGaussianElimination, ['all_fvalues     ' frmt_f ], fvalues');
    fprintf(prob.fid_rowPivotGaussianElimination, ['distances       ' frmt_f ], distances');
  end

  fprintf(prob.fid_rowPivotGaussianElimination, '\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['max_absval       ' frmt_f ], max_absval);
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_values     ' frmt_p ], pivot_values);

case 23
  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()
  
  m22_12 = prob.m22_12;
  piv_p = pivot_polynomials(poly_i).coefficients;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(piv_p,2)-1) [m22_12 ' ] \n']];  

  fprintf(prob.fid_rowPivotGaussianElimination, '\northogonalizeToOtherP\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], piv_p');

case 24
  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()
  
  m22_12 = prob.m22_12;

  [pr pc] = size(pivot_polynomials); % [1 6]
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(pivot_polynomials(1).coefficients,2)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, ['\n%s'], str_pts);

  for (ii=1:6)
    p = pivot_polynomials(ii).coefficients;
    fprintf(prob.fid_rowPivotGaussianElimination, '\n');
    fprintf(prob.fid_rowPivotGaussianElimination, ['pivot_p.coeffs  ' frmt_p ], p');
  end

case 25
  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()
  
  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, '\nValues a/f rowPivotGaussianElimination\n');
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_points      ' frmt_x ], model.points_abs);
  fprintf(prob.fid_rowPivotGaussianElimination, ['all_fvalues     ' frmt_f ], model.fvalues');
  fprintf(prob.fid_rowPivotGaussianElimination, ['points_shifted  ' frmt_x ], points_shifted);

  fprintf(prob.fid_rebuildModel, ['\n[ rebuildModel() ]\n']);
  fprintf(prob.fid_rebuildModel, ['last_pt_included [ ' [m22_12 ' ]\n'] ], last_pt_included);
  fprintf(prob.fid_rebuildModel, ['n_points         [ ' [m22_12 ' ]\n'] ], p_ini);

  fprintf(prob.fid_rowPivotGaussianElimination, ENDSTR);

case 26

  % ------------------------------------------------------------------
  % moveToBestPoint()

  m22_12 = prob.m22_12;
  fprintf(prob.fid_moveToBestPoint, ['[ moveToBestPoint() ]\n']);
  fprintf(prob.fid_moveToBestPoint, ['idx_tr_center [ ' [m22_12 ' ]\n'] ], model.tr_center);
  fprintf(prob.fid_moveToBestPoint, ['idx_best_i    [ ' [m22_12 ' ]\n'] ], best_i);

case 27

  % ------------------------------------------------------------------
  % moveToBestPoint()

  m22_12 = prob.m22_12;
  fprintf(prob.fid_moveToBestPoint, ['idx_tr_center [ ' [m22_12 ' ]\n'] ], model.tr_center);  

  fprintf(prob.fid_moveToBestPoint, ENDSTR);

case 28

  % ------------------------------------------------------------------
  % measureCriticality()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(grad,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_measureCriticality, ['[ measureCriticality() ]\n']);
  % fprintf(prob.fid_measureCriticality, ['Debug p-matrices g:\n']);
  fprintf(prob.fid_measureCriticality, ['g  ' frmt_g ], grad);

  fprintf(prob.fid_measureCriticality, '\n');
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

  % fprintf(prob.fid_shiftPolynomial, '\n');
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

  fprintf(prob.fid_shiftPolynomial, ENDSTR);

case 30

  % ------------------------------------------------------------------
  % getModelMatrices()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_getModelMatrices, ['[ %s() ] -> [ getModelMatrices() ]\n'], prob.prev);
  fprintf(prob.fid_getModelMatrices, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_getModelMatrices, ['c  [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_getModelMatrices, ['g  ' frmt_g ], g);
  fprintf(prob.fid_getModelMatrices, ['H  ' frmt_H ], H);

  fprintf(prob.fid_getModelMatrices, ENDSTR);

case 31

  % ------------------------------------------------------------------
  % criticalityStep()

  m22_12 = prob.m22_12;

  switch subp

    case 1
        fprintf(prob.fid_criticalityStep, ['[ criticalityStep() ]\n']);
  
    case 2
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
  fprintf(prob.fid_criticalityStep, '\n');
  fprintf(prob.fid_criticalityStep, ['H: norm(masr_crit)  [' [m22_12 ' ]\n'] ], H);
  fprintf(prob.fid_criticalityStep, ['I: beta*A           [' [m22_12 ' ]\n'] ], I);
  fprintf(prob.fid_criticalityStep, ['J: max(radius, B)   [' [m22_12 ' ]\n'] ], J);
  fprintf(prob.fid_criticalityStep, ['K: min(C, init_rad) [' [m22_12 ' ]\n'] ], K);

  fprintf(prob.fid_criticalityStep, ENDSTR);

case 34

  % ------------------------------------------------------------------
  % improveModelNfp()

  m22_12 = prob.m22_12;
  frmt_ps = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_sc = [ '[' repmat([m22_12 ', '], 1, size(shift_center,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_improveModelNfp, ['[ improveModelNfp() ]\n']);  
  fprintf(prob.fid_improveModelNfp, ['shift_center     ' frmt_sc ], shift_center);
  fprintf(prob.fid_improveModelNfp, ['bl_shifted       ' frmt_sc ], bl_shifted);
  fprintf(prob.fid_improveModelNfp, ['bu_shifted       ' frmt_sc ], bu_shifted);
  fprintf(prob.fid_improveModelNfp, ['#points_shifted  [ %i ]\n' ], size(points_shifted,2));
  fprintf(prob.fid_improveModelNfp, ['points_shifted   ' frmt_ps ], points_shifted);
  fprintf(prob.fid_improveModelNfp, ['tr_center_pt     ' frmt_ps ], tr_center_pt);

  % fprintf(prob.fid_improveModelNfp, ['tol_shift       [' [m22_12 ' ]\n'] ], tol_shift);

case 35

  % ------------------------------------------------------------------
  % improveModelNfp()

  fprintf(prob.fid_improveModelNfp, '\n');
  fprintf(prob.fid_improveModelNfp, ['A: (tr_center_pt.lpNorm<Inf>() > radius_fac*radius) [ %i ]\n'], A);
  fprintf(prob.fid_improveModelNfp, ['B: (p_ini > dim+1)                                  [ %i ]\n'], B);

  fprintf(prob.fid_improveModelNfp, ['\n%s\n'], str_mstat0);
  fprintf(prob.fid_improveModelNfp, ['%s\n'], str_mstat1);

case 36
  % ------------------------------------------------------------------
  % improveModelNfp()

  fprintf(prob.fid_improveModelNfp, ['%s %i/3\n'], str_att0, attempts);

case 37
  % ------------------------------------------------------------------
  % improveModelNfp()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(new_pivot_value,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_improveModelNfp, ['%s %i)\n'], str_att1, poly_i);

  fprintf(prob.fid_improveModelNfp, '\n');
  fprintf(prob.fid_improveModelNfp, ['%i new pts/pivot-pts found (T/F:%i)\n'], ...
          length(new_points_shifted), point_found);
  fprintf(prob.fid_improveModelNfp, ['For-loop[3]: (found_i < nfp_new_points_shifted_.cols()) (%i/%i)\n'], ...
          found_i, length(new_points_shifted));

  fprintf(prob.fid_improveModelNfp, ['nfp_new_point_shifted ' frmt_x ], new_point_shifted);
  fprintf(prob.fid_improveModelNfp, ['nfp_new_point_abs     ' frmt_x ], new_point_abs);
  fprintf(prob.fid_improveModelNfp, ['nfp_new_pivots        ' frmt_p ], new_pivot_value);

  fprintf(prob.fid_minimizeTr, ENDSTR);

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

  fprintf(prob.fid_improveModelNfp, ['%s %i)\n'], str_att1, poly_i);

  fprintf(prob.fid_improveModelNfp, '\nUsing previously computed pts/pivot-vals\n');
  fprintf(prob.fid_improveModelNfp, ['For-loop[3]: (found_i < nfp_new_points_shifted_.cols()) (%i/%i)\n'], ...
          found_i, length(new_points_shifted));

  fprintf(prob.fid_improveModelNfp, ['nfp_new_point_abs#%i  ' frmt_x ], ...
          size(new_point_abs,2)-1, new_point_abs);
    fprintf(prob.fid_improveModelNfp, ['nfp_new_fvalues#%i    ' frmt_f ], ...
          size(new_fvalues,1)-1, new_fvalues);

  fprintf(prob.fid_improveModelNfp, '\nc->GetState(): PEND\n');
  fprintf(prob.fid_improveModelNfp, 'Setting -> setAreImprPointsComputed(false)\n');

case 39
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, ['\nBreak-for-loop[3]: (found_i < new_points_shifted.cols()) '...
          'since f_succeeded.all()=%i\n'], f_succeeded);

case 40  
  % ------------------------------------------------------------------
  % improveModelNfp()  
  fprintf(prob.fid_improveModelNfp, 'End-for-loop[3]: (found_i < new_points_shifted.cols())\n');

case 41
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, '\nBreak-if: (point_found)\n');
  fprintf(prob.fid_improveModelNfp, 'Stop trying pivot polynomials for poly_i=(%i)\n', poly_i);

case 42
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, '\nEnd-if: (point_found)\n');

case 43
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'Break-for-loop[1]: (attempts<=3)\n');

case 44
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, '\nReduce radius if it did not break\n');

case 45
  % ------------------------------------------------------------------
  % improveModelNfp()
  % fprintf(prob.fid_improveModelNfp, '\n!areImprovementPointsComputed()[2] -> false\n');
  fprintf(prob.fid_improveModelNfp, 'End-for-loop[2]: (poly_i <= block_end)\n', poly_i);

case 46
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'End-for-loop[1]: (attempts<=3)\n');

case 47
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'Setting -> setAreImprPointsComputed(false)\n');
  fprintf(prob.fid_improveModelNfp, 'Update this polynomial in set\n');
  fprintf(prob.fid_improveModelNfp, 'Swap polynomials\n');

case 48
  % ------------------------------------------------------------------
  % improveModelNfp()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(new_fvalues,1)-1) [m22_12 ' ] \n']];

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
    fprintf(prob.fid_improveModelNfp, ['nfp_new_point_shifted_#%i       ' frmt_x ], ii, nps(:,ii)');
  end

  % points_abs
  fprintf(prob.fid_improveModelNfp, 'points_abs_.cols():            %i\n', size(pa,2));
  fprintf(prob.fid_improveModelNfp, 'points_abs_.rows():            %i\n', size(pa,1));
  for ii=1:size(pa, 2)
    fprintf(prob.fid_improveModelNfp, ['points_abs_#%i:                 ' frmt_x ], ii, pa(:,ii)');
  end

  % fvalues
  fprintf(prob.fid_improveModelNfp, 'fvalues_.cols():               %i\n', size(fv,2));
  fprintf(prob.fid_improveModelNfp, 'fvalues_.rows():               %i\n', size(fv,1));
  for ii=1:size(fv, 2)
    fprintf(prob.fid_improveModelNfp, ['fvalues_#%i:                    ' frmt_f ], ii, fv(:,ii)');
  end
  
  % fprintf(prob.fid_improveModelNfp, '------------------------------------------\n\n');

  % fprintf(prob.fid_improveModelNfp, ['nfp_new_point_shifted ' frmt_x ], new_point_shifted);

case 49
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'Add point\n');

case 50
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'Normalize polynomial value\n');

case 51
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'Re-orthogonalize\n');

case 52
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, [ 'Orthogonalize polynomials on present '...
          'block -- (deffering subsequent ones)\n' ]);  

case 53
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'Update model and recompute polynomials\n');
  fprintf(prob.fid_improveModelNfp, 'Resize points_abs_\n');
  fprintf(prob.fid_improveModelNfp, 'Resize fvalues_\n');

case 54
  % ------------------------------------------------------------------
  % improveModelNfp()
  fprintf(prob.fid_improveModelNfp, 'exit_flag=%i\n', exitflag);
  fprintf(prob.fid_improveModelNfp, '=====================================\n\n\n');

  fprintf(prob.fid_improveModelNfp, ENDSTR);

case 55
  % ------------------------------------------------------------------
  % improveModelNfp()

  % fprintf(prob.fid_minimizeTr, ENDSTR);





case 56
  % ------------------------------------------------------------------
  % ensure_improvement()
  m22_12 = prob.m22_12;
  ps = model.points_shifted;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(ps,1)-1) [m22_12 ' ] \n']];

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
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['Replace some point with new one improving geometry\n']);
  fprintf(prob.fid_ensureImprovement, ['Call chooseAndReplacePoint()\n']);

case 58
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['Rebuild model -> rebuildModel()\n']);

case 59
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['(!model_changed):         [ %i ]\n'], ~model_changed);
  fprintf(prob.fid_ensureImprovement, ['(!model_complete):        [ %i ]\n'], (~model_complete));
  fprintf(prob.fid_ensureImprovement, ['Improve model -> improveModelNfp()\n']);

case 60
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['Replace point -> chooseAndReplacePoint()\n']);

case 61
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['model_changed is true (success = %i)\n'], success);
  fprintf(prob.fid_ensureImprovement, ['(!!! exitflag not set for this outcome !!!))\n']);
  fprintf(prob.fid_ensureImprovement, ['[After call of improve_model_nfp() is model is ' ...
  'not complete, or choose_and_replace_point()\n']);

case 62
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['exit_flag=%i [after model is old]\n'], exitflag);

case 63
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, ['exit_flag=%i [after model has changed/is new]\n'], exitflag);

case 64
  % ------------------------------------------------------------------
  % ensure_improvement()  
 fprintf(prob.fid_ensureImprovement, [ 'exit_flag=%i [is no success after improve_model_nfp()' ...
         ' or choose_and_replace_point()]\n' ], exitflag);

case 65
  % ------------------------------------------------------------------
  % ensure_improvement()
  fprintf(prob.fid_ensureImprovement, 'exit_flag=%i [after choose_and_replace_point]\n', exitflag);

  fprintf(prob.fid_ensureImprovement, ENDSTR);








case 66
  % ------------------------------------------------------------------
  % computePolynomialModels()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(model.tr_center,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(model.fvalues,1)-1) [m22_12 ' ] \n']];

switch subp

  case 1
    fprintf(prob.fid_computePolynomialModels, ['[ computePolynomialModels() ]\n']);
    fprintf(prob.fid_computePolynomialModels, ['linear terms:                 [ %i ]\n'], linear_terms);
    fprintf(prob.fid_computePolynomialModels, ['full quad terms:              [ %i ]\n'], full_q_terms);
    fprintf(prob.fid_computePolynomialModels, ['points_num:                   [ %i ]\n'], points_num);    

  case 2
    fprintf(prob.fid_computePolynomialModels, ['\nCompute quadratic model\n']);
    fprintf(prob.fid_computePolynomialModels, ['(linear_terms < points_num):  [ %i ]\n'], ca);
    fprintf(prob.fid_computePolynomialModels, ['(points_num < full_q_terms):  [ %i ]\n'], cb);    

  case 3
    fprintf(prob.fid_computePolynomialModels, ['\nCompute model w/ incomplete (complete) basis\n']);
    fprintf(prob.fid_computePolynomialModels, ['(points_num <= linear_terms): [ %i ]\n'], cc);
    fprintf(prob.fid_computePolynomialModels, ['(points_num == full_q_terms): [ %i ]\n'], cdd);
    fprintf(prob.fid_computePolynomialModels, ['cmg:badly_conditioned_system: [ %i ]\n'], ce);
    fprintf(prob.fid_computePolynomialModels, ['last warning:                 [ %s  ]\n'], wid);

  case 4
    fprintf(prob.fid_computePolynomialModels, ['l_alpha:                      ' frmt_x ], l_alpha');
    fprintf(prob.fid_computePolynomialModels, ['p[0].coeffs:                  ' frmt_x ], ...
            polynomials{1}.coefficients');

    fprintf(prob.fid_computePolynomialModels, ENDSTR);

end

case 67
  % ------------------------------------------------------------------
  % evaluatePolynomial()

  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(polynomial.coefficients,1)-1) [m22_12 ' ] \n']]; 
  
  switch subp
    

    case 1
    % fprintf(prob.fid_evaluatePolynomial, ['\n[ evaluatePolynomial() ]\n']);
    fprintf(prob.fid_evaluatePolynomial, ['p: ' frmt_x ], polynomial.coefficients);

    % fprintf(prob.fid_evaluatePolynomial, ['c: ' m22_12 ' gx: ' m22_12 ' .5xHx: ' m22_12 '\n'], ...
    %         terms(1), terms(2), terms(3));
    fprintf(prob.fid_evaluatePolynomial, ENDSTR);
  
  end

case 68
  % ------------------------------------------------------------------
  % addPolynomial()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(p1.coefficients,1)-1) [m22_12 ' ] \n']]; 

  switch subp

    case 1
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
      fprintf(prob.fid_multiplyPolynomial, ['[ multiplyPolynomial() ]\n']);
      fprintf(prob.fid_multiplyPolynomial, ['ps: ' frmt_x ], polynomial.coefficients);
    
      fprintf(prob.fid_multiplyPolynomial, ENDSTR);

  end    

case 70
  % ------------------------------------------------------------------
  % nfpFiniteDifferences()
  m22_12 = prob.m22_12;
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(l_alpha,1)-1) [m22_12 ' ] \n']];  

  switch subp
    
    case 1
      fprintf(prob.fid_nfpFiniteDifferences, ['[ nfpFiniteDifferences() ]\n']);
      fprintf(prob.fid_nfpFiniteDifferences, ['l_alpha:                      ' frmt_x ], l_alpha');

      fprintf(prob.fid_nfpFiniteDifferences, ENDSTR);

  end  

case 71
  % ------------------------------------------------------------------
  % isComplete()
  % part=71; subp=1; print_soln_body;

  switch subp

    case 1
      fprintf(prob.fid_isComplete, ['[ isComplete() ]\n']);
      fprintf(prob.fid_isComplete, ['points_abs_.cols():        [ %i ]\n'], points_num);
      fprintf(prob.fid_isComplete, ['max_terms:                 [ %i ]\n'], max_terms);
      fprintf(prob.fid_isComplete, ['(points_num >= max_terms): [ %i ]\n'], result);
    
      fprintf(prob.fid_isComplete, ENDSTR);

  end    

case 72
  % ------------------------------------------------------------------
  % isOld()
  m22_12 = prob.m22_12;
  frmt_f = [ '[' repmat([m22_12 ', '], 1, size(radius_factor,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_isOld, ['\n[ isOld() ]\n']);
      fprintf(prob.fid_isOld, ['distance.lpNorm<Inf>:      ' frmt_f ], distance);
      fprintf(prob.fid_isOld, ['tr_rad_fac:                ' frmt_f ], radius_factor);
      fprintf(prob.fid_isOld, ['(dist > tr_rad_fac):       [ %i ]\n'], result);
    
      fprintf(prob.fid_isOld, ENDSTR);

  end      

case 73
  % ------------------------------------------------------------------
  % computeQuadraticMNPolynomials()
  m22_12 = prob.m22_12;
  frmt_ps = [ '[' repmat([m22_12 ', '], 1, size(points_shifted,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['[ computeQuadraticMNPolynomials() ]\n']);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['ps: points_shifted             ' frmt_ps ], points_shifted);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['fvalues_diff                   ' frmt_f ], fvalues_diff'); 
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['M = 0.5*(M.^2) + M; M=ps''*ps  [' [m22_12 ' ]\n'] ], M); 

    case 2
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['Solve symmetric system\n']);
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['M_rcond                        [' [m22_12 ' ]\n'] ], M_rcond); 
      fprintf(prob.fid_computeQuadraticMNPolynomials, ['mult_mn                        [' [m22_12 ' ]\n'] ], mult_mn); 

      fprintf(prob.fid_computeQuadraticMNPolynomials, ENDSTR);

  end  

case 74
  % ------------------------------------------------------------------
  % chooseAndReplacePoint()

  switch subp
    
    case 1
      fprintf(prob.fid_chooseAndReplacePoint, ['[ chooseAndReplacePoint() ]\n']);

      fprintf(prob.fid_chooseAndReplacePoint, ENDSTR);

  end  

case 75
  % ------------------------------------------------------------------
  % pointNew()

  switch subp
    
    case 1
      fprintf(prob.fid_pointNew, ['[ pointNew() ]\n']);

      fprintf(prob.fid_pointNew, ENDSTR);

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
      fprintf(prob.fid_tryToAddPoint, ['[ tryToAddPoint() ]\n']);

    case 2
      fprintf(prob.fid_tryToAddPoint, ['rel_piv_threshold: [' [m22_12 ' ]\n'] ], relative_pivot_threshold); 
      fprintf(prob.fid_tryToAddPoint, ['new_fvalues:       ' frmt_f ], new_fvalues);
      fprintf(prob.fid_tryToAddPoint, ['new_point:         ' frmt_x ], new_point);

    case 3
      % fprintf(prob.fid_tryToAddPoint, ['new_fvalues        ' frmt_f ], new_fvalues);
      % fprintf(prob.fid_tryToAddPoint, ['new_point:         ' frmt_x ], new_point);
      fprintf(prob.fid_tryToAddPoint, ['(!point_added):    [ %i ]\n'], ~point_added);
      fprintf(prob.fid_tryToAddPoint, ['cached_fvalues     ' frmt_cf ], model.cached_fvalues);
      fprintf(prob.fid_tryToAddPoint, ['cached_points      ' frmt_cf ], model.cached_points);

    case 4
      fprintf(prob.fid_tryToAddPoint, ['exitflag:          [ %i ]\n' ], exitflag);
      fprintf(prob.fid_tryToAddPoint, ENDSTR);

  end  

case 77
  % ------------------------------------------------------------------
  % pointNew()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point_shifted,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_addPoint, ['[ addPoint() ]\n']);
      fprintf(prob.fid_addPoint, ['pivot_threshold:   [' [m22_12 ' ]\n'] ], pivot_threshold);
      fprintf(prob.fid_addPoint, ['new_point_shifted: ' frmt_x ], new_point_shifted);
      fprintf(prob.fid_addPoint, ['shift_center:      ' frmt_x ], shift_center);

      fprintf(prob.fid_addPoint, ENDSTR);

  end  

case 78
  % ------------------------------------------------------------------
  % changeTrCenter()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_changeTrCenter, ['[ changeTrCenter() ]\n']);

    case 2
      fprintf(prob.fid_changeTrCenter, ['(!is_complete):    [ %i ]\n'], ~is_complete(model, prob));      
      % fprintf(prob.fid_addPoint, ['pivot_threshold:   [' [m22_12 ' ]\n'] ], pivot_threshold);
      % fprintf(prob.fid_addPoint, ['new_point_shifted: ' frmt_x ], new_point_shifted);
      % fprintf(prob.fid_addPoint, ['shift_center:      ' frmt_x ], shift_center);

    case 3

    case 4

    case 5

    case 6          
      fprintf(prob.fid_addPoint, ENDSTR);

  end 









case 99
  % ------------------------------------------------------------------
  % TrustRegionModel()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(TrustRegionModel, ['[ TrustRegionModel() ]\n']);

    case 2

    case 3

      fprintf(prob.TrustRegionModel, ENDSTR);

  end 

case 100
  % ------------------------------------------------------------------
  % TrustRegionOptimization()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_TrustRegionOptimization, ['[ TrustRegionOptimization() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_TrustRegionOptimization, ENDSTR);

  end 

case 101
  % ------------------------------------------------------------------
  % iterate()
  
  frmt_x = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, 1),1)-1) [m22_12 ' ] \n']];
  % frmt_f = [ '[' repmat([m22_12 ', '], 1, size(initial_fvalues(:, 1),1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_iterate, ['[ iterate() ]\n']);
      fprintf(prob.fid_iterate, ['Iteration#    [ %i ];\n'], 0);

    case 2
      fprintf(prob.fid_iterate, ['Iteration #0\n']);      

    case 3

      fprintf(prob.fid_iterate, ENDSTR);

  end 

case 102
  % ------------------------------------------------------------------
  % handleEvaluatedCase()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, k),1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(initial_fvalues(:, k),1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_handleEvaluatedCase, ['[ handleEvaluatedCase() ]\n']);
      fprintf(prob.fid_handleEvaluatedCase, ['iteration#    [ %i ];\n'], 0);
      fprintf(prob.fid_handleEvaluatedCase, ['point:        ' frmt_x ], initial_points(:, k));
      fprintf(prob.fid_handleEvaluatedCase, ['fvalue:       ' frmt_f ], initial_fvalues(:, k));

    case 2

      fprintf(prob.fid_handleEvaluatedCase, ['[ handleEvaluatedCase() ]\n']);
      fprintf(prob.fid_handleEvaluatedCase, ['iteration#    [ %i ];\n'], 0);
      fprintf(prob.fid_handleEvaluatedCase, ['point:        ' frmt_x ], initial_points(:, k));
      fprintf(prob.fid_handleEvaluatedCase, ['fvalue:       ' frmt_f ], initial_fvalues(:, k));

    case 3

      fprintf(prob.fid_handleEvaluatedCase, ENDSTR);

  end 

case 103
  % ------------------------------------------------------------------
  % updateRadius()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_updateRadius, ['[ updateRadius() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_updateRadius, ENDSTR);

  end

case 104
  % ------------------------------------------------------------------
  % computeInitialPoints()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(initial_points(:, 1),1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_computeInitialPoints, ['[ computeInitialPoints() ]\n']);
      fprintf(prob.fid_computeInitialPoints, ['init_point:        ' frmt_x ], initial_points(:, 1));

      fprintf(prob.fid_addInitializationCase, ['init_point:        ' frmt_x ], initial_points(:, 1));
      

    case 2
      fprintf(prob.fid_computeInitialPoints, ['scnd_point:        ' frmt_x ], initial_points(:, 2));
      fprintf(prob.fid_computeInitialPoints, ENDSTR);

      fprintf(prob.fid_addInitializationCase, ['scnd_point:        ' frmt_x ], initial_points(:, 1));

    case 3

  end

case 105
  % ------------------------------------------------------------------
  % setLowerUpperBounds()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_setLowerUpperBounds, ['[ setLowerUpperBounds() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_setLowerUpperBounds, ENDSTR);

  end

case 106
  % ------------------------------------------------------------------
  % IsFinished()
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_IsFinished, ['[ IsFinished() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_IsFinished, ENDSTR);

  end


case 107
  % ------------------------------------------------------------------
  % areInitPointsComputed()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_areInitPointsComputed, ['[ areInitPointsComputed() ]\n']);
      fprintf(prob.fid_areInitPointsComputed, ['init_points_computed_: [ 0 ];\n']);

    case 2
      fprintf(prob.fid_areInitPointsComputed, ['init_points_computed_: [ 1 ];\n']);
      fprintf(prob.fid_areInitPointsComputed, ENDSTR);

    case 3

  end 

case 108
  % ------------------------------------------------------------------
  % isInitialized()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_isInitialized, ['[ isInitialized() ]\n']);
      fprintf(prob.fid_isInitialized, ['is_initialized_: [ 0 ];\n']);

    case 2

    case 3

      fprintf(prob.fid_isInitialized, ENDSTR);

  end

case 109
  % ------------------------------------------------------------------
  % getInitializationCases()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_getInitializationCases, ['[ getInitializationCases() ]\n']);
      fprintf(prob.fid_getInitializationCases, ['#cases: [ %i ];\n'], n_initial_points);
      fprintf(prob.fid_getInitializationCases, ENDSTR);

  end

case 110
  % ------------------------------------------------------------------
  % projectToBounds()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_projectToBounds, ['[ projectToBounds() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_projectToBounds, ENDSTR);

  end 

case 111
  % ------------------------------------------------------------------
  % projectToBounds()
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(new_point,1)-1) [m22_12 ' ] \n']];

  switch subp
    
    case 1
      fprintf(prob.fid_projectToBounds, ['[ projectToBounds() ]\n']);

    case 2

    case 3

      fprintf(prob.fid_projectToBounds, ENDSTR);

  end 

end
