
switch(part)

case 1

  % --------------------------------------------------------------------
  % Set formats for x and f
  mf = '%20.16f';
  tab = '            ';
  % tab = '';

  frmt1 = [ repmat(mf, 1, size(initial_points,1)) '\n'];
  frmt1_cpp = ...
  [ repmat([mf ', '], 1, size(initial_points,1)-1) [mf '; \n']];

  frmt2 = [ mf '\n' ];
  frmt2_cpp = [ mf ';\n\n' ];
  frmt3 = [ repmat('%12.1f ', 1, size(old_seed.State,1)) '\n\n'];

  % --------------------------------------------------------------------
  % Print prob name
  ln = repmat('=',1,30);
  ln2 = repmat('-',1,30);
  fprintf(prob.fid, ['\n' tab '// ' ln ln ln '\n'], prob.pn);
  fprintf(prob.fid, [tab '// ' ln '  %s  ' ln '\n'], prob.pn);
  fprintf(prob.fid, [tab '// ' ln ln ln '\n\n'], prob.pn);

  % --------------------------------------------------------------------
  % Print seed
  fprintf(prob.fid, [tab '// seed.Type: ' '%s\n'], old_seed.Type);
  fprintf(prob.fid, [tab '// seed.Seed: ' '%6.0f\n'], old_seed.Seed);
  fprintf(prob.fid, [tab '// seed.State:' frmt3], old_seed.State);

case 2

  % --------------------------------------------------------------------
  % Print initial points + obj.fvals to file
  fprintf(prob.fid, [tab '// --- %s ---\n'], 'Initial points');

  for ii = 1 : size(initial_points, 2)
    fprintf(prob.fid, ...
            [tab '// x' num2str(ii) ': ' frmt1], initial_points(:, ii));
    fprintf(prob.fid, ...
            [tab '// f' num2str(ii) ': ' frmt2], initial_fvalues(:, ii));
  end

  % fprintf(prob.fid,'\n');

  % --------------------------------------------------------------------
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

  % --------------------------------------------------------------------
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

  % --------------------------------------------------------------------
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
    num2str(size(cm, 2)) '); // model.tr_center']);

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

  % --------------------------------------------------------------------
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

end