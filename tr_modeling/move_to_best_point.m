function model = move_to_best_point(model, bl, bu, f, prob)
%MOVE_TO_BEST_POINT Changes TR center pointer to best point
%   bl, bu (optional) are lower and upper bounds on variables
%   f (optional) is a function for comparison of points. It receives a
%   vector with the function values of each point in the model and returns
%   a corresponding numeric value

    if nargin < 2
        bl = [];
    end
    if nargin < 3
        bu = [];
    end
    if nargin < 4 || isempty(f)
        f = [];
    end  


    best_i = find_best_point(model, bl, bu, f);
    part=26; subp=1; print_soln_body;


    if best_i ~= model.tr_center
        model.tr_center = best_i;
    end
    part=26; subp=2; print_soln_body;

    
    % Here should rebuild polynomials!!!
    

end

