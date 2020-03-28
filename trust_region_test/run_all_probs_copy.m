% run_all_probs.m

% ----------------------------------------------------------
prob = struct();

% ----------------------------------------------------------
% machine + tr subproblem solver
mach = 'xe-';
% mach = 'bport';

% ----------------------------------------------------------
% tr subproblem solver
% prob.solver = 'snopt';
prob.solver = 'fmincon';

% ----------------------------------------------------------
% Bounds
btag = '-infb'
% btag = '-1e3b';

% ----------------------------------------------------------
% time tag
% dtag = '-20200310';
% dtag= '-20200311';
dtag= '-20200315';

% ----------------------------------------------------------
% iter file name
tag = [ btag dtag ];
prob.dbg_iters=['prob-soln-iters-' mach prob.solver tag ];

% ----------------------------------------------------------
prob.dbg_file=['prob-soln-flow-' mach prob.solver tag '.tex'];
prob.dbg_file_fid = fopen(prob.dbg_file, 'w');

% ----------------------------------------------------------
prob.data_file_src = [ ...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data/test_tr-model-data_loc-xe' tag '.hpp'];

% prob.data_file_trg = [...
% '/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
% '/Optimization/tests/optimizers/test_tr-model-data.hpp'];

prob.data_file_trg = [...
'/home/bellout/git/MB/FOEx/FOEx' ...
'/dc_5Optimization/tests/optimizers/dc_5test_tr-model-data' tag '.hpp'];

% ----------------------------------------------------------
prob.dbg_file_src = [...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data2/'];

prob.dbg_file_trg = [...
'/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
'/Optimization/tests/optimizers/'];

% ----------------------------------------------------------
% Main cpp test file
prob.fid = fopen(prob.data_file_src,'w');
print_soln_head;
prob.m22_12 = '%22.12e';
prob.m22_12 = '%20.10e';

% ----------------------------------------------------------
PN = [ ...
1 ... % 1  prob1
1 ... % 2  prob2
1 ... % 3  prob3
1 ... % 4  prob4
1 ... % 5  prob5
1 ... % 6  prob6
1 ... % 7  prob7
1 ... % 8  prob8
1 ... % 9  prob9
1 ... % 10 prob10
1 ... % 11 prob11
...
0 ... % 12 hs1
0 ... % 13 hs2
0 ... % 14 hs3
0 ... % 15 hs4
0 ... % 16 hs5
0 ... % 17 hs25
0 ... % 18 hs38
0 ... % 19 hs45
];


% digits(128)
prob.lbl = 'iter        fval         rho      radius  pts';
prob.frmt= '%s\n%s\n%s\n';
prob.flnstr = '---------------------------------------------';

if PN(1)==1

% ----------------------------------------------------------
  prob.pn = 'prob1';
  prob = set_filenames(prob);
  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) (1 - x(1))^2;
  x0 = [ -1.2; 2.0 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(2)==1

% ----------------------------------------------------------
  prob.pn = 'prob2';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) log1p(x(1)^2) + x(2)^2;
  x0 = [ 2; 2 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(3)==1

% ----------------------------------------------------------
  prob.pn = 'prob3';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) sin(pi*x(1)/12)*cos(pi*x(2)/16);
  x0 = [ 0; 0 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(4)==1

% ----------------------------------------------------------
  prob.pn = 'prob4';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) 0.01*(x(1) - 1)^2 + (x(2) - x(1)^2)^2;
  x0 = [2; 2; 2];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(5)==1

% ----------------------------------------------------------
  prob.pn = 'prob5';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) (x(1)-x(2))^2 + (x(2) - x(3))^4;
  x0 = [ -2.6; 2; 2 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(6)==1

% ----------------------------------------------------------
  prob.pn = 'prob6';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) (x(1) + x(2))^2 + (x(2) + x(3))^2;
  x0 = [ -4; 1; 1 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(7)==1

% ----------------------------------------------------------
  prob.pn = 'prob7';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) log1p(x(1)^2) + log1p((x(1) - x(2))^2) + log1p((x(2) - x(3))^2) + log1p((x(3) - x(4))^2);
  x0 = [ 2; 2; 2; 2 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(8)==1

% ----------------------------------------------------------
  prob.pn = 'prob8';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) (x(1)*x(2)*x(3)*x(4))^2;
  x0 = [ 0.8; 0.8; 0.8; 0.8 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(9)==1

% ----------------------------------------------------------
  prob.pn = 'prob9';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) (x(1)-1)^2 + (x(2)-2)^2 + (x(3)-3)^2 + (x(4)-4)^2;
  x0 = [ 1; 1; 1; 1];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(10)==1


% ----------------------------------------------------------
  prob.pn = 'prob10';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) (x(1) - x(2))^2 + (x(2) - x(3))^2 + (x(3) - x(4))^4 + ...
      (x(4) - x(5))^4;

  x0 = [ 2; sqrt(2); -1.0; 2-sqrt(2); 0.5 ];

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(11)==1

% ----------------------------------------------------------
  prob.pn = 'prob11';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');

  f = @(x) sum(2*x./(x.*x + 1));
  x0 = ones(4, 1);

  if btag == '-1e3b'
    fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
  elseif btag == '-infb'
    fi=[]; bl=[]; bu=[]; opt=[];
  end
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x,fval,tc,prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end



% ##########################################################

% ##########################################################

% /*
%  * Hock and Schittkowski problems from
%  * https://apmonitor.com/wiki/index.php/Apps/HockSchittkowski
%  */

% Adding selected Hock and Schittkowski problems.


% ==========================================================

if PN(12)==1

% ----------------------------------------------------------
  % /*
  % HS1
  % Initial point x0 = (-2.0, 1.0);
  % Solution: 0.0
  % */
  prob.pn = 'hs1';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs01
  %   Variables
  %     x[1] = -2
  %     x[2] = 1
  %     obj
  %   End Variables

  %   Equations
  %     ! best known objective = 0
  %     obj = 100*(x[2] - x[1]^2)^2 + (1-x[1])^2
  %   End Equations
  % End Model

  % CPP:
  %        100*pow(x(1) - pow(x(0), 2), 2) + pow(1 - x(0), 2);

  % MATLAB:
  f = @(x) 100 * (x(2) - x(1)^2)^2 + (1 - x(1)).^2;

  x0 = [-2.0; 1.0];

  fi=[]; bl=[]; bu=[inf, inf]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(13)==1


  % ----------------------------------------------------------
  % /*
  % HS2
  % Initial point x0 = (-2.0, 1.0);
  % Bounds: ub = (inf, 1.5);
  % Solution: 0.0
  % */
  prob.pn = 'hs2';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs02
  %   Variables
  %     x[1] = -2
  %     x[2] = 1, < 1.5
  %     obj
  %   End Variables

  %   Equations
  %     ! best known objective = 0
  %     obj = 100*(x[2] - x[1]^2)^2 + (1-x[1])^2
  %   End Equations
  % End Model

  % CPP:
  % return 100*pow(x(1) - pow(x(0), 2), 2) + pow(1 - x(0), 2);

  % MATLAB:
  f = @(x) 100 * (x(2) - x(1)^2)^2 + (1 - x(1)).^2;

  x0 = [-2.0; 1.0];

  fi=[]; bl=[]; bu=[inf, 1.5]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(14)==1

  % ----------------------------------------------------------
  % /*
  % HS3
  % Initial point x0 = (10.0, 1.0);
  % Bounds: lb = (-inf, 0.0);
  % Solution: 0.0
  % */
  prob.pn = 'hs3';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs03
  %   Variables
  %     x[1] = 10
  %     x[2] = 1, >0
  %     obj
  %   End Variables

  %   Equations
  %     ! best known objective = 0
  %     obj = x[2] + 0.00001*(x[2]-x[1])^2
  %   End Equations
  % End Model

  % CPP:
  %        x(1) + 1e-5*pow(x(1)-x(0), 2);

  % MATLAB:
  f = @(x) x(1) + 1e-5* (x(2)-x(1))^2;

  x0 = [-10.0; 1.0];

  fi=[]; bl=[-inf, 0.0]; bu=[]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(15)==1

  % ----------------------------------------------------------
  % /*
  % HS4
  % Initial point x0 = (1.125, 0.125)
  % Bounds: lb = (1.0, 0.0)
  % Solution: 8.0/3.0
  % */
  prob.pn = 'hs4';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs04
  %   Variables
  %     x[1] = 1.125, >= 1
  %     x[2] = 0.125, >= 0
  %     obj
  %   End Variables

  %   Equations
  %     ! best known objective = 8/3
  %     obj = (x[1]+1)^3/3 + x[2]
  %   End Equations
  % End Model

  % CPP:
  %         pow(x(0) + 1, 3)/3 + x(1);

  % MATLAB:
  f = @(x) ((x(1) + 1)^3)/3 + x(2);

  x0 = [1.125; 0.125];

  fi=[]; bl=[1.0, 0.0]; bu=[]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end

% ==========================================================

if PN(16)==1

  % ----------------------------------------------------------
  % /*
  % HS5
  % Initial point x0 = (0.0, 0.0)
  % Bounds: lb = (-1.5, -3), ub = (4, 3)
  % Solution: -(sqrt(3)/2 + 3.14159/3) = -1.91322207
  % */
  prob.pn = 'hs5';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs05
  %   Variables
  %     x[1] = 0, >= -1.5, <= 4
  %     x[2] = 0, >= -3, <=3
  %     obj
  %   End Variables

  %   Equations
  %     ! best known objective = -(sqrt(3)/2 + 3.14159/3) = -1.91322207
  %     obj = sin(x[1]+x[2]) + (x[1]-x[2])^2 - 1.5*x[1] + 2.5*x[2] + 1
  %   End Equations
  % End Model

  % CPP:
  % return sin(x(0) + x(1)) + pow(x(0) - x(1), 2) - 1.5*x(0) + 2.5*x(1) + 1;

  % MATLAB:
  f = @(x) sin(x(1) + x(2)) + (x(1) - x(2))^2 - 1.5*x(1) + 2.5*x(2) + 1;

  x0 = [0.0, 0.0];

  fi=[]; bl=[-1.5, -3]; bu=[4, 3]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end







% ==========================================================

if PN(17)==1

% ----------------------------------------------------------
% /*
% HS25
% Initial point x0 = (100.0, 12.5, 3.0)
% Bounds: lb = (0.1, 0, 0), ub = (100.0, 25.6, 5.0);
% Solution: 0.0
% */
prob.pn = 'hs25';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

% ORIG:
% Model hs25
%   Variables
%     x[1] = 100
%     x[2] = 12.5
%     x[3] = 3
%     obj[1:99]
%   End Variables

%   Intermediates
%     s[1] = 1
%     s[2:99] = s[1:98] + 1
%     u[1:99] = 25 + (-50*log(s[1:99]/100))^(2/3)
%   End Intermediates

%   Equations
%     1/10 <= x[1] <= 100
%     0 <= x[2] <= 25.6
%     0 <= x[3] <= 5

%     ! best known objective = 0
%     obj[1:99] = (-s[1:99]/100 + exp(-(u[1:99] - x[2])^x[3]/x[1]))^2
%   End Equations
% End Model

% CPP:
% double result = 0;
% double u;

% for (double i = 1; i < 100; i++){
%   u = 25.0 + pow(-50.0*log(i/100), (2/3));
%   result = result + pow(exp(-u - pow(x(1), x(2))/x(0)) - i/100, 2);
% }
% return result;

% MATLAB:
% f = hs25(x)
f = @(x) hs25(x); % ?????????

x0 = [100.0; 12.5; 3.0];

fi=[]; bl=[0.1, 0.0, 0.0]; bu=[100.0, 25.6, 5.0]; opt=[]; % def. bound in FO
prob.bl = bl; prob.bu = bu;

[x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x, fval, tc, prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

end





% ==========================================================

if PN(18)==1

  % ----------------------------------------------------------
  % /*
  % HS38
  % Initial point x0 = (-3.0, -1.0, -3.0, -1)
  % Bounds: lb = (-10.0, -10.0, -10.0, -10.0), ub = (10.0, 10.0, 10.0, 10.0)
  % Solution: 0
  % */
  prob.pn = 'hs38';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs38
  %   Variables
  %     x[1] = -3, >=-10, <=10
  %     x[2] = -1, >=-10, <=10
  %     x[3] = -3, >=-10, <=10
  %     x[4] = -1, >=-10, <=10
  %     obj
  %   End Variables

  %   Equations
  %     ! best known objective = 0
  %     obj = 100*(x[2]-x[1]^2)^2 + (1-x[1])^2 + 90*(x[4]-x[3]^2)^2 + (1-x[3])^2 + 10.1*( (x[2]-1)^2 + (x[4]-1)^2 ) + 19.8*(x[2]-1)*(x[4]-1)
  %   End Equations
  % End Model

  % CPP:
  % return 100*pow(x(1) - pow(x(0), 2), 2)
  %   + pow(1 - x(0), 2)
  %   + 90*pow(x(3) - pow(x(2), 2), 2)
  %   + pow(1 - x(2), 2)
  %   + 10.1*(pow(x(1) - 1, 2)
  %       + pow(x(3) - 1, 2))
  %   + 19.8*(x(1) - 1)*(x(3) - 1);

  % MATLAB:
  f = @(x) 100*(x(2) - x(1)^2)^2 ...
      + (1 - x(1))^2 ...
      + 90*(x(4)-x(3)^2)^2 ...
      + (1 - x(3))^2 ...
      + 10.1*( (x(2) - 1)^2 ...
              + (x(4)-1)^2 ) ...
      + 19.8*(x(2) - 1)*(x(4) - 1);

  x0 = [-3.0; -1.0; -3.0; -1.0];

  fi=[]; bl=[-10.0, -10.0, -10.0, -10.0]; bu=[10.0, 10.0, 10.0, 10.0]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end


% ==========================================================

if PN(19)==1

  % ----------------------------------------------------------
  % /*
  % HS45
  % Initial point x0 = (0.0, 0.0, 0.0, 0.0, 0.0)
  % Bounds: lb = (0.0, 0.0, 0.0, 0.0, 0.0), ub = (1.0, 2.0, 3.0, 4.0, 5.0);
  % Solution: 1
  % */
  prob.pn = 'hs45';
  prob = set_filenames(prob);

  prob.dbg_iters_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
  fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
  fprintf(prob.dbg_iters_fid, frmt, prob.pn, prob.flnstr, prob.lbl);

  % ORIG:
  % Model hs45
  %   Variables
  %     x[1] = 0, >=0, <=1
  %     x[2] = 0, >=0, <=2
  %     x[3] = 0, >=0, <=3
  %     x[4] = 0, >=0, <=4
  %     x[5] = 0, >=0, <=5
  %     obj
  %   End Variables

  %   Equations

  %     ! best known objective = 1
  %     obj = 2 - x[1]*x[2]*x[3]*x[4]*x[5]/120
  %   End Equations
  % End Model

  % CPP:
  %        2 - x(0)*x(1)*x(2)*x(3)*x(4)/120;

  % MATLAB:
  f = @(x) 2 - x(1)*x(2)*x(3)*x(4)*x(5)/120;

  x0 = [0.0; 0.0; 0.0; 0.0; 0.0 ];

  fi=[]; bl=[0.0, 0.0, 0.0, 0.0, 0.0]; bu=[1.0, 2.0, 3.0, 4.0, 5.0]; opt=[]; % def. bound in FO
  prob.bl = bl; prob.bu = bu;

  [x, fval, tc] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
  printxf(x, fval, tc, prob);
  close_all_files(prob);
  fprintf('----------------------------------------------------\n\n');
  fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
  fclose(prob.dbg_iters_fid);

end


% ----------------------------------------------------------
print_soln_tail;
fclose(prob.fid);

% system(['cp ' prob.data_file_src ' ' prob.data_file_trg ]);


















% /******************************************************************************
%    Created by einar on 11/15/16.
%    Copyright (C) 2016 Einar J.M. Baumann <einar.baumann@gmail.com>

%    This file is part of the FieldOpt project.

%    FieldOpt is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    FieldOpt is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with FieldOpt.  If not, see <http://www.gnu.org/licenses/>.
% ******************************************************************************/
% #ifndef FIELDOPT_TEST_RESOURCE_TEST_FUNCTIONS_H
% #define FIELDOPT_TEST_RESOURCE_TEST_FUNCTIONS_H

% #include <Eigen/Core>

% using namespace Eigen;

% namespace TestResources {
%     /*!
%      * @brief This namespace contains synthetic functions meant to be used
%      * for testQing optimzation algorithms.
%      *
%      * Note that these are all formulated for minimization.
%      */
%     namespace TestFunctions {

%         /*!
%          * @brief Sphere function.
%          *
%          * Formula: \f$ \sum_{i=1}^{n} x^2_i \f$
%          * Minimum: \f$ f(x_1, ..., x_n) = f(0, ..., 0) = 0 \f$
%          * Domain:  \f$ - \infty \leq x_i \leq \infty \f$
%          * Dimensions: \f$ 1 \leq i \leq n \f$
%          *
%          * @param xs Vector of _continous_ variable values.
%          * @return The function value at the given positon.
%          */
%         inline double Sphere(VectorXd xs) {
%             return (xs.cwiseProduct(xs)).sum();
%         }

%         /*!
%          * @brief Rosenbrock function.
%          *
%          * Formula: \f$ \sum_{i=1}^{n-1} \left[ 100 (x_{i+1} - x_i^2)^2 + (x_i -1)^2 \right] \f$
%          * Minimum: \f$ f(1, ..., 1) = 0 \f$
%          * Domain:  \f$ - \infty \leq x_i \leq \infty \f$
%          * Dimensions: \f$ 1 \leq i \leq n \f$
%          *
%          * @param xs Vector of _continous_ variable values.
%          * @return The function value at the given position.
%          */
%         inline double Rosenbrock(VectorXd xs) {
%             VectorXd xhead = xs.head(xs.size() - 1);
%             VectorXd xtail = xs.tail(xs.size() - 1);

%             VectorXd p1 = xtail - xhead.cwiseProduct(xhead);
%             VectorXd p2 = xhead - VectorXd::Ones(xhead.size());
%             return (100 * p1.cwiseProduct(p1) + p2.cwiseProduct(p2)).sum();
%         }

%         /*!
%          * @brief CG.prob1 -> f = @(x) (1 - x(1))^2
%          * Initial point: x0=[-1.2 2.0]
%          */
%         inline double tr_dfo_prob1(VectorXd xs) {
%             double arg1 = 1 - xs(0);
%             return pow(arg1,2);
%         }

%         /*!
%          * @brief CG.prob2 -> f = @(x) log1p(x(1)^2) + x(2)^2;
%          * Initial point: x0=[2.0 2.0]
%          */
%         inline double tr_dfo_prob2(VectorXd xs) {
%             double arg1 = pow(xs(0),2);
%             double arg2 = pow(xs(1),2);
%             return log1p(arg1) + arg2;
%         }

%         /*!
%          * @brief CG.prob3 -> f = @(x) sin(pi*x(1)/12) * cos(pi*x(2)/16);
%          * Initial point: x0=[0.0 0.0]
%          */
%         inline double tr_dfo_prob3(VectorXd xs) {
%             double arg1 = M_PI * xs(0)/12;
%             double arg2 = M_PI * xs(1)/16;
%             return sin(arg1) * cos(arg2);
%         }

%         /*!
%          * @brief CG.prob4 -> f = @(x) 0.01*(x(1) - 1)^2 + (x(2) - x(1)^2)^2;
%          * Initial point: x0=[2.0 2.0 2.0]
%          */
%         inline double tr_dfo_prob4(VectorXd xs) {
%             double arg1 = 0.01 * pow((xs(0) - 1), 2);
%             double arg2 = pow(xs(1) - pow(xs(0), 2), 2);
%             return arg1 + arg2;
%         }

%         /*!
%          * @brief CG.prob5 -> f = @(x) (x(1) - x(2))^2 + (x(2) - x(3))^4;
%          * Initial point: x0=[-2.6 2.0 2.0]
%          */
%         inline double tr_dfo_prob5(VectorXd xs) {
%             double arg1 = pow((xs(0) - xs(1)), 2);
%             double arg2 = pow((xs(1) - xs(2)), 4);
%             return arg1 + arg2;
%         }

%         /*!
%          * @brief CG.prob6 -> f = @(x) (x(1) + x(2))^2 + (x(2) + x(3))^2;
%          * Initial point: x0=[-4.0 1.0 1.0]
%          */
%         inline double tr_dfo_prob6(VectorXd xs) {
%             double arg1 = pow((xs(0) - xs(1)), 2);
%             double arg2 = pow((xs(1) - xs(2)), 2);
%             return arg1 + arg2;
%         }

%         /*!
%          * @brief CG.prob7 -> f = @(x) log1p(x(1)^2) + log1p((x(1)
%          * - x(2))^2) + log1p((x(2) - x(3))^2) + log1p((x(3) - x(4))^2);
%          * Initial point: x0=[2.0 2.0 2.0 2.0]
%          */
%         inline double tr_dfo_prob7(VectorXd xs) {
%             double arg1 = log1p(pow(xs(0), 2));
%             double arg2 = log1p(pow((xs(0) - xs(1)), 2));
%             double arg3 = log1p(pow((xs(1) - xs(2)), 2));
%             double arg4 = log1p(pow((xs(2) - xs(3)), 2));
%             return arg1 + arg2 + arg3 + arg4;
%         }

%         /*!
%          * @brief CG.prob8 -> f = @(x) (x(1)*x(2)*x(3)*x(4))^2;
%          * Initial point: x0=[0.8 0.8 0.8 0.8]
%          */
%         inline double tr_dfo_prob8(VectorXd xs) {
%             double arg1 = pow((xs(0) * xs(1) * xs(2) * xs(3)), 2);
%             return arg1;
%         }

%         /*!
%          * @brief CG.prob9 -> f = @(x) (x(1)-1)^2 + (x(2)-2)^2 + (x(3)-3)^2 + (x(4)-4)^2;
%          * Initial point: x0=[1.0 1.0 1.0 1.0]
%          */
%         inline double tr_dfo_prob9(VectorXd xs) {
%             double arg1 = pow((xs(0) - 1), 2);
%             double arg2 = pow((xs(1) - 2), 2);
%             double arg3 = pow((xs(2) - 3), 2);
%             double arg4 = pow((xs(3) - 4), 2);
%             return arg1 + arg2 + arg3 + arg4;
%         }

%         /*!
%          * @brief CG.prob10 -> f = @(x)
%          * (x(1) - x(2))^2 + (x(2) - x(3))^2 +
%          * (x(3) - x(4))^4 + (x(4) - x(5))^4;
%          * Initial point: x0=[2.0 sqrt(2) -1.0 2-sqrt(2) 0.5]
%          */
%         inline double tr_dfo_prob10(VectorXd xs) {
%             double arg1 = pow((xs(0) - xs(1)), 2);
%             double arg2 = pow((xs(1) - xs(2)), 2);
%             double arg3 = pow((xs(2) - xs(3)), 4);
%             double arg4 = pow((xs(3) - xs(4)), 4);
%             return arg1 + arg2 + arg3 + arg4;
%         }

%         /*!
%          * @brief CG.prob11 -> f = @(x) sum(2*x./(x.*x + 1));
%          * Initial point: x0=[1.0 1.0 1.0 1.0]
%          */
%         inline double tr_dfo_prob11(VectorXd xs) {
%             auto xc = xs; xc.fill(1);
%             auto arg1 = 2*xs;
%             auto arg2 = xs.cwiseProduct(xs) + xc;
%             auto arg3 = arg1.cwiseQuotient(arg2);
%             return arg3.sum();
%         }

%         /*
%          * Hock and Schittkowski problems from
%          * https://apmonitor.com/wiki/index.php/Apps/HockSchittkowski
%          */

%         /*
%           HS1
%           Initial point x0 = (-2.0, 1.0);
%           Solution: 0.0
%         */
%         inline double hs1(VectorXd x) {
%           return 100*pow(x(1) - pow(x(0), 2), 2) + pow(1 - x(0), 2);
%         }

%         /*
%           HS2
%           Initial point x0 = (-2.0, 1.0);
%           Bounds: ub = (inf, 1.5);
%           Solution: 0.0
%         */
%         inline double hs2(VectorXd x){
%           return hs1(x);
%         }

%         /*
%           HS3
%           Initial point x0 = (10.0, 1.0);
%           Bounds: lb = (-inf, 0.0);
%           Solution: 0.0
%         */
%         inline double hs3(VectorXd x){
%           return x(1) + 1e-5*pow(x(1)-x(0), 2);
%         }


%         /*
%           HS4
%           Initial point x0 = (1.125, 0.125)
%           Bounds: lb = (1.0, 0.0)
%           Solution: 8.0/3.0
%         */
%         inline double hs4(VectorXd x){
%           return pow(x(0) + 1, 3)/3 + x(1);
%         }

%         /*
%           HS5
%           Initial point x0 = (0.0, 0.0)
%           Bounds: lb = (-1.5, -3), ub = (4, 3)
%           Solution: -(sqrt(3)/2 + 3.14159/3) = -1.91322207
%         */
%         inline double hs5(VectorXd x){
%           return sin(x(0) + x(1)) + pow(x(0) - x(1), 2) - 1.5*x(0) + 2.5*x(1) + 1;
%         }

%         /*
%           HS25
%           Initial point x0 = (100.0, 12.5, 3.0)
%           Bounds: lb = (0.1, 0, 0), ub = (100.0, 25.6, 5.0);
%           Solution: 0.0
%         */
%         inline double hs25(VectorXd x){
%           double result = 0;
%           double u;

%           for (double i = 1; i < 100; i++){
%             u = 25.0 + pow(-50.0*log(i/100), (2/3));
%             result = result + pow(exp(-u - pow(x(1), x(2))/x(0)) - i/100, 2);
%           }
%           return result;
%         }

%         /*
%           HS38
%           Initial point x0 = (-3.0, -1.0, -3.0, -1)
%           Bounds: lb = (-10.0, -10.0, -10.0, -10.0), ub = (10.0, 10.0, 10.0, 10.0)
%           Solution: 0
%         */
%         inline double hs38(VectorXd x){
%           return 100*pow(x(1) - pow(x(0), 2), 2)
%             + pow(1 - x(0), 2)
%             + 90*pow(x(3) - pow(x(2), 2), 2)
%             + pow(1 - x(2), 2)
%             + 10.1*(pow(x(1) - 1, 2)
%                 + pow(x(3) - 1, 2))
%             + 19.8*(x(1) - 1)*(x(3) - 1);
%         }

%         /*
%           HS45
%           Initial point x0 = (0.0, 0.0, 0.0, 0.0, 0.0)
%           Bounds: lb = (0.0, 0.0, 0.0, 0.0, 0.0), ub = (1.0, 2.0, 3.0, 4.0, 5.0);
%           Solution: 1
%         */
%         inline double hs45(VectorXd x){
%           return 2 - x(0)*x(1)*x(2)*x(3)*x(4)/120;
%         }



%     }
% }

% #endif //FIELDOPT_TEST_RESOURCE_TEST_FUNCTIONS_H
