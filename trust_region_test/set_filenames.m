% set_filenames.m
function [ prob ] = set_filenames(prob)

tag = '_cgmat';
pdir = [ prob.dbg_file_src '/' prob.pn ];




% ====================================================================
% MODEL
CN = 'TRMod';

% -------------------------------------------------------------------- 2
fn = [ prob.pn '_0002_' CN '_TrustRegionModel' tag '.txt' ];
prob.fid_TrustRegionModel = fopen([ pdir '/' fn ], 'w');
prob.trg_TrustRegionModel = [ pdir '/' fn ];

% -------------------------------------------------------------------- 3
fn = [ prob.pn '_0003_' CN '_areInitPointsComputed' tag '.txt' ];
prob.fid_areInitPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_areInitPointsComputed = [ pdir '/' fn ];

% -------------------------------------------------------------------- 4
fn = [ prob.pn '_0004_' CN '_areImprPointsComputed' tag '.txt' ];
prob.fid_areImprPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_areImprPointsComputed = [ pdir '/' fn ];

% -------------------------------------------------------------------- 5
fn = [ prob.pn '_0005_' CN '_areReplPointsComputed' tag '.txt' ];
prob.fid_areReplacementPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_areReplacementPointsComputed = [ pdir '/' fn ];

% -------------------------------------------------------------------- 6
fn = [ prob.pn '_0006_' CN '_isInitialized' tag '.txt' ];
prob.fid_isInitialized = fopen([ pdir '/' fn ], 'w');
prob.trg_isInitialized = [ pdir '/' fn ];

% -------------------------------------------------------------------- 7
fn = [ prob.pn '_0007_' CN '_isImprovementNeeded' tag '.txt' ];
prob.fid_isImprovementNeeded = fopen([ pdir '/' fn ], 'w');
prob.trg_isImprovementNeeded = [ pdir '/' fn ];

% -------------------------------------------------------------------- 8
fn = [ prob.pn '_0008_' CN '_isReplacementNeeded' tag '.txt' ];
prob.fid_isReplacementNeeded = fopen([ pdir '/' fn ], 'w');
prob.trg_isReplacementNeeded = [ pdir '/' fn ];

% -------------------------------------------------------------------- 9
fn = [ prob.pn '_0009_' CN '_hasModelChanged' tag '.txt' ];
prob.fid_hasModelChanged = fopen([ pdir '/' fn ], 'w');
prob.trg_hasModelChanged = [ pdir '/' fn ];

% -------------------------------------------------------------------- 12
fn = [ prob.pn '_0012_' CN '_rebuildModel' tag '.txt' ];
prob.fid_rebuildModel = fopen([ pdir '/' fn ], 'w');
prob.trg_rebuildModel = [ pdir '/' fn ];

% -------------------------------------------------------------------- 13
fn = [ prob.pn '_0013_' CN '_setUpTempAllPoints' tag '.txt' ];
prob.fid_setUpTempAllPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_setUpTempAllPoints = [ pdir '/' fn ];

% -------------------------------------------------------------------- 14
fn = [ prob.pn '_0014_' CN '_reCenterPoints' tag '.txt' ];
prob.fid_reCenterPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_reCenterPoints = [ pdir '/' fn ];

% -------------------------------------------------------------------- 15
fn = [ prob.pn '_0015_' CN '_nfpBasis' tag '.txt' ];
prob.fid_nfpBasis = fopen([ pdir '/' fn ], 'w');
prob.trg_nfpBasis = [ pdir '/' fn ];

% -------------------------------------------------------------------- 16
fn = [ prob.pn '_0016_' CN '_rowPivotGaussianElimination' tag '.txt' ];
prob.fid_rowPivotGaussianElimination = fopen([ pdir '/' fn ], 'w');
prob.trg_rowPivotGaussianElimination = [ pdir '/' fn ];

% -------------------------------------------------------------------- 17
fn = [ prob.pn '_0017_' CN '_getRadius' tag '.txt' ];
prob.fid_getRadius = fopen([ pdir '/' fn ], 'w');
prob.trg_getRadius = [ pdir '/' fn ];

% -------------------------------------------------------------------- 18
fn = [ prob.pn '_0018_' CN '_isLambdaPoised' tag '.txt' ];
prob.fid_isLambdaPoised = fopen([ pdir '/' fn ], 'w');
prob.trg_isLambdaPoised = [ pdir '/' fn ];

% -------------------------------------------------------------------- 19
fn = [ prob.pn '_0019_' CN '_moveToBestPoint' tag '.txt' ];
prob.fid_moveToBestPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_moveToBestPoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 20
fn = [ prob.pn '_0020_' CN '_findBestPoint' tag '.txt' ];
prob.fid_findBestPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_findBestPoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 21
fn = [ prob.pn '_0021_' CN '_computePolynomialModels' tag '.txt' ];
prob.fid_computePolynomialModels = fopen([ pdir '/' fn ], 'w');
prob.trg_computePolynomialModels = [ pdir '/' fn ];

% -------------------------------------------------------------------- 22
fn = [ prob.pn '_0022_' CN '_computeQuadraticMNPolynomials' tag '.txt' ];
prob.fid_computeQuadraticMNPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_computeQuadraticMNPolynomials = [ pdir '/' fn ];

% -------------------------------------------------------------------- 23
fn = [ prob.pn '_0023_' CN '_matricesToPolynomial' tag '.txt' ];
prob.fid_matricesToPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_matricesToPolynomial = [ pdir '/' fn ];

% -------------------------------------------------------------------- 24
fn = [ prob.pn '_0024_' CN '_nfpFiniteDifferences' tag '.txt' ];
prob.fid_nfpFiniteDifferences = fopen([ pdir '/' fn ], 'w');
prob.trg_nfpFiniteDifferences = [ pdir '/' fn ];

% -------------------------------------------------------------------- 25
fn = [ prob.pn '_0025_' CN '_evaluatePolynomial' tag '.txt' ];
prob.fid_evaluatePolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_evaluatePolynomial = [ pdir '/' fn ];

% -------------------------------------------------------------------- 26
fn = [ prob.pn '_0026_' CN '_coefficientsToMatrices' tag '.txt' ];
prob.fid_coefficientsToMatrices = fopen([ pdir '/' fn ], 'w');
prob.trg_coefficientsToMatrices = [ pdir '/' fn ];

% -------------------------------------------------------------------- 27
fn = [ prob.pn '_0027_' CN '_combinePolynomials' tag '.txt' ];
prob.fid_combinePolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_combinePolynomials = [ pdir '/' fn ];

% -------------------------------------------------------------------- 28
fn = [ prob.pn '_0028_' CN '_multiplyPolynomial' tag '.txt' ];
prob.fid_multiplyPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_multiplyPolynomial = [ pdir '/' fn ];

% -------------------------------------------------------------------- 29
fn = [ prob.pn '_0029_' CN '_addPolynomial' tag '.txt' ];
prob.fid_addPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_addPolynomial = [ pdir '/' fn ];

% -------------------------------------------------------------------- 30
fn = [ prob.pn '_0030_' CN '_shiftPolynomial' tag '.txt' ];
prob.fid_shiftPolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_shiftPolynomial = [ pdir '/' fn ];

% -------------------------------------------------------------------- 31
fn = [ prob.pn '_0031_' CN '_checkInterpolation' tag '.txt' ];
prob.fid_checkInterpolation = fopen([ pdir '/' fn ], 'w');
prob.trg_checkInterpolation = [ pdir '/' fn ];

% -------------------------------------------------------------------- 32
fn = [ prob.pn '_0032_' CN '_getModelingPolynomials' tag '.txt' ];
prob.fid_getModelingPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_getModelingPolynomials = [ pdir '/' fn ];

% -------------------------------------------------------------------- 33
fn = [ prob.pn '_0033_' CN '_measureCriticality' tag '.txt' ];
prob.fid_measureCriticality = fopen([ pdir '/' fn ], 'w');
prob.trg_measureCriticality = [ pdir '/' fn ];

% -------------------------------------------------------------------- 34
fn = [ prob.pn '_0034_' CN '_getModelMatrices' tag '.txt' ];
prob.fid_getModelMatrices = fopen([ pdir '/' fn ], 'w');
prob.trg_getModelMatrices = [ pdir '/' fn ];

% -------------------------------------------------------------------- 35
fn = [ prob.pn '_0035_' CN '_criticalityStep' tag '.txt' ];
prob.fid_criticalityStep = fopen([ pdir '/' fn ], 'w');
prob.trg_criticalityStep = [ pdir '/' fn ];

% -------------------------------------------------------------------- 36
fn = [ prob.pn '_0036_' CN '_isOld' tag '.txt' ];
prob.fid_isOld = fopen([ pdir '/' fn ], 'w');
prob.trg_isOld = [ pdir '/' fn ];

% -------------------------------------------------------------------- 37
fn = [ prob.pn '_0037_' CN '_ensureImprovement' tag '.txt' ];
prob.fid_ensureImprovement = fopen([ pdir '/' fn ], 'w');
prob.trg_ensureImprovement = [ pdir '/' fn ];

% -------------------------------------------------------------------- 38
fn = [ prob.pn '_0038_' CN '_isComplete' tag '.txt' ];
prob.fid_isComplete = fopen([ pdir '/' fn ], 'w');
prob.trg_isComplete = [ pdir '/' fn ];

% -------------------------------------------------------------------- 39
fn = [ prob.pn '_0039_' CN '_improveModelNfp' tag '.txt' ];
prob.fid_improveModelNfp = fopen([ pdir '/' fn ], 'w');
prob.trg_improveModelNfp = [ pdir '/' fn ];

% -------------------------------------------------------------------- 40
fn = [ prob.pn '_0040_' CN '_chooseAndReplacePoint' tag '.txt' ];
prob.fid_chooseAndReplacePoint = fopen([ pdir '/' fn ], 'w');
prob.trg_chooseAndReplacePoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 41
fn = [ prob.pn '_0041_' CN '_solveTrSubproblem' tag '.txt' ];
prob.fid_solveTrSubproblem = fopen([ pdir '/' fn ], 'w');
prob.trg_solveTrSubproblem = [ pdir '/' fn ];

% -------------------------------------------------------------------- 42
fn = [ prob.pn '_0042_' CN '_minimizeTr' tag '.txt' ];
prob.fid_minimizeTr = fopen([ pdir '/' fn ], 'w');
prob.trg_minimizeTr = [ pdir '/' fn ];

% -------------------------------------------------------------------- 43
fn = [ prob.pn '_0043_' CN '_getImprovementCases' tag '.txt' ];
prob.fid_getImprovementCases = fopen([ pdir '/' fn ], 'w');
prob.trg_getImprovementCases = [ pdir '/' fn ];

% -------------------------------------------------------------------- 44
fn = [ prob.pn '_0044_' CN '_getReplacementCases' tag '.txt' ];
prob.fid_getReplacementCases = fopen([ pdir '/' fn ], 'w');
prob.trg_getReplacementCases = [ pdir '/' fn ];

% -------------------------------------------------------------------- 57
fn = [ prob.pn '_0057_' CN '_changeTrCenter' tag '.txt' ];
prob.fid_changeTrCenter = fopen([ pdir '/' fn ], 'w');
prob.trg_changeTrCenter = [ pdir '/' fn ];

% -------------------------------------------------------------------- 58
fn = [ prob.pn '_0058_' CN '_addPoint' tag '.txt' ];
prob.fid_addPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_addPoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 59
fn = [ prob.pn '_0059_' CN '_exchangePoint' tag '.txt' ];
prob.fid_exchangePoint = fopen([ pdir '/' fn ], 'w');
prob.trg_exchangePoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 60
fn = [ prob.pn '_0060_' CN '_normalizePolynomial' tag '.txt' ];
prob.fid_normalizePolynomial = fopen([ pdir '/' fn ], 'w');
prob.trg_normalizePolynomial = [ pdir '/' fn ];

% -------------------------------------------------------------------- 61
fn = [ prob.pn '_0061_' CN '_orthogonalizeToOtherPolynomials' tag '.txt' ];
prob.fid_orthogonalizeToOtherPolynomials = fopen([ pdir '/' fn ], 'w');
prob.trg_orthogonalizeToOtherPolynomials = [ pdir '/' fn ];

% -------------------------------------------------------------------- 62
fn = [ prob.pn '_0062_' CN '_zeroAtPoint' tag '.txt' ];
prob.fid_zeroAtPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_zeroAtPoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 63
fn = [ prob.pn '_0063_' CN '_orthogonalizeBlock' tag '.txt' ];
prob.fid_orthogonalizeBlock = fopen([ pdir '/' fn ], 'w');
prob.trg_orthogonalizeBlock = [ pdir '/' fn ];

% -------------------------------------------------------------------- 64
fn = [ prob.pn '_0064_' CN '_pointNew' tag '.txt' ];
prob.fid_pointNew = fopen([ pdir '/' fn ], 'w');
prob.trg_pointNew = [ pdir '/' fn ];

% -------------------------------------------------------------------- 65
fn = [ prob.pn '_0065_' CN '_tryToAddPoint' tag '.txt' ];
prob.fid_tryToAddPoint = fopen([ pdir '/' fn ], 'w');
prob.trg_tryToAddPoint = [ pdir '/' fn ];

% -------------------------------------------------------------------- 66
fn = [ prob.pn '_0066_' CN '_setRadius' tag '.txt' ];
prob.fid_setRadius = fopen([ pdir '/' fn ], 'w');
prob.trg_setRadius = [ pdir '/' fn ];

% -------------------------------------------------------------------- 67
fn = [ prob.pn '_0067_' CN '_shiftPolynomialToEndBlock' tag '.txt' ];
prob.fid_shiftPolynomialToEndBlock = fopen([ pdir '/' fn ], 'w');
prob.trg_shiftPolynomialToEndBlock = [ pdir '/' fn ];














% ====================================================================
% OPTIMIZATION
CN = 'TROpt';

% -------------------------------------------------------------------- 0
fn = [ prob.pn '_0000_' CN '_TrustRegionOptimization' tag '.txt' ];
prob.fid_TrustRegionOptimization = fopen([ pdir '/' fn ], 'w');
prob.trg_TrustRegionOptimization = [ pdir '/' fn ];

% -------------------------------------------------------------------- 1
fn = [ prob.pn '_0001_' CN '_setLowerUpperBounds' tag '.txt' ];
prob.fid_setLowerUpperBounds = fopen([ pdir '/' fn ], 'w');
prob.trg_setLowerUpperBounds = [ pdir '/' fn ];

% -------------------------------------------------------------------- 10
fn = [ prob.pn '_0010_' CN '_computeInitialPoints' tag '.txt' ];
prob.fid_computeInitialPoints = fopen([ pdir '/' fn ], 'w');
prob.trg_computeInitialPoints = [ pdir '/' fn ];

% -------------------------------------------------------------------- 11 (46)
fn = [ prob.pn '_0011_' CN '_iterate' tag '.txt' ];
prob.fid_iterate = fopen([ pdir '/' fn ], 'w');
prob.trg_iterate = [ pdir '/' fn ];

% -------------------------------------------------------------------- 45
fn = [ prob.pn CN '_updateRadius' tag '.txt' ];
prob.fid_updateRadius = fopen([ pdir '/' fn ], 'w');
prob.trg_updateRadius = [ pdir '/' fn ];

% -------------------------------------------------------------------- 47
fn = [ prob.pn '_0047_' CN '_handleEvaluatedCase' tag '.txt' ];
prob.fid_handleEvaluatedCase = fopen([ pdir '/' fn ], 'w');
prob.trg_handleEvaluatedCase = [ pdir '/' fn ];

% -------------------------------------------------------------------- 48
fn = [ prob.pn '_0048_' CN '_addTempInitCase' tag '.txt' ];
prob.fid_addTempInitCase = fopen([ pdir '/' fn ], 'w');
prob.trg_addTempInitCase = [ pdir '/' fn ];

% -------------------------------------------------------------------- 49
fn = [ prob.pn '_0049_' CN '_submitTempInitCases' tag '.txt' ];
prob.fid_submitTempInitCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempInitCases = [ pdir '/' fn ];

% -------------------------------------------------------------------- 50
fn = [ prob.pn '_0050_' CN '_setAreInitPointsComputed' tag '.txt' ];
prob.fid_setAreInitPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_setAreInitPointsComputed = [ pdir '/' fn ];

% -------------------------------------------------------------------- 51
fn = [ prob.pn '_0051_' CN '_addTempImprCase' tag '.txt' ];
prob.fid_addTempImprCase = fopen([ pdir '/' fn ], 'w');
prob.trg_addTempImprCase = [ pdir '/' fn ];

% -------------------------------------------------------------------- 52
fn = [ prob.pn '_0052_' CN '_submitTempImprCases' tag '.txt' ];
prob.fid_submitTempImprCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempImprCases = [ pdir '/' fn ];

% -------------------------------------------------------------------- 53
fn = [ prob.pn '_0053_' CN '_setAreImprPointsComputed' tag '.txt' ];
prob.fid_setAreImprPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_setAreImprPointsComputed = [ pdir '/' fn ];

% -------------------------------------------------------------------- 54
fn = [ prob.pn '_0054_' CN '_addTempReplCase' tag '.txt' ];
prob.fid_addTempReplCase = fopen([ pdir '/' fn ], 'w');
prob.trg_addTempReplCase = [ pdir '/' fn ];

% -------------------------------------------------------------------- 55
fn = [ prob.pn '_0055_' CN '_submitTempReplCases' tag '.txt' ];
prob.fid_submitTempReplCases = fopen([ pdir '/' fn ], 'w');
prob.trg_submitTempReplCases = [ pdir '/' fn ];

% -------------------------------------------------------------------- 56
fn = [ prob.pn '_0056_' CN '_setAreReplPointsComputed' tag '.txt' ];
prob.fid_setAreReplPointsComputed = fopen([ pdir '/' fn ], 'w');
prob.trg_setAreReplPointsComputed = [ pdir '/' fn ];

% -------------------------------------------------------------------- 68
fn = [ prob.pn '_0068_' CN '_addInitializationCase' tag '.txt' ];
prob.fid_addInitializationCase = fopen([ pdir '/' fn ], 'w');
prob.trg_addInitializationCase = [ pdir '/' fn ];

% -------------------------------------------------------------------- 69
fn = [ prob.pn '_0069_' CN '_getInitializationCases' tag '.txt' ];
prob.fid_getInitializationCases = fopen([ pdir '/' fn ], 'w');
prob.trg_getInitializationCases = [ pdir '/' fn ];

% -------------------------------------------------------------------- 70
fn = [ prob.pn '_0070_' CN '_IsFinished' tag '.txt' ];
prob.fid_IsFinished = fopen([ pdir '/' fn ], 'w');
prob.trg_IsFinished = [ pdir '/' fn ];

% -------------------------------------------------------------------- 71
fn = [ prob.pn '_0071_' CN '_projectToBounds' tag '.txt' ];
prob.fid_projectToBounds = fopen([ pdir '/' fn ], 'w');
prob.trg_projectToBounds = [ pdir '/' fn ];


% ====================================================================
% MATH
CN = 'TRMth';
% -------------------------------------------------------------------- 72
fn = [ prob.pn '_0072_' CN '_sortVectorByIndex' tag '.txt' ];
prob.fid_sortVectorByIndex = fopen([ pdir '/' fn ], 'w');
prob.trg_sortVectorByIndex = [ pdir '/' fn ];

% -------------------------------------------------------------------- 73 
fn = [ prob.pn '_0073_' CN '_sortVectorByIndexRow' tag '.txt' ];
prob.fid_sortVectorByIndexRow = fopen([ pdir '/' fn ], 'w');
prob.trg_sortVectorByIndexRow = [ pdir '/' fn ];

% -------------------------------------------------------------------- 74
fn = [ prob.pn '_0074_' CN '_sortMatrixByIndex' tag '.txt' ];
prob.fid_sortMatrixByIndex = fopen([ pdir '/' fn ], 'w');
prob.trg_sortMatrixByIndex = [ pdir '/' fn ];


% ====================================================================
% SOLVER

end