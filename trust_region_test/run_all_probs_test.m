% run_all_probs.m

% --------------------------------------------------------------------
data_file_src = [ ...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data/test_tr-model-data_loc.hpp'];

data_file_trg = [...
'/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
'/Optimization/tests/optimizers/test_tr-model-data.hpp'];

polyn_coeff_src = [...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data/polyn_coeff_'];

polyn_coeff_trg = [...
'/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
'/Optimization/tests/optimizers/polyn_coeff_'];

% --------------------------------------------------------------------
prob = struct();
prob.fid = fopen(data_file_src,'w');
print_soln_head;

prob.dbg_file='prob-soln-data-test.txt';
prob.dbg_file_fid = fopen(prob.dbg_file, 'w');

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB1');
prob.pn = 'prob1';
f = @(x) (1 - x(1))^2;

x0 = [-1.2;
      2];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB2');
prob.pn = 'prob2';
f = @(x) log1p(x(1)^2) + x(2)^2;

x0 = [2;
      2];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB3');
prob.pn = 'prob3';
f = @(x) sin(pi*x(1)/12)*cos(pi*x(2)/16);


x0 = [0;
      0];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB4');
prob.pn = 'prob4';
f = @(x) 0.01*(x(1) - 1)^2 + (x(2) - x(1)^2)^2;

x0 = [2;
      2;
      2];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB5');
prob.pn = 'prob5';
f = @(x) (x(1)-x(2))^2 + (x(2) - x(3))^4;


x0 = [-2.6 ; 2 ; 2];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB6');
prob.pn = 'prob6';

f = @(x) (x(1) + x(2))^2 + (x(2) + x(3))^2;

x0 = [-4;
      1;
      1];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB7');
prob.pn = 'prob7';

f = @(x) log1p(x(1)^2) + log1p((x(1) - x(2))^2) + log1p((x(2) - x(3))^2) + log1p((x(3) - x(4))^2);

x0 = [2;
      2;
      2;
      2];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB8');
prob.pn = 'prob8';

f = @(x) (x(1)*x(2)*x(3)*x(4))^2;

x0 = [0.8;
      0.8;
      0.8;
      0.8];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB9');
prob.pn = 'prob9';

f = @(x) (x(1)-1)^2 + (x(2)-2)^2 + (x(3)-3)^2 + (x(4)-4)^2;


x0 = [1;
      1;
      1;
      1];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB10');
prob.pn = 'prob10';

f = @(x) (x(1) - x(2))^2 + (x(2) - x(3))^2 + (x(3) - x(4))^4 + ...
    (x(4) - x(5))^4;

x0 = [2;
      sqrt(2);
      -1;
      2-sqrt(2);
      0.5];

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fprintf(prob.dbg_file_fid, '\n\n%s\n\n', 'PROB11');
prob.pn = 'prob11';
f = @(x) sum(2*x./(x.*x + 1));

x0 = ones(4, 1);

fi=[]; bl=[]; bu=[]; op=[];
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, op, prob);
fprintf(prob.dbg_file_fid, [ '\nx= ' repmat('%20.10e', 1, size(x, 1))], x);
fprintf(prob.dbg_file_fid, [ '\nfval= ' repmat('%20.10e', size(f, 2), 1)], fval);

% ----------------------------------------------------------
fclose(prob.dbg_file_fid);