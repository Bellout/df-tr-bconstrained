% set_filenames.m
function [ prob ] = set_filenames(prob)

tag = '_cgmat';
pdir = [ prob.dbg_file_src '/' prob.pn ];
% --------------------------------------------------------------------
fn = [ prob.pn '_moveToBestPoint' tag '.txt' ];
prob.fid_moveToBestPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_moveToBestPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_measureCriticality' tag '.txt' ];
prob.fid_measureCriticality = fopen([ pdir '/' fn ], 'w');
prob.trg_measureCriticality = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_getModelMatrices' tag '.txt' ];
prob.fid_getModelMatrices = fopen([ pdir '/' fn ], 'w');
prob.trg_getModelMatrices = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_criticalityStep' tag '.txt' ];
prob.fid_criticalityStep = fopen([ pdir '/' fn ], 'w');
prob.trg_criticalityStep = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 11, 12, 13
fn = [ prob.pn '_checkInterpolation' tag '.txt' ];
prob.fid_checkInterpolation = fopen([ pdir '/' fn ], 'w');
prob.trg_checkInterpolation = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_submitTempInitCases' tag '.txt' ];
prob.fid_submitTempInitCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempInitCases = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_submitTempImprCases' tag '.txt' ];
prob.fid_submitTempImprCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempImprCases = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_setUpTempAllPoints' tag '.txt' ];
prob.fid_setUpTempAllPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_setUpTempAllPoints = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_rowPivotGaussianElimination' tag '.txt' ];
prob.fid_rowPivotGaussianElimination = fopen([ pdir '/' fn ], 'w');
prob.trg_rowPivotGaussianElimination = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 15, 16, 17
fn = [ prob.pn '_reCenterPoints' tag '.txt' ];
prob.fid_reCenterPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_reCenterPoints = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_rebuildModel' tag '.txt' ];
prob.fid_rebuildModel = fopen([ pdir '/' fn ], 'w');
prob.trg_rebuildModel = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 10
fn = [ prob.pn '_improveModelNfp' tag '.txt' ];
prob.fid_improveModelNfp = fopen([ pdir '/' fn ], 'w');
prob.trg_improveModelNfp = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_ensureImprovement' tag '.txt' ];
prob.fid_ensureImprovement = fopen([ pdir '/' fn ], 'w');
prob.trg_ensureImprovement = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_isLambdaPoised' tag '.txt' ];
prob.fid_isLambdaPoised = fopen([ pdir '/' fn ], 'w');
prob.trg_isLambdaPoised = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_changeTrCenter' tag '.txt' ];
prob.fid_changeTrCenter = fopen([ pdir '/' fn ], 'w');
prob.trg_changeTrCenter = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 14
fn = [ prob.pn '_solveTrSubproblem' tag '.txt' ];
prob.fid_solveTrSubproblem = fopen([ pdir '/' fn ], 'w');
prob.trg_solveTrSubproblem = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_computePolynomialModels' tag '.txt' ];
prob.fid_computePolynomialModels = fopen([ pdir '/' fn ], 'w');
prob.trg_computePolynomialModels = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_shiftPolynomialToEndBlock' tag '.txt' ];
prob.fid_shiftPolynomialToEndBlock = fopen([ pdir '/' fn ], 'w');
prob.trg_shiftPolynomialToEndBlock = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_normalizePolynomial' tag '.txt' ];
prob.fid_normalizePolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_normalizePolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_orthogonalizeToOtherPolynomials' tag '.txt' ];
prob.fid_orthogonalizeToOtherPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_orthogonalizeToOtherPolynomials = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_orthogonalizeBlock' tag '.txt' ];
prob.fid_orthogonalizeBlock = fopen([ pdir '/' fn ], 'w');
prob.trg_orthogonalizeBlock = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_zeroAtPoint' tag '.txt' ];
prob.fid_zeroAtPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_zeroAtPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_evaluatePolynomial' tag '.txt' ];
prob.fid_evaluatePolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_evaluatePolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_addPolynomial' tag '.txt' ];
prob.fid_addPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_addPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_multiplyPolynomial' tag '.txt' ];
prob.fid_multiplyPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_multiplyPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_findBestPoint' tag '.txt' ];
prob.fid_findBestPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_findBestPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_computeQuadraticMNPolynomials' tag '.txt' ];
prob.fid_computeQuadraticMNPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_computeQuadraticMNPolynomials = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_nfpFiniteDifferences' tag '.txt' ];
prob.fid_nfpFiniteDifferences = fopen([ pdir '/' fn ], 'w');
prob.trg_nfpFiniteDifferences = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_combinePolynomials' tag '.txt' ];
prob.fid_combinePolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_combinePolynomials = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_shiftPolynomial' tag '.txt' ];
prob.fid_shiftPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_shiftPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_isComplete' tag '.txt' ];
prob.fid_isComplete = fopen([ pdir '/' fn ], 'w');
prob.trg_isComplete = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_isOld' tag '.txt' ];
prob.fid_isOld = fopen([ pdir '/' fn ], 'w');
prob.trg_isOld = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_chooseAndReplacePoint' tag '.txt' ];
prob.fid_chooseAndReplacePoint = fopen([ pdir '/' fn ], 'w');
prob.trg_chooseAndReplacePoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_pointNew' tag '.txt' ];
prob.fid_pointNew = fopen([ pdir '/' fn ], 'w');
prob.trg_pointNew = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 8
fn = [ prob.pn '_minimizeTr' tag '.txt' ];
prob.fid_minimizeTr = fopen([ pdir '/' fn ], 'w');
prob.trg_minimizeTr = [ pdir '/' fn ];


% MATH
% --------------------------------------------------------------------
fn = [ prob.pn '_sortVectorByIndex' tag '.txt' ];
prob.fid_sortVectorByIndex = fopen([ pdir '/' fn ], 'w');
prob.trg_sortVectorByIndex = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_sortVectorByIndexRow' tag '.txt' ];
prob.fid_sortVectorByIndexRow = fopen([ pdir '/' fn ], 'w');
prob.trg_sortVectorByIndexRow = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_sortMatrixByIndex' tag '.txt' ];
prob.fid_sortMatrixByIndex = fopen([ pdir '/' fn ], 'w');
prob.trg_sortMatrixByIndex = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_nfpBasis' tag '.txt' ];
prob.fid_nfpBasis = fopen([ pdir '/' fn ], 'w');
prob.trg_nfpBasis = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_matricesToPolynomial' tag '.txt' ];
prob.fid_matricesToPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_matricesToPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_coefficientsToMatrices' tag '.txt' ];
prob.fid_coefficientsToMatrices = fopen([ pdir '/' fn ], 'w');
prob.trg_coefficientsToMatrices = [ pdir '/' fn ];

% SOLVER




end