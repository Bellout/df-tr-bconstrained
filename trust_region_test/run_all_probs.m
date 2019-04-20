% run_all_probs.m

% ----------------------------------------------------------
prob = struct();

% ----------------------------------------------------------
prob.data_file_src = [ ...
'/home/bellout/git/MB/df-tr-bconstrained/' ...
'prob_data/test_tr-model-data_loc.hpp'];

prob.data_file_trg = [...
'/home/bellout/git/IOC/FieldOpt-Research/FieldOpt' ...
'/Optimization/tests/optimizers/test_tr-model-data.hpp'];

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


digits(128)

% ----------------------------------------------------------
prob.pn = 'prob1';
prob = set_filenames(prob);

f = @(x) (1 - x(1))^2;

x0 = [-1.2;
      2];
                                    % fi  bl  bu  opt 
% fi=[]; bl=[]; bu=[]; opt=[];
fi=[]; bl=-1e3; bu=1e3; opt=[]; % def. bound in FO
[x, fval] = trust_region_dbg({f}, x0, fi, bl, bu, opt, prob);

close_all_files(prob);

% % ----------------------------------------------------------
% prob.pn = 'prob2';
% prob.fidpc = fopen([polyn_coeff_src prob.pn '.txt'], 'w');
% polyn_coeff_trg = [ polyn_coeff_trg prob.pn '.txt'];

% if (~strcmp(prob.cf_prev, prob.cf))
%   fprintf(prob.fidpc, '[ %s (%s)]\n', prob.cf, prob.cf_prev);
% end
% prob.cf_prev = prob.cf;

% f = @(x) log1p(x(1)^2) + x(2)^2;

% x0 = [2;
%       2];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);
% fclose(prob.fidpc);

% % ----------------------------------------------------------
% prob.pn = 'prob3';
% prob.fidpc = fopen([polyn_coeff_src prob.pn '.txt'], 'w');
% polyn_coeff_trg = [ polyn_coeff_trg prob.pn '.txt'];

% if (~strcmp(prob.cf_prev, prob.cf))
%   fprintf(prob.fidpc, '[ %s ]\n', prob.cf);
% end
% prob.cf_prev = prob.cf;

% f = @(x) sin(pi*x(1)/12)*cos(pi*x(2)/16);


% x0 = [0;
%       0];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);
% fclose(prob.fidpc);

% % ----------------------------------------------------------
% prob.pn = 'prob4';
% f = @(x) 0.01*(x(1) - 1)^2 + (x(2) - x(1)^2)^2;

% x0 = [2;
%       2;
%       2];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob5';
% f = @(x) (x(1)-x(2))^2 + (x(2) - x(3))^4;


% x0 = [-2.6 ; 2 ; 2];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob6';

% f = @(x) (x(1) + x(2))^2 + (x(2) + x(3))^2;

% x0 = [-4;
%       1;
%       1];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob7';

% f = @(x) log1p(x(1)^2) + log1p((x(1) - x(2))^2) + log1p((x(2) - x(3))^2) + log1p((x(3) - x(4))^2);

% x0 = [2;
%       2;
%       2;
%       2];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob8';

% f = @(x) (x(1)*x(2)*x(3)*x(4))^2;

% x0 = [0.8;
%       0.8;
%       0.8;
%       0.8];


% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob9';

% f = @(x) (x(1)-1)^2 + (x(2)-2)^2 + (x(3)-3)^2 + (x(4)-4)^2;


% x0 = [1;
%       1;
%       1;
%       1];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob10';

% f = @(x) (x(1) - x(2))^2 + (x(2) - x(3))^2 + (x(3) - x(4))^4 + ...
%     (x(4) - x(5))^4;

% x0 = [2;
%       sqrt(2);
%       -1;
%       2-sqrt(2);
%       0.5];

% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% % ----------------------------------------------------------
% prob.pn = 'prob11';
% f = @(x) sum(2*x./(x.*x + 1));

% x0 = ones(4, 1);


% [x, fval] = trust_region_dbg({f}, x0,[],[],[],[],prob);

% ----------------------------------------------------------
print_soln_tail;
fclose(prob.fid);

% system(['cp ' data_file_src ' ' data_file_trg ])