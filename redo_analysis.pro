PRO redo_analysis,event

;load the important information for the event in question
all_events,event,image_file,spec_file,drm_file,fit_time,bkg_time


;now redo the AIA analysis using averaged AIA data, for both the Gaussian and Epstein DEM functions
aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/aia_only

aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/epstein,/aia_only,n=10

;set some parameters
erange=[4,8]
uncert=0.04
epstein=0
;analyse the Gaussian profile
restore,'aia_fit_results.sav',/verbose
a=aia_fit_results

get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert

r=get_combined_chisq(a.chi_2d,chisq_results,n_aia=6,n_hsi=12)




;analyse the Epstein profile
epstein=1
restore,'aia_fit_results_epstein.sav',/verbose
ae=aia_fit_results

get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert

re=get_combined_chisq(ae.chi_2d,chisq_results,n_aia=6,n_hsi=12)



END