function [x, fval] = snopt_minimize_quadratic(H0, g0, c0, x0, lb, ub)

    global H
    global g
    global c
    
    global concurrency_counter
    if isempty(concurrency_counter)
        concurrency_counter = true;
    else
        error('cmg:threadunsafe', 'Illegal concurrent invocation');
    end
    
    H = H0;
    g = g0;
    c = c0;
    
    opts = struct();
    opts.x  = x0;
    opts.xub = ub;
    opts.xlb = lb;

    % ----------------------------------------------------------
    opts = SNOPT_def_opt_options( opts );
    soln = SNOPT_solver_wrapper( opts );    
    
    clear global H
    clear global g
    clear global c
    clear global concurrency_counter
    
    x = soln.xstar;
    fval = soln.fstar;

end


% ==========================================================
function D = SNOPT_solver_wrapper(D)

[D.xstar, D.fstar, D.inform, D.xmul, D.Fmul] = ...
SNOPT(D.x, D.xlow, D.xupp, D.Flow, D.Fupp, 'quadratic_with_globals',...
D.ObjAdd, D.ObjRow, D.A, D.iAfun, D.jAvar, D.iGfun, D.jGvar);

end

% ==========================================================
function [x,F,inform,xmul,Fmul] = ...
SNOPT(x, xlow, xupp, Flow, Fupp, userfun, varargin)

m      = length( Flow );
n      = length( x );
xmul   = zeros(n, 1);
xstate = zeros(n, 1);
Fmul   = zeros(m, 1);
Fstate = zeros(m, 1);
ObjAdd = 0;
ObjRow = 1;

if nargin == 6
  
  [A, iAfun, jAvar, iGfun, jGvar] = ...
  snJac(userfun, x, xlow, xupp, m);
  % At this point, to supply derivatives, 
  % userfun must be modified.

  if (~isempty( A ))

      snset( 'Derivative option 0' );

  end

elseif nargin == 8
  
  [A, iAfun, jAvar, iGfun, jGvar] = ...
  snJac(userfun, x, xlow, xupp, m);
  %At this point, to supply derivatives, 
  % userfun must be modified.

  if ~isempty( A )

      snset( 'Derivative option 0' );

  end

  ObjAdd = varargin{ 1 };
  ObjRow = varargin{ 2 };

elseif nargin == 11
  
  A      = varargin{ 1 };
  iAfun  = varargin{ 2 };
  jAvar  = varargin{ 3 };
  iGfun  = varargin{ 4 };
  jGvar  = varargin{ 5 };

elseif ( nargin == 13 )
  
  ObjAdd = varargin{ 1 };
  ObjRow = varargin{ 2 };
  A      = varargin{ 3 };
  iAfun  = varargin{ 4 };
  jAvar  = varargin{ 5 };
  iGfun  = varargin{ 6 };
  jGvar  = varargin{ 7 };

end

solveopt = 1;

[x, F, xmul, Fmul, inform] = snoptcmex(solveopt, ...
x, xlow, xupp, xmul, xstate, Flow, Fupp, Fmul, Fstate, ...
ObjAdd, ObjRow, A, iAfun, jAvar, iGfun, jGvar, userfun);

end

% ==========================================================
function D = SNOPT_def_opt_options( D )

D.ObjRow = 1;
D.ObjAdd = 0;
% D.x      = D.x;

D.xlow   = D.xlb;
D.xupp   = D.xub;
D.xmul   = zeros(size( D.x )); %[20 x 1] column vector of zeros
D.xstate = zeros(size( D.x )); %[20 x 1] column vector of zeros
 
D.Flow   = -Inf; % lower bound objective function
D.Fupp   =  Inf; % upper bound objective function
D.Fmul   = 0;
D.Fstate = 0;
 
D.A      = [];
D.iAfun  = [];
D.jAvar  = [];
D.G      = [ones(size( D.x )) (1 : length( D.x ))'];
D.iGfun  = D.G(:, 1);
D.jGvar  = D.G(:, 2);

% ----------------------------------------------------------
% ----------------------------------------------------------
% SQP GENERAL | FUNCTION GENERAL
D.Function_precision           =  1e-6; %\epsilon_d, def=1e-13
D.Scale_option                 =  2;

% LINE SEARCH
D.Linesearch_tolerance         =  .90;  %def=.9, moderated tol 

% MAJOR FUNCTION EVAL
D.Major_iterations_limit       =  10;
D.Minor_iterations_limit       =  200;
D.Major_step_limit             =  2;    %def=2
D.Major_optimality_tolerance   =  1e-6; %\epsilon_d, def=1e-6
D.Major_feasibility_tolerance  =  1e-6; %\epsilon_r, def=1e-6

% MINOR FUNCTION EVAL
D.Minor_optimality_tolerance   =  1e-6; %\epsilon_d, def=1e-6
D.Minor_feasibility_tolerance  =  1e-6; %\epsilon_r, def=1e-6
D.Violation_limit              =  1e-6; %\epsilon_r, def=1e-6   

% ----------------------------------------------------------
% ----------------------------------------------------------
% SQP GENERAL | FUNCTION GENERAL
D.Opt_mode                     = { 'Minimize' 'Maximize' };
D.Opt_mode                     = D.Opt_mode{ 1 };
D.Sticky_parameters            = 'Sticky parameters no';
D.Derivative_option            =  1;
D.Verify_level                 =  -1;
D.Timing_level                 =  3;
D.Unbounded_objective_value    =  1e15; %def=1e+15
D.Unbounded_step_size          =  1e20; %def=1e+18
D.Difference_interval          =  1e-6; %\epsilon_d, def=1e-6
D.Central_difference_interval  =  1e-6; %\epsilon_d, def=
        
% SYSTEM | PRINT
D.System_information           = 'System information yes';
D.Solution_file                =  0;
D.Scale_print                  = 'Scale print';
D.Summary_frequency            =  100;
D.Print_frequency              =  100;
D.Minor_print_frequency        =  1;
D.Major_print_frequency        =  1;
D.Minor_print_level            =  10;
D.Major_print_level            =  10;

% LINE SEARCH
D.Line_search                  =  { 'Derivative linesearch' ...
                                    'Nonderivative linesearch' };
D.Line_search                  =  D.Line_search{ 2 };                                

% ----------------------------------------------------------
% ----------------------------------------------------------
% fprintf('\n_____________________\n')
% fprintf(  '___ SNOPT OPTIONS ___\n')

snset( D.Opt_mode           );
snset( D.Line_search        );
snset( D.Scale_print        );
snset( D.System_information );
snset( D.Sticky_parameters  );

snseti( 'Derivative option',      D.Derivative_option      );
snseti( 'Verify level',           D.Verify_level           );
snseti( 'Major iterations limit', D.Major_iterations_limit );
snseti( 'Minor iterations limit', D.Minor_iterations_limit );
snseti( 'Major step limit',       D.Major_step_limit);
snseti( 'Scale option',           D.Scale_option           );
snseti( 'Solution file',          D.Solution_file          );

snseti( 'Print frequency',        D.Print_frequency   );
snseti( 'Summary frequency',      D.Summary_frequency );
snseti( 'Minor print frequency',  D.Minor_print_frequency );
snseti( 'Major print frequency',  D.Major_print_frequency );
snseti( 'Minor print level',      D.Minor_print_level );
snseti( 'Major print level',      D.Major_print_level );
snseti( 'Timing level',           D.Timing_level      );

snsetr( 'Function precision',           D.Function_precision          );
snsetr( 'Major optimality tolerance',   D.Major_optimality_tolerance  );
snsetr( 'Minor optimality tolerance',   D.Minor_optimality_tolerance  );
snsetr( 'Major feasibility tolerance',  D.Major_feasibility_tolerance );
snsetr( 'Minor feasibility tolerance',  D.Minor_feasibility_tolerance );
snsetr( 'Violation limit',              D.Violation_limit             );
snsetr( 'Unbounded objective value',    D.Unbounded_objective_value   );
snsetr( 'Unbounded step size',          D.Unbounded_step_size         );
snsetr( 'Linesearch tolerance',         D.Linesearch_tolerance        );
snsetr( 'Difference interval',          D.Difference_interval         );
snsetr( 'Central difference interval',  D.Central_difference_interval );

snprintfile( 'snopt_prnt.out' )
% snsummary( 'snopt_smry.out' )

% ----------------------------------------------------------
% ----------------------------------------------------------
function snprintfile(filename)

  openprintfile  = 10;
  closeprintfile = 12;

  if strcmp( filename, 'off' )
    snoptcmex(closeprintfile );

  elseif strcmp(filename, 'on' )
    snoptcmex(openprintfile, 'print.out' );

  else
    snoptcmex(openprintfile, filename);

  end

end

% ----------------------------------------------------------
function snsummary(filename)

  opensummary  = 11;
  closesummary = 13;

  if strcmp( filename, 'off' )
    snoptcmex( closesummary );

  else
    snoptcmex( opensummary, filename );

  end
end

% ---------------------------------------------------------------
function snseti(option, ivalue) 

  setoption = 3;
  snoptcmex(setoption, option, ivalue);
    
end

% ---------------------------------------------------------------
function snsetr(option, rvalue)

  setoption = 4;
  snoptcmex(setoption, option, rvalue);
    
end

% ---------------------------------------------------------------
function snset(option)

  setoption = 2;
  snoptcmex(setoption, option);
    
end


end


% ----------------------------------------------------------
