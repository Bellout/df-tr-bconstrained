% set_filenames.m
function [ prob ] = set_filenames(prob)

tag = '_cgmat';
pdir = [ prob.dbg_file_src '/' prob.pn ];

CN = '_TRMod_';

% --------------------------------------------------------------------
fn = [ prob.pn CN '_moveToBestPoint' tag '.txt' ];
prob.fid_moveToBestPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_moveToBestPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_measureCriticality' tag '.txt' ];
prob.fid_measureCriticality = fopen([ pdir '/' fn ], 'w');
prob.trg_measureCriticality = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_getModelMatrices' tag '.txt' ];
prob.fid_getModelMatrices = fopen([ pdir '/' fn ], 'w');
prob.trg_getModelMatrices = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_criticalityStep' tag '.txt' ];
prob.fid_criticalityStep = fopen([ pdir '/' fn ], 'w');
prob.trg_criticalityStep = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 11, 12, 13
fn = [ prob.pn CN '_checkInterpolation' tag '.txt' ];
prob.fid_checkInterpolation = fopen([ pdir '/' fn ], 'w');
prob.trg_checkInterpolation = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_submitTempInitCases' tag '.txt' ];
prob.fid_submitTempInitCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempInitCases = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_submitTempImprCases' tag '.txt' ];
prob.fid_submitTempImprCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempImprCases = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_setUpTempAllPoints' tag '.txt' ];
prob.fid_setUpTempAllPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_setUpTempAllPoints = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_rowPivotGaussianElimination' tag '.txt' ];
prob.fid_rowPivotGaussianElimination = fopen([ pdir '/' fn ], 'w');
prob.trg_rowPivotGaussianElimination = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 15, 16, 17
fn = [ prob.pn CN '_reCenterPoints' tag '.txt' ];
prob.fid_reCenterPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_reCenterPoints = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_rebuildModel' tag '.txt' ];
prob.fid_rebuildModel = fopen([ pdir '/' fn ], 'w');
prob.trg_rebuildModel = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 10
fn = [ prob.pn CN '_improveModelNfp' tag '.txt' ];
prob.fid_improveModelNfp = fopen([ pdir '/' fn ], 'w');
prob.trg_improveModelNfp = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_ensureImprovement' tag '.txt' ];
prob.fid_ensureImprovement = fopen([ pdir '/' fn ], 'w');
prob.trg_ensureImprovement = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_isLambdaPoised' tag '.txt' ];
prob.fid_isLambdaPoised = fopen([ pdir '/' fn ], 'w');
prob.trg_isLambdaPoised = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_changeTrCenter' tag '.txt' ];
prob.fid_changeTrCenter = fopen([ pdir '/' fn ], 'w');
prob.trg_changeTrCenter = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 14
fn = [ prob.pn CN '_solveTrSubproblem' tag '.txt' ];
prob.fid_solveTrSubproblem = fopen([ pdir '/' fn ], 'w');
prob.trg_solveTrSubproblem = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_computePolynomialModels' tag '.txt' ];
prob.fid_computePolynomialModels = fopen([ pdir '/' fn ], 'w');
prob.trg_computePolynomialModels = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_shiftPolynomialToEndBlock' tag '.txt' ];
prob.fid_shiftPolynomialToEndBlock = fopen([ pdir '/' fn ], 'w');
prob.trg_shiftPolynomialToEndBlock = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_normalizePolynomial' tag '.txt' ];
prob.fid_normalizePolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_normalizePolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_orthogonalizeToOtherPolynomials' tag '.txt' ];
prob.fid_orthogonalizeToOtherPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_orthogonalizeToOtherPolynomials = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_orthogonalizeBlock' tag '.txt' ];
prob.fid_orthogonalizeBlock = fopen([ pdir '/' fn ], 'w');
prob.trg_orthogonalizeBlock = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_zeroAtPoint' tag '.txt' ];
prob.fid_zeroAtPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_zeroAtPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_evaluatePolynomial' tag '.txt' ];
prob.fid_evaluatePolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_evaluatePolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_addPolynomial' tag '.txt' ];
prob.fid_addPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_addPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_multiplyPolynomial' tag '.txt' ];
prob.fid_multiplyPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_multiplyPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_findBestPoint' tag '.txt' ];
prob.fid_findBestPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_findBestPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_computeQuadraticMNPolynomials' tag '.txt' ];
prob.fid_computeQuadraticMNPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_computeQuadraticMNPolynomials = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_nfpFiniteDifferences' tag '.txt' ];
prob.fid_nfpFiniteDifferences = fopen([ pdir '/' fn ], 'w');
prob.trg_nfpFiniteDifferences = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_combinePolynomials' tag '.txt' ];
prob.fid_combinePolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_combinePolynomials = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_shiftPolynomial' tag '.txt' ];
prob.fid_shiftPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_shiftPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_isComplete' tag '.txt' ];
prob.fid_isComplete = fopen([ pdir '/' fn ], 'w');
prob.trg_isComplete = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_isOld' tag '.txt' ];
prob.fid_isOld = fopen([ pdir '/' fn ], 'w');
prob.trg_isOld = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_chooseAndReplacePoint' tag '.txt' ];
prob.fid_chooseAndReplacePoint = fopen([ pdir '/' fn ], 'w');
prob.trg_chooseAndReplacePoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_pointNew' tag '.txt' ];
prob.fid_pointNew = fopen([ pdir '/' fn ], 'w');
prob.trg_pointNew = [ pdir '/' fn ];

% -------------------------------------------------------------------- case 8
fn = [ prob.pn CN '_minimizeTr' tag '.txt' ];
prob.fid_minimizeTr = fopen([ pdir '/' fn ], 'w');
prob.trg_minimizeTr = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_tryToAddPoint' tag '.txt' ];
prob.fid_tryToAddPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_tryToAddPoint = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_addPoint' tag '.txt' ];
prob.fid_addPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_addPoint = [ pdir '/' fn ];

% MATH
% --------------------------------------------------------------------
fn = [ prob.pn CN '_sortVectorByIndex' tag '.txt' ];
prob.fid_sortVectorByIndex = fopen([ pdir '/' fn ], 'w');
prob.trg_sortVectorByIndex = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_sortVectorByIndexRow' tag '.txt' ];
prob.fid_sortVectorByIndexRow = fopen([ pdir '/' fn ], 'w');
prob.trg_sortVectorByIndexRow = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_sortMatrixByIndex' tag '.txt' ];
prob.fid_sortMatrixByIndex = fopen([ pdir '/' fn ], 'w');
prob.trg_sortMatrixByIndex = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_nfpBasis' tag '.txt' ];
prob.fid_nfpBasis = fopen([ pdir '/' fn ], 'w');
prob.trg_nfpBasis = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_matricesToPolynomial' tag '.txt' ];
prob.fid_matricesToPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_matricesToPolynomial = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_coefficientsToMatrices' tag '.txt' ];
prob.fid_coefficientsToMatrices = fopen([ pdir '/' fn ], 'w');
prob.trg_coefficientsToMatrices = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_TrustRegionModel' tag '.txt' ];
prob.fid_TrustRegionModel = fopen([ pdir '/' fn ], 'w');
prob.trg_TrustRegionModel = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_addInitializationCase' tag '.txt' ];
prob.fid_addInitializationCase = fopen([ pdir '/' fn ], 'w');
prob.trg_addInitializationCase = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_areInitPointsComputed' tag '.txt' ];
prob.fid_areInitPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_areInitPointsComputed = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_isInitialized' tag '.txt' ];
prob.fid_isInitialized = fopen([ pdir '/' fn ], 'w');
prob.trg_isInitialized = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_getInitializationCases' tag '.txt' ];
prob.fid_getInitializationCases = fopen([ pdir '/' fn ], 'w');
prob.trg_getInitializationCases = [ pdir '/' fn ];



% SOLVER


% ====================================================================

CN = '_TROpt_';

% --------------------------------------------------------------------
fn = [ prob.pn CN '_TrustRegionOptimization' tag '.txt' ];
prob.fid_TrustRegionOptimization = fopen([ pdir '/' fn ], 'w');
prob.trg_TrustRegionOptimization = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_iterate' tag '.txt' ];
prob.fid_iterate = fopen([ pdir '/' fn ], 'w');
prob.trg_iterate = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_handleEvaluatedCase' tag '.txt' ];
prob.fid_handleEvaluatedCase = fopen([ pdir '/' fn ], 'w');
prob.trg_handleEvaluatedCase = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_updateRadius' tag '.txt' ];
prob.fid_updateRadius = fopen([ pdir '/' fn ], 'w');
prob.trg_updateRadius = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_computeInitialPoints' tag '.txt' ];
prob.fid_computeInitialPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_computeInitialPoints = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_setLowerUpperBounds' tag '.txt' ];
prob.fid_setLowerUpperBounds = fopen([ pdir '/' fn ], 'w');
prob.trg_setLowerUpperBounds = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_IsFinished' tag '.txt' ];
prob.fid_IsFinished = fopen([ pdir '/' fn ], 'w');
prob.trg_IsFinished = [ pdir '/' fn ];

% --------------------------------------------------------------------
fn = [ prob.pn CN '_projectToBounds' tag '.txt' ];
prob.fid_projectToBounds = fopen([ pdir '/' fn ], 'w');
prob.trg_projectToBounds = [ pdir '/' fn ];



end