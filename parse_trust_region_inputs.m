function options = parse_trust_region_inputs(options, default_options, prob)

options = options;

option_names = fieldnames(default_options);

for k = 1:length(option_names)
    if ~isfield(options, option_names{k})
        options.(option_names{k}) = default_options.(option_names{k});
    end
end

if options.tol_radius <= 0
    error('cmg:tol_radius', 'Option out of range: %s\n', 'tol_radius');
end
if options.eta_0 < 0 || options.eta_0 > options.eta_1
   error('cmg:eta_0', 'Option out of range: %s\n', 'eta_0'); 
end
if options.eta_1 == 0 || options.eta_1 > 1
   error('cmg:eta_1', 'Option out of range: %s\n', 'eta_1'); 
end
if options.gamma_dec <= 0 || options.gamma_dec >= 1
    error('cmg:gamma_dec', 'Option out of range: %s\n', 'gamma_dec');    
end
if options.gamma_inc <= 1
    error('cmg:gamma_inc', 'Option out of range: %s\n', 'gamma_inc');    
end
if options.eps_c <= 0
    error('cmg:eps_c', 'Option out of range: %s\n', 'eps_c');    
end
if options.criticality_mu <= options.criticality_beta
    error('cmg:criticality_mu', 'Option out of range: %s\n', ...
          'criticality_mu');    
end
if options.criticality_beta <= 0
    error('cmg:criticality_beta', 'Option out of range: %s\n', ...
          'criticality_beta');    
end
if options.criticality_omega <= 0 || options.criticality_omega >= 1
    error('cmg:criticality_omega', 'Option out of range: %s\n', ...
          'criticality_omega');    
end
if options.tol_f >= options.eps_c
    error('cmg:tol_f', 'Option out of range: %s\n', 'tol_f');    
end

prob.dbg_oconf_fid = fopen([prob.pn '/' prob.dbg_iters '-' prob.pn '-conf-MATLAB.tex'], 'w');
fprintf(prob.dbg_oconf_fid, '%s\n', '\begin{tabular}{lr}');

fprintf(prob.dbg_oconf_fid, 'tr parameter        & value \\\\ \\toprule \n');
% fprintf(prob.dbg_oconf_fid, "tr\\_prob\\_name:   & %s  \\\\ \n",   prob.pn);
fprintf(prob.dbg_oconf_fid, 'tr\\_init\\_rad:    & $% 10.3e $ \\\\ \n',   options.initial_radius);
fprintf(prob.dbg_oconf_fid, 'tr\\_tol\\_f:       & $% 10.3e $ \\\\ \n',   options.tol_f);
fprintf(prob.dbg_oconf_fid, 'tr\\_eps\\_c:       & $% 10.3e $ \\\\ \n',   options.eps_c);
fprintf(prob.dbg_oconf_fid, 'tr\\_eta\\_0:       & $% 10.3e $ \\\\ \n',   options.eta_0);
fprintf(prob.dbg_oconf_fid, 'tr\\_eta\\_1:       & $% 10.3e $ \\\\ \\midrule \n',   options.eta_1);
fprintf(prob.dbg_oconf_fid, 'tr\\_piv\\_thresh:  & $% 10.3e $ \\\\ \n',   options.pivot_threshold);
fprintf(prob.dbg_oconf_fid, 'tr\\_add\\_thresh:  & $% 10.3e $ \\\\ \n',   options.add_threshold);
fprintf(prob.dbg_oconf_fid, 'tr\\_exch\\_thresh: & $% 10.3e $ \\\\ \n',   options.exchange_threshold);
fprintf(prob.dbg_oconf_fid, 'tr\\_rad\\_max:     & $% 10.3e $ \\\\ \n',   options.radius_max);
fprintf(prob.dbg_oconf_fid, 'tr\\_rad\\_factor:  & $% 10.3e $ \\\\ \\midrule \n',   options.radius_factor);
fprintf(prob.dbg_oconf_fid, 'tr\\_tol\\_rad:     & $% 10.3e $ \\\\ \n',   options.tol_radius);
fprintf(prob.dbg_oconf_fid, 'tr\\_gamma\\_inc:   & $% 10.3e $ \\\\ \n',   options.gamma_inc);
fprintf(prob.dbg_oconf_fid, 'tr\\_gamma\\_dec:   & $% 10.3e $ \\\\ \n',   options.gamma_dec);
fprintf(prob.dbg_oconf_fid, 'tr\\_crit\\_mu:     & $% 10.3e $ \\\\ \n',   options.criticality_mu);
fprintf(prob.dbg_oconf_fid, 'tr\\_crit\\_omega:  & $% 10.3e $ \\\\ \\midrule \n',   options.criticality_omega);
fprintf(prob.dbg_oconf_fid, 'tr\\_crit\\_beta:   & $% 10.3e $ \\\\ \n',   options.criticality_beta);
fprintf(prob.dbg_oconf_fid, 'tr\\_lower\\_b:     & $% 10.3e $ \\\\ \n',   prob.bl);
fprintf(prob.dbg_oconf_fid, 'tr\\_upper\\_b:     & $% 10.3e $ \\\\ \\bottomrule', prob.bu);

fprintf(prob.dbg_oconf_fid, '\n%s\n', '\end{tabular}');
fclose(prob.dbg_oconf_fid);

end