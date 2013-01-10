PRO redo_analysis,event

;load the important information for the event in question
all_events,event,image_file,spec_file,drm_file,fit_time,bkg_time


;now redo the AIA analysis using averaged AIA data, for both the Gaussian and Epstein DEM functions
aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/aia_only

aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/epstein,/aia_only,n=10

;DO GAUSSIAN RECALCULATIONS
;--------------------------------------------------------------------------------------

;for reference
restore,'aia_hsi_fit_results.sav'
ah=aia_hsi_fit_results


;set some parameters
erange=[4,8]
uncert=0.04
epstein=0
;analyse the Gaussian profile
restore,'aia_fit_results.sav',/verbose
a=aia_fit_results

;find the ratio of EM_0 (new) / EM_0 (old) - use this to modify RHESSI model fluxes.
emfactor=a.em_2d[0,0]/ah.em_2d[0,0]

get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert,emfactor=emfactor

r=get_combined_chisq(a.chi_2d,chisq_results,n_aia=6,n_hsi=12)

read,tmp1,prompt='Input first index for best combined fit:'
read,tmp2,prompt='Input second index for best combined fit:'
combobest=[tmp1,tmp2]

replot_hsi_count_spectrum_from_dem,epstein=epstein,type='combo',chisq_results=chisq_results,combobest=combobest,emfactor=emfactor,/ps
replot_aia_flux_ratios,combobest=combobest,/outps
replot_combo_dem,n=1,epstein=epstein,combobest=combobest,emfactor=emfactor,chisq_results=chisq_results

;DO EPSTEIN RECALCULATIONS
;--------------------------------------------------------------------------------------

;for reference
restore,'aia_hsi_fit_results_epstein.sav'
ah=aia_hsi_fit_results

;analyse the Epstein profile
epstein=1
restore,'aia_fit_results_epstein.sav',/verbose
a=aia_fit_results

;find the ratio of EM_0 (new) / EM_0 (old) - use this to modify RHESSI model fluxes.
emfactor=a.em_2d[0,0]/ah.em_2d[0,0]

get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert,emfactor=emfactor

re=get_combined_chisq(a.chi_2d,chisq_results,n_aia=6,n_hsi=12)

read,tmp1,prompt='Input first index for best combined fit:'
read,tmp2,prompt='Input second index for best combined fit:'
combobest=[tmp1,tmp2]

replot_hsi_count_spectrum_from_dem,epstein=epstein,type='combo',chisq_results=chisq_results,combobest=combobest,emfactor=emfactor,/ps
replot_aia_flux_ratios,/epstein,combobest=combobest,/outps
replot_combo_dem,n=10,epstein=epstein,combobest=combobest,emfactor=emfactor,chisq_results=chisq_results


;DO SOME PLOTTING
;---------------------------------------------------------------------------------------
;c=min(re,loc)
;combobest=array_indices(re,loc)

;replot,hsi_count_spectrum_from_dem,epstein=epstein,type='combo',chisq_results=chisq_results,combobest=combobest,emfactor=emfactor
;replot_aia_flux_ratios,/epstein,combobest=[12,45],/outps

;c=min(r,loc)
;combobest=array_indices(r,loc)
;epstein=0
;replot,hsi_count_spectrum_from_dem,epstein=epstein,type='combo',chisq_results=chisq_results,combobest=combobest,emfactor=emfactor
;replot_aia_flux_ratios,combobest=[12,45],/outps

END