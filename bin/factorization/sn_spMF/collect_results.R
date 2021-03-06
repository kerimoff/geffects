suppressWarnings(library(plyr))

collect_results <- function(outputdir, K, alpha1, lambda1, n_runs){

	# read in the arguments
	Fn = paste0('K', K, '_a1', alpha1, '_l1', lambda1); 
	# outputdir = file.path(outputdir, paste0('sn_spMF_', Fn));
	#print(outputdir)

	F_all = list()
	fcorr_all = list()
	iii = 1
	coph_test = c()
	nfactor = c()
	min_obj = Inf
	for(run_idx in seq(1,n_runs)){
		outputFn = paste0(outputdir, '/sn_spMF_', Fn, '_Run',run_idx, '.RData');
		if (!file.exists(outputFn)){
			#print(paste0(outputFn, ' does not exist'))
			next
		}

		load(outputFn);
		if(objective[length(objective)] < min_obj){ 
			run_optimal = run_idx
			min_obj = objective[length(objective)]
		}
		factor_corr = cor(FactorM)
		factor_corr = norm(factor_corr, 'F');

		F_all[[iii]] = FactorM;
		fcorr_all[[iii]] = factor_corr;
		nfactor = c(nfactor, ncol(FactorM));
		iii = iii + 1;
		if(iii > 2){
			coph_test = c(coph_test, cophenet(F_all))
		}
	}


	if(length(F_all) > 1){
		coph = cophenet(F_all);
		cat('\n')
		print(paste(rep("#",30), collapse = ''));
		#print(paste0(length(F_all), ' runs'));	
		#print(coph_test);
		print(paste0('K = ', (K), '; alpha1 = ', (alpha1),'; lambda1 = ', (lambda1)));
		print(paste0('Coph = ', coph, "; mean fcorr = ", mean(unlist(fcorr_all))));
		print(paste(rep("#",30), collapse = ''))
		cat('\n');
		return(c(K, alpha1, lambda1, coph, mean(unlist(fcorr_all)), mean(nfactor), run_optimal, min_obj))
	}else{
		print(paste0(Fn, ': not enough runs available'))
		return(NULL)
	}

}

