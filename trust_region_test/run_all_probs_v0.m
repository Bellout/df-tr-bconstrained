% run_all_probs.m

% ----------------------------------------------------------
prob = struct();

mach = 'xe-snopt';
% mach = 'bport-snopt';

prob.dbg_iters=['prob-soln-iters-' mach ];

prob.dbg_file=['prob-soln-flow-' mach '.tex'];
prob.dbg_file_fid = fopen(prob.dbg_file, 'w');

% ----------------------------------------------------------
prob.data_file_src = [ ...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data/test_tr-model-data_loc-xe.hpp'];

% prob.data_file_trg = [...
% '/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
% '/Optimization/tests/optimizers/test_tr-model-data.hpp'];

prob.data_file_trg = [...
'/home/bellout/git/MB/FOEx/FOEx' ...
'/dc_5Optimization/tests/optimizers/dc_5test_tr-model-data.hpp'];

% ----------------------------------------------------------
prob.dbg_file_src = [...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data/'];

prob.dbg_file_trg = [...
'/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
'/Optimization/tests/optimizers/'];

% ----------------------------------------------------------
% Main cpp test file
prob.fid = fopen(prob.data_file_src,'w');
print_soln_head;
prob.m22_12 = '%22.12e';
prob.m22_12 = '%20.10e';

% digits(128)
lbl = 'iter        fval         rho      radius  pts';
frmt= '%s\n%s\n%s\n';
prob.flnstr = '---------------------------------------------';

% ----------------------------------------------------------
prob.pn = 'prob1';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob1', prob.flnstr, lbl);

f = @(x) (1 - x(1))^2;

x0 = [-1.2;
      2];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob2';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob2', prob.flnstr, lbl);

f = @(x) log1p(x(1)^2) + x(2)^2;

x0 = [2;
      2];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob3';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob3', prob.flnstr, lbl);

f = @(x) sin(pi*x(1)/12)*cos(pi*x(2)/16);

x0 = [0;
      0];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob4';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob4', prob.flnstr, lbl);

f = @(x) 0.01*(x(1) - 1)^2 + (x(2) - x(1)^2)^2;

x0 = [2;
      2;
      2];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob5';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob5', prob.flnstr, lbl);

f = @(x) (x(1)-x(2))^2 + (x(2) - x(3))^4;

x0 = [-2.6 ; 2 ; 2];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob6';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob6', prob.flnstr, lbl);

f = @(x) (x(1) + x(2))^2 + (x(2) + x(3))^2;

x0 = [-4;
      1;
      1];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob7';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob7', prob.flnstr, lbl);

f = @(x) log1p(x(1)^2) + log1p((x(1) - x(2))^2) + log1p((x(2) - x(3))^2) + log1p((x(3) - x(4))^2);

x0 = [2;
      2;
      2;
      2];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob8';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob8', prob.flnstr, lbl);

f = @(x) (x(1)*x(2)*x(3)*x(4))^2;

x0 = [0.8;
      0.8;
      0.8;
      0.8];


% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob9';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob9', prob.flnstr, lbl);

f = @(x) (x(1)-1)^2 + (x(2)-2)^2 + (x(3)-3)^2 + (x(4)-4)^2;

x0 = [1;
      1;
      1;
      1];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob10';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob10', prob.flnstr, lbl);

f = @(x) (x(1) - x(2))^2 + (x(2) - x(3))^2 + (x(3) - x(4))^4 + ...
    (x(4) - x(5))^4;

x0 = [2;
      sqrt(2);
      -1;
      2-sqrt(2);
      0.5];

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
prob.pn = 'prob11';
prob = set_filenames(prob);

prob.dbg_iters_fid = fopen([prob.dbg_iters '-' prob.pn '-MATLAB.tex'], 'w');
fprintf(prob.dbg_iters_fid, '%s\n', '\begin{alltt}');
fprintf(prob.dbg_iters_fid, frmt, 'prob11', prob.flnstr, lbl);

f = @(x) sum(2*x./(x.*x + 1));

x0 = ones(4, 1);

% fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
fi=[]; bl=[]; bu=[]; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);
printxf(x,fval,prob);
close_all_files(prob);
fprintf('----------------------------------------------------\n\n');
fprintf(prob.dbg_iters_fid, '\n%s\n', '\end{alltt}');
fclose(prob.dbg_iters_fid);

% ----------------------------------------------------------
print_soln_tail;
fclose(prob.fid);

% system(['cp ' prob.data_file_src ' ' prob.data_file_trg ]);

function [] = printxf(x, fval, prob)  
  frmtx = '%12.6e  ';
  frmtf = '%12.6e';

  fprintf(prob.dbg_iters_fid, '%s', prob.flnstr);
  fprintf(prob.dbg_iters_fid, [ '\nx* = ' repmat(frmtx, 1, size(x, 1))], x');
  fprintf(prob.dbg_iters_fid, [ '\nf* = ' repmat(frmtf, size(fval, 2), 1)], fval);
  fprintf(prob.dbg_iters_fid, [ '\ntc: %s' ], 'DUMMY');

  fprintf([ '\nx* = ' repmat(frmtx, 1, size(x, 1))], x);
  fprintf([ '\nf* = ' repmat(frmtf, size(fval, 2), 1)], fval);
end