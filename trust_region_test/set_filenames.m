% set_filenames.m
function [ prob ] = set_filenames(prob)

tag = '_cgmat';

% --------------------------------------------------------------------
fn = [ prob.pn '_moveToBestPoint' tag '.txt' ];
prob.fid_moveToBestPoint = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_moveToBestPoint = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_measureCriticality' tag '.txt' ];
prob.fid_measureCriticality = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_measureCriticality = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_criticalityStep' tag '.txt' ];
prob.fid_criticalityStep = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_criticalityStep = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_checkInterpolation' tag '.txt' ];
prob.fid_checkInterpolation = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_checkInterpolation = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_submitTempInitCases' tag '.txt' ];
prob.fid_submitTempInitCases = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_submitTempInitCases = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_submitTempImprCases' tag '.txt' ];
prob.fid_submitTempImprCases = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_submitTempImprCases = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_setUpTempAllPoints' tag '.txt' ];
prob.fid_setUpTempAllPoints = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_setUpTempAllPoints = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_reCenterPoints' tag '.txt' ];
prob.fid_reCenterPoints = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_reCenterPoints = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_setUpTempAllPoints' tag '.txt' ];
prob.fid_setUpTempAllPoints = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_setUpTempAllPoints = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_rowPivotGaussianElimination' tag '.txt' ];
prob.fid_rowPivotGaussianElimination = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_rowPivotGaussianElimination = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_rebuildModel' tag '.txt' ];
prob.fid_rebuildModel = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_rebuildModel = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_improveModelNfp' tag '.txt' ];
prob.fid_improveModelNfp = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_improveModelNfp = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_ensureImprovement' tag '.txt' ];
prob.fid_ensureImprovement = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_ensureImprovement = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_isLambdaPoised' tag '.txt' ];
prob.fid_isLambdaPoised = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_isLambdaPoised = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_changeTrCenter' tag '.txt' ];
prob.fid_changeTrCenter = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_changeTrCenter = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_solveTrSubproblem' tag '.txt' ];
prob.fid_solveTrSubproblem = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_solveTrSubproblem = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_computePolynomialModels' tag '.txt' ];
prob.fid_computePolynomialModels = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_computePolynomialModels = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_shiftPolynomialToEndBlock' tag '.txt' ];
prob.fid_shiftPolynomialToEndBlock = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_shiftPolynomialToEndBlock = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_normalizePolynomial' tag '.txt' ];
prob.fid_normalizePolynomial = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_normalizePolynomial = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_orthogonalizeToOtherPolynomials' tag '.txt' ];
prob.fid_orthogonalizeToOtherPolynomials = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_orthogonalizeToOtherPolynomials = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_orthogonalizeBlock' tag '.txt' ];
prob.fid_orthogonalizeBlock = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_orthogonalizeBlock = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_zeroAtPoint' tag '.txt' ];
prob.fid_zeroAtPoint = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_zeroAtPoint = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_evaluatePolynomial' tag '.txt' ];
prob.fid_evaluatePolynomial = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_evaluatePolynomial = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_addPolynomial' tag '.txt' ];
prob.fid_addPolynomial = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_addPolynomial = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_multiplyPolynomial' tag '.txt' ];
prob.fid_multiplyPolynomial = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_multiplyPolynomial = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_findBestPoint' tag '.txt' ];
prob.fid_findBestPoint = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_findBestPoint = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_computeQuadraticMNPolynomials' tag '.txt' ];
prob.fid_computeQuadraticMNPolynomials = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_computeQuadraticMNPolynomials = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_nfpFiniteDifferences' tag '.txt' ];
prob.fid_nfpFiniteDifferences = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_nfpFiniteDifferences = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_combinePolynomials' tag '.txt' ];
prob.fid_combinePolynomials = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_combinePolynomials = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_shiftPolynomial' tag '.txt' ];
prob.fid_shiftPolynomial = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_shiftPolynomial = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_isComplete' tag '.txt' ];
prob.fid_isComplete = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_isComplete = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_isOld' tag '.txt' ];
prob.fid_isOld = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_isOld = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_chooseAndReplacePoint' tag '.txt' ];
prob.fid_chooseAndReplacePoint = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_chooseAndReplacePoint = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_pointNew' tag '.txt' ];
prob.fid_pointNew = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_pointNew = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_minimizeTr' tag '.txt' ];
prob.fid_minimizeTr = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_minimizeTr = [ prob.dbg_file_src '/' fn ];


% MATH
% --------------------------------------------------------------------
fn = [ prob.pn '_sortVectorByIndex' tag '.txt' ];
prob.fid_sortVectorByIndex = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_sortVectorByIndex = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_sortVectorByIndexRow' tag '.txt' ];
prob.fid_sortVectorByIndexRow = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_sortVectorByIndexRow = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_sortMatrixByIndex' tag '.txt' ];
prob.fid_sortMatrixByIndex = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_sortMatrixByIndex = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_nfpBasis' tag '.txt' ];
prob.fid_nfpBasis = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_nfpBasis = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_matricesToPolynomial' tag '.txt' ];
prob.fid_matricesToPolynomial = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_matricesToPolynomial = [ prob.dbg_file_src '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn '_coefficientsToMatrices' tag '.txt' ];
prob.fid_coefficientsToMatrices = fopen([ prob.dbg_file_src '/' fn ], 'w');
prob.trg_coefficientsToMatrices = [ prob.dbg_file_src '/' fn ];

% SOLVER




end