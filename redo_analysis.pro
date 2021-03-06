PRO redo_analysis,event,dir=dir

;load the important information for the event in question
all_events,event,image_file,spec_file,drm_file,fit_time,bkg_time
default,dir,''

;now redo the AIA analysis using averaged AIA data, for both the Gaussian and Epstein DEM functions
aia_hsi_dem_analysis,dir=dir,fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/aia_only

aia_hsi_dem_analysis,dir=dir,fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/epstein,/aia_only,n=10

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

get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert,emfactor=emfactor,sigma_array=sigma_array

r=get_combined_chisq(a.chi_2d^2,chisq_results,n_aia=6,n_hsi=12)

read,tmp1,prompt='Input first index for best combined fit:'
read,tmp2,prompt='Input second index for best combined fit:'
combobest=[tmp1,tmp2]

replot_hsi_count_spectrum_from_dem,epstein=epstein,type='combo',chisq_results=chisq_results,combobest=combobest,emfactor=emfactor,/ps,sigma_array=sigma_array
replot_aia_flux_ratios,combobest=combobest,/outps
replot_combo_dem,n=10,epstein=epstein,combobest=combobest,emfactor=emfactor,chisq_results=chisq_results

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

get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert,emfactor=emfactor,sigma_array=sigma_array
re=get_combined_chisq(a.chi_2d^2,chisq_results,n_aia=6,n_hsi=12)

read,tmp1,prompt='Input first index for best combined fit:'
read,tmp2,prompt='Input second index for best combined fit:'
combobest=[tmp1,tmp2]

replot_hsi_count_spectrum_from_dem,epstein=epstein,type='combo',chisq_results=chisq_results,combobest=combobest,emfactor=emfactor,/ps,sigma_array=sigma_array
replot_aia_flux_ratios,/epstein,combobest=combobest,/outps
replot_combo_dem,n=10,epstein=epstein,combobest=combobest,emfactor=emfactor,chisq_results=chisq_results

;make the files into an archive
CASE event OF
1: string='20110605'
2: string='20110606'
3: string='20110621'
4: string='20110716'
5: string='20110826'
6: string='20111011'
7: string='20120620'
8: string='20120910'
9: string='20120915'
10:string='20120927'
ENDCASE

spawn,'rm replot*'+string+'.ps' 
spawn,'\ls replot*.ps',list
file_appender,list,string

spawn,'tar -czf replots_new_'+string+'.tar.gz replot*'+string+'.ps'

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