
switch(part)

case 0

  % ------------------------------------------------------------------
  % Set formats for x and f
  mf = '%20.16f';
  mE = '%20.16E';
  m22_12 = '%22.12e';
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

  % ------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_pnp = [ repmat([mf ', '], 1, size(pnp.coefficients,1)-1) [mf '; \n']];

  % ------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR NEW POINT POLYNOMIALS.COEFFICIENTS,
  fprintf(prob.fid, [tab '// Polynomial [-polynomial_max] (input data):\n']);
  fprintf(prob.fid, ...
        [tab prob.pn '.pnp.col(' num2str(1-1) ') << ' frmt_pnp], ...
        pnp.coefficients);
  fprintf(prob.fid, [tab 'v_pnp.push_back(' prob.pn '.pnp);\n' ]);

case 6

  % ------------------------------------------------------------------
  %  Collect data
  obp = obj_pol ;

  % ------------------------------------------------------------------
  tlt = [ 'C++ POINT SOLVE TR SUBPROBLEM ' ];
  fprintf(prob.fid, '\n%s\n%s\n\n', [tab '// ' ln2 ln2 ln2], [ tab '// ' tlt]);

  % ------------------------------------------------------------------
  % C++ [FORMAT]
  frmt_obp = [ repmat([mf ', '], 1, size(obp.coefficients,1)-1) [mf '; \n']];

  % ------------------------------------------------------------------
  % C++ [PRINT DATA] CALLS FOR NEW POINT POLYNOMIALS.COEFFICIENTS,
  fprintf(prob.fid, [tab '// Polynomial [-polynomial_max] (input data):\n']);
  fprintf(prob.fid, ...
        [tab prob.pn '.obp.col(' num2str(1-1) ') << ' frmt_obp], ...
        obp.coefficients);
  fprintf(prob.fid, [tab 'v_obp.push_back(' prob.pn '.obp);\n' ]);


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
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(polynomial.coefficients,1)-1) [m22_12 ' ] \n']];
  frmt_tr_c = [ '[' repmat([m22_12 ', '], 1, size(x_tr_center,1)-1) [m22_12 ' ] \n']];

  % ------------------------------------------------------------------
  fprintf(prob.fid_minimizeTr, ['[ minimizeTr() ]\n']);  

  fprintf(prob.fid_minimizeTr, ['Debug input polyn/x_tr_center/radius:\n']);
  fprintf(prob.fid_minimizeTr, ['polyn.coeffs ' frmt_p ], polynomial.coefficients);
  fprintf(prob.fid_minimizeTr, ['x_tr_center  ' frmt_tr_c ], x_tr_center');
  fprintf(prob.fid_minimizeTr, ['radius ' m22_12 ' | tol_tr ' m22_12 '\n' ], radius, tol_tr);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug x0 + bounds_mod:\n']);
  fprintf(prob.fid_minimizeTr, ['x0     ' frmt_x ], x0);
  fprintf(prob.fid_minimizeTr, ['bl_mod ' frmt_bnd ], bl_mod);
  fprintf(prob.fid_minimizeTr, ['bu_mod ' frmt_bnd ], bu_mod);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_minimizeTr, ['c  [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_minimizeTr, ['g  ' frmt_g ], g);
  fprintf(prob.fid_minimizeTr, ['H  ' frmt_H ], H);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug computed gx, xHx values:\n']);
  fprintf(prob.fid_minimizeTr, ['gx  [ ' [m22_12 ' ]\n'] ], gx);
  fprintf(prob.fid_minimizeTr, ['xHx [ ' [m22_12 ' ]\n'] ], xHx);

  fprintf(prob.fid_minimizeTr, '\n');
  fprintf(prob.fid_minimizeTr, ['Debug xsol, fval [fmincon/SNOPT]::\n']);
  fprintf(prob.fid_minimizeTr, ['xsol ' frmt_x ], x);
  fprintf(prob.fid_minimizeTr, ['fval [' [m22_12 ' ]\n'] ], fval);  

case 10  

  % ------------------------------------------------------------------
  % improveModelNfp()

  frmt_pts_shifted = [ repmat([mE ', '], 1, size(points_shifted,1)-1) [mE '; \n']];
  frmt_shift_center = [ repmat([mE ', '], 1, size(shift_center,1)-1) [mE '; \n']];

  fprintf(prob.fid_improveModelNfp, [tab '// [ improveModelNfp() ]\n']);  
  fprintf(prob.fid_improveModelNfp, [tab '// points_shifted: ' frmt_pts_shifted ], points_shifted);
  fprintf(prob.fid_improveModelNfp, [tab '// points_shifted: ' frmt_shift_center ], frmt_shift_center);

case 11

  % ------------------------------------------------------------------ 
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(model.points_abs,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_checkInterpolation, ['\n[ checkInterpolation() ]\n']);
  fprintf(prob.fid_checkInterpolation, ['radius      [' [m22_12 ' ]\n'] ], model.radius);
  fprintf(prob.fid_checkInterpolation, ['tol_1 ' m22_12 ' | tol_2 ' m22_12 '\n' ], tol_1, tol_2);
  fprintf(prob.fid_checkInterpolation, ['idx_tr_center  [ ' [m22_12 ' ]\n'] ], model.tr_center);
  fprintf(prob.fid_checkInterpolation, ['n_points       [ ' [m22_12 ' ]\n'] ], n_points);
  fprintf(prob.fid_checkInterpolation, ['x_tr_center ' frmt_x ], model.points_abs(:, model.tr_center)');

  for c = size(h,2):-1:1
    fprintf(prob.fid_checkInterpolation, ['h(:, c)       ' frmt_x ], h(:, c));
  end

case 12

  % ------------------------------------------------------------------ 
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_checkInterpolation, ['c  [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_checkInterpolation, ['g  ' frmt_g ], g);
  fprintf(prob.fid_checkInterpolation, ['H  ' frmt_H ], H);

case 13

  % ------------------------------------------------------------------ 
  % checkInterpolation()

  m22_12 = prob.m22_12;
  frmt_A    = [ '[' repmat([m22_12 ', '], 1, size(A,2)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['this_value  [' [m22_12 ' ]\n'] ], this_value);
  fprintf(prob.fid_checkInterpolation, ['difference  [' [m22_12 ' ]\n'] ], difference);
  fprintf(prob.fid_checkInterpolation, ['max_diff    [' [m22_12 ' ]\n'] ], max_diff);

  fprintf(prob.fid_checkInterpolation, '\n');
  fprintf(prob.fid_checkInterpolation, ['A: fvalues(k, :)      ' frmt_x ], A');
  fprintf(prob.fid_checkInterpolation, ['B: max(fvalues(k, :)) [' [m22_12 ' ]\n'] ], B);
  fprintf(prob.fid_checkInterpolation, ['C: tol_1*B            [' [m22_12 ' ]\n'] ], C);
  fprintf(prob.fid_checkInterpolation, ['D: max(C, tol_2)      [' [m22_12 ' ]\n'] ], D);

case 14
  
  % ------------------------------------------------------------------
  % solveTrSubproblem()

  m22_12 = prob.m22_12;
  frmt_p    = [ '[' repmat([m22_12 ', '], 1, size(obj_pol.coefficients,1)-1) [m22_12 ' ] \n']];
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(x_tr_center,1)-1) [m22_12 ' ] \n']];

  % fprintf(prob.fid_solveTrSubproblem, '\n');
  fprintf(prob.fid_solveTrSubproblem, ['[ solveTrSubproblem() ]\n']);
  fprintf(prob.fid_solveTrSubproblem, ['idx_tr_center    [' [m22_12 ' ]\n'] ], model.tr_center);
  fprintf(prob.fid_solveTrSubproblem, ['x_tr_center      ' frmt_x ], x_tr_center');
  fprintf(prob.fid_solveTrSubproblem, ['orig.p.coeffs    ' frmt_p ], obj_pol.coefficients);
  fprintf(prob.fid_solveTrSubproblem, ['shifted.p.coeffs ' frmt_p ], obj_pol2.coefficients);

case 15

  % ------------------------------------------------------------------
  % reCenterPoints() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_reCenterPoints, ['\n[ reCenterPoints() ]\n']);
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

case 17

  % ------------------------------------------------------------------
  % rowPivotGaussianElimination() -> reBuildModel()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(points_abs,1)-1) [m22_12 ' ] \n']];
  frmt_f    = [ '[' repmat([m22_12 ', '], 1, size(fvalues,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_rowPivotGaussianElimination, ['\n[ rowPivotGaussianElimination() ]\n']);
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

case 28

  % ------------------------------------------------------------------
  % measureCriticality()

  m22_12 = prob.m22_12;
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(grad,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_measureCriticality, ['\n[ measureCriticality() ]\n']);
  % fprintf(prob.fid_measureCriticality, ['Debug p-matrices g:\n']);
  fprintf(prob.fid_measureCriticality, ['g  ' frmt_g ], grad);

  fprintf(prob.fid_measureCriticality, '\n');
  fprintf(prob.fid_measureCriticality, ['x_center             ' frmt_g ], x_center');
  fprintf(prob.fid_measureCriticality, ['A: (x_center - grad) ' frmt_g ], A');
  fprintf(prob.fid_measureCriticality, ['B: max(bl, A)        ' frmt_g ], B');
  fprintf(prob.fid_measureCriticality, ['C: min(bu, B)        ' frmt_g ], C');
  fprintf(prob.fid_measureCriticality, ['D: C - x_center      ' frmt_g ], m');

case 29

  % ------------------------------------------------------------------
  % shiftPolynomial()

  m22_12 = prob.m22_12;
  frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(s,1)-1) [m22_12 ' ] \n']];
  frmt_g    = [ '[' repmat([m22_12 ', '], 1, size(g,1)-1) [m22_12 ' ] \n']];
  frmt_H    = [ '[' repmat([m22_12 ', '], 1, size(H,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_shiftPolynomial, '\n');
  fprintf(prob.fid_shiftPolynomial, ['[ shiftPolynomial() ]\n']);
  fprintf(prob.fid_shiftPolynomial, ['s ' frmt_x ], s);

  fprintf(prob.fid_shiftPolynomial, '\n');
  fprintf(prob.fid_shiftPolynomial, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_shiftPolynomial, ['c  [' [m22_12 ' ]\n'] ], c);
  fprintf(prob.fid_shiftPolynomial, ['g  ' frmt_g ], g);
  fprintf(prob.fid_shiftPolynomial, ['H  ' frmt_H ], H);

  fprintf(prob.fid_shiftPolynomial, '\n');
  fprintf(prob.fid_shiftPolynomial, ['Debug p-matrices c, g, H:\n']);
  fprintf(prob.fid_shiftPolynomial, ['c  [' [m22_12 ' ]\n'] ], c_mod);
  fprintf(prob.fid_shiftPolynomial, ['g  ' frmt_g ], g_mod);

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

case 31

  % ------------------------------------------------------------------
  % criticalityStep()

  m22_12 = prob.m22_12;
  % frmt_x    = [ '[' repmat([m22_12 ', '], 1, size(model.x_tr_center,1)-1) [m22_12 ' ] \n']];

  fprintf(prob.fid_criticalityStep, ['[ criticalityStep() ]\n']);

  fprintf(prob.fid_criticalityStep, '\n');
  fprintf(prob.fid_criticalityStep, ['A: ~is_lambda_poised() [' [m22_12 ' ]\n'] ], A);
  fprintf(prob.fid_criticalityStep, ['B: is_old()            [' [m22_12 ' ]\n'] ], B);

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

  % ------------------------------------------------------------------
  % computePolynomialModels()

end