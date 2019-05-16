function close_all_files(prob)
% close_all_files.m

% ====================================================================
% MODEL

fclose(prob.fid_TrustRegionModel); % 2
fclose(prob.fid_areInitPointsComputed); % 3
fclose(prob.fid_areImprPointsComputed); % 4
fclose(prob.fid_areReplacementPointsComputed); % 5
fclose(prob.fid_isInitialized); % 6
fclose(prob.fid_isImprovementNeeded); % 7
fclose(prob.fid_isReplacementNeeded); % 8
fclose(prob.fid_hasModelChanged); % 9

fclose(prob.fid_rebuildModel); % 12
fclose(prob.fid_setUpTempAllPoints); % 13
fclose(prob.fid_reCenterPoints); % 14
fclose(prob.fid_nfpBasis); % 15
fclose(prob.fid_rowPivotGaussianElimination); % 16

fclose(prob.fid_getRadius); % 17
fclose(prob.fid_isLambdaPoised); % 18
fclose(prob.fid_moveToBestPoint); % 19
fclose(prob.fid_findBestPoint); % 20
fclose(prob.fid_computePolynomialModels); % 21
fclose(prob.fid_computeQuadraticMNPolynomials); % 22
fclose(prob.fid_matricesToPolynomial); % 23
fclose(prob.fid_nfpFiniteDifferences); % 24
fclose(prob.fid_evaluatePolynomial); % 25
fclose(prob.fid_coefficientsToMatrices); % 26
fclose(prob.fid_combinePolynomials); % 27
fclose(prob.fid_multiplyPolynomial); % 28
fclose(prob.fid_addPolynomial); % 29
fclose(prob.fid_shiftPolynomial); % 30

fclose(prob.fid_checkInterpolation); % 31
fclose(prob.fid_getModelingPolynomials); % 32
fclose(prob.fid_measureCriticality); % 33
fclose(prob.fid_getModelMatrices); % 34

fclose(prob.fid_criticalityStep); % 35
fclose(prob.fid_isOld); % 36
fclose(prob.fid_ensureImprovement); % 37
fclose(prob.fid_isComplete); % 38

fclose(prob.fid_improveModelNfp); % 39
fclose(prob.fid_chooseAndReplacePoint); % 40
fclose(prob.fid_solveTrSubproblem); % 41
fclose(prob.fid_minimizeTr); % 42

fclose(prob.fid_getImprovementCases); % 43
fclose(prob.fid_getReplacementCases); % 44
fclose(prob.fid_changeTrCenter); % 57
fclose(prob.fid_addPoint); % 58
fclose(prob.fid_exchangePoint); % 59

fclose(prob.fid_normalizePolynomial); % 60
fclose(prob.fid_orthogonalizeToOtherPolynomials);  % 61
fclose(prob.fid_zeroAtPoint);  % 62
fclose(prob.fid_orthogonalizeBlock);  % 63

fclose(prob.fid_pointNew); % 64
fclose(prob.fid_tryToAddPoint); % 65
fclose(prob.fid_setRadius); % 66
fclose(prob.fid_shiftPolynomialToEndBlock); % 67

fclose(prob.fid_choosePivotPolynomial);


% ====================================================================
% OPTIMIZATION
% OPT
fclose(prob.fid_TrustRegionOptimization); % 0
fclose(prob.fid_setLowerUpperBounds); % 1
fclose(prob.fid_computeInitialPoints); % 10
fclose(prob.fid_iterate); % 11

fclose(prob.fid_updateRadius); % 45
fclose(prob.fid_handleEvaluatedCase); % 47

fclose(prob.fid_addTempInitCase); % 48
fclose(prob.fid_submitTempInitCases); % 49
fclose(prob.fid_setAreInitPointsComputed); % 50

fclose(prob.fid_addTempImprCase); % 51
fclose(prob.fid_submitTempImprCases); % 52
fclose(prob.fid_setAreImprPointsComputed); % 53

fclose(prob.fid_addTempReplCase); % 54
fclose(prob.fid_submitTempReplCases); % 55
fclose(prob.fid_setAreReplPointsComputed); % 56

fclose(prob.fid_addInitializationCase); % 68
fclose(prob.fid_getInitializationCases); % 69
fclose(prob.fid_IsFinished); % 70
fclose(prob.fid_projectToBounds); % 71

% ====================================================================
% MATH

fclose(prob.fid_sortVectorByIndex); % 72
fclose(prob.fid_sortVectorByIndexRow); % 73
fclose(prob.fid_sortMatrixByIndex); % 74


% ====================================================================
% SOLVER



