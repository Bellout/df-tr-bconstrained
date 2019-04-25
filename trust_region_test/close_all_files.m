function close_all_files(prob)
% close_all_files.m

fclose(prob.fid_moveToBestPoint);
fclose(prob.fid_measureCriticality);
fclose(prob.fid_getModelMatrices);
fclose(prob.fid_criticalityStep);
fclose(prob.fid_checkInterpolation);
fclose(prob.fid_submitTempInitCases);
fclose(prob.fid_submitTempImprCases);
fclose(prob.fid_setUpTempAllPoints);
fclose(prob.fid_rowPivotGaussianElimination);
fclose(prob.fid_reCenterPoints);
fclose(prob.fid_rebuildModel);
fclose(prob.fid_improveModelNfp);
fclose(prob.fid_ensureImprovement);
fclose(prob.fid_isLambdaPoised);
fclose(prob.fid_changeTrCenter);
fclose(prob.fid_solveTrSubproblem);
fclose(prob.fid_computePolynomialModels);
fclose(prob.fid_shiftPolynomialToEndBlock);
fclose(prob.fid_normalizePolynomial);
fclose(prob.fid_orthogonalizeToOtherPolynomials);
fclose(prob.fid_orthogonalizeBlock);
fclose(prob.fid_zeroAtPoint);
fclose(prob.fid_evaluatePolynomial);
fclose(prob.fid_addPolynomial);
fclose(prob.fid_multiplyPolynomial);
fclose(prob.fid_findBestPoint);
fclose(prob.fid_computeQuadraticMNPolynomials);
fclose(prob.fid_nfpFiniteDifferences);
fclose(prob.fid_combinePolynomials);
fclose(prob.fid_shiftPolynomial);
fclose(prob.fid_isComplete);
fclose(prob.fid_isOld);
fclose(prob.fid_chooseAndReplacePoint);
fclose(prob.fid_pointNew);
fclose(prob.fid_minimizeTr);
fclose(prob.fid_tryToAddPoint);
fclose(prob.fid_addPoint);
fclose(prob.fid_sortVectorByIndex);
fclose(prob.fid_sortVectorByIndexRow);
fclose(prob.fid_sortMatrixByIndex);
fclose(prob.fid_nfpBasis);
fclose(prob.fid_matricesToPolynomial);
fclose(prob.fid_coefficientsToMatrices);
fclose(prob.fid_TrustRegionModel);

fclose(prob.fid_addInitializationCase);
fclose(prob.fid_areInitPointsComputed);
fclose(prob.fid_isInitialized);
fclose(prob.fid_getInitializationCases);


% OPT
fclose(prob.fid_TrustRegionOptimization);
fclose(prob.fid_iterate);
fclose(prob.fid_handleEvaluatedCase);
fclose(prob.fid_updateRadius);
fclose(prob.fid_computeInitialPoints);
fclose(prob.fid_setLowerUpperBounds);
fclose(prob.fid_IsFinished);
fclose(prob.fid_projectToBounds);
