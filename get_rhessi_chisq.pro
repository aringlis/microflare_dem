;NAME: 
;	GET_RHESSI_CHISQ
;PURPOSE:
;	Re-calculate the reduced chi-squared map for RHESSI, fitted over a given energy range. The real and model fluxes
;	come from a previously saved aia_hsi_fit_results.sav file. The uncertainties for RHESSI are calculated from the square root of
;	the model counts, added in quadrature with the square root of the background counts and the systematic uncertainty (2% by default).
;CATEGORY:
;	SPECTRA, XRAYS, STATISTICS
;CALLING SEQUENCE:
;	get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert,emfactor=emfactor
;
;PREREQUISITES:
;	An IDL save file called aia_hsi_fit_results_epstein.sav needs to exist in the local directory.
;	The SPEX branch of SSW must be installed.
;
;INPUTS:
;	ERANGE - a two-element vector specifying the energy range, in keV, over which to find chi-squared. e.g. [5,12] or [4,8].
;KEYWORD INPUTS:
;	EPSTEIN - if set, restores the aia_hsi_fit_results_epstein.sav file. 
;	N - the steepness index of the Epstein profile. Default is 10.
;	SPEC_FILE - the RHESSI spectral file to use. Only needed to initialise OSPEX and get some extra information that is not stored in
;		the aia_hsi_fit_results_epstein.sav file.
;	DRM_FILE - the RHESSI SRM file corresponding to the given spectral file.
;	FIT_TIME - the time over which the RHESSI fit was performed.
;	BKG_TIME - the time denoting the chosen RHESSI background interval.
;	UNCERT - the level of systematic uncertainty. Default is 0.02 (2%).
;	EMFACTOR - if the value of EM_0 has changed, use this to modify the RHESSI model flux. The model flux will be multiplied by the value of EMFACTOR. 
;		Hence if the new value of EM_0 is half the original, EMFACTOR = 0.5
;OUTPUTS:
;	CHISQ_RESULTS - a 2D array containing the RHESSI reduced chi-squared for each iteration of the fit parameters.
;WRITTEN:
;	Andrew Inglis - 2012/12/13
;	Andrew Inglis - 2013/01/09 - added EMFACTOR to allow recalculation of chi-squared with a different value of EM_0.
;	
;





PRO get_rhessi_chisq,erange,chisq_results,epstein=epstein,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,n=n,uncert=uncert,emfactor=emfactor,sigma_array=sigma_array

default,epstein,1
default,n,10
default,uncert,0.02

default,erange,[5,12]

default,spec_file,'hsi_spectrum_20110826_200140_d1.fits'
default,drm_file,'hsi_srm_20110826_200140_d1.fits'
default,fit_time,['26-Aug-2011 20:53:00.000', '26-Aug-2011 20:54:00.000']
default,bkg_time,['26-Aug-2011 20:34:00.000', '26-Aug-2011 20:38:00.000']


;want to input the model flux from aia_hsi_fit_results.sav
;model_count_rate = obj -> calc_func_components(this_interval=0, /use_fitted, photons=0, spex_units='rate')
;model_crate=model_count_rate.yvals

;restore the file where the fit results were saved. The model array is included here for every parameter iteration
;the real flux data is also included.
IF keyword_set(epstein) THEN BEGIN
	restore,'aia_hsi_fit_results_epstein.sav',/verbose
	ah=aia_hsi_fit_results
ENDIF ELSE BEGIN
	restore,'aia_hsi_fit_results.sav',/verbose
	ah=aia_hsi_fit_results
ENDELSE

IF keyword_set(emfactor) THEN BEGIN
	model_flux_array=ah.model_count_flux_hsi * emfactor
ENDIF ELSE BEGIN
	model_flux_array=ah.model_count_flux_hsi
ENDELSE

;now need to get the object associated with the real data. Just do this once by calling get_hsi_table_entry (param values don't matter) and retrieving the info.

IF keyword_set(epstein) THEN BEGIN
	get_hsi_table_entry,[0.01,0.09,8.0,0.6,0.27,n,1],model_count_flux,real_count_flux,axis,summary, obj=obj, $
						spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,epstein=epstein
ENDIF ELSE BEGIN
	get_hsi_table_entry,[0.01,0.09,8.0,0.6,0.27,1],model_count_flux,real_count_flux,axis,summary, obj=obj, $
						spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time
ENDELSE

;results=spex_read_fit_results('ospex_results_12_dec_2012.fits')


;now retrieve summary information from OSPEX object
results=summary

;define a mask so that only the chosen energy range is fitted
mask=where((results.spex_summ_energy[1,*] gt erange[0]) AND (results.spex_summ_energy[1,*] lt erange[1]))
q=mask

;get the background error
bke=results.spex_summ_bk_error

;q=where(results.spex_summ_emask[0:50])
;q=mask

;get the count rates of the actual observations
real_crate=results.spex_summ_ct_rate


;need the livetime during the fit interval, rather than the full duration
ltime=obj->getdata(class='spex_fitint')
ltime=ltime.ltime[0]


sz=size(model_flux_array)
chisq_results=fltarr(sz[1],sz[2])
sigma_array=fltarr(sz[1],sz[2],sz[3])


for i=0,sz[1] -1 do begin
	for j=0,sz[2]-1 do begin

		;convert the flux array to count rates by multiplying by the area and the bin width.
		model_crate=reform(model_flux_array[i,j,*])* summary.spex_summ_area * 0.353605

		

		;calculate sigma
		sigma_cts=sqrt((model_crate*ltime) + (results.spex_summ_bk_rate * ltime))
		sigma_bk=sqrt(results.spex_summ_bk_rate * ltime)
		sigma_sys=uncert * (real_crate*ltime)

		sigma_cts_rate = sigma_cts/ltime
		sigma_bk = results.spex_summ_bk_error
		sigma_sys_rate = sigma_sys/ltime

		;sigma_tot=sqrt(sigma_cts^2 + sigma_bk^2 + sigma_sys^2)
		;work out the total sigma by adding the error contributions in quadrature
		sigma_tot_rate = sqrt(sigma_cts_rate^2 + sigma_bk^2 + sigma_sys_rate^2)

;sigma_tot_rate=sigma_tot/ltime


		;work out (O-E)^2/sigma^2 for each element
		values=(real_crate[q] - model_crate[q])^2 / sigma_tot_rate[q]^2
		;find the number of data points 
		npoints = n_elements(q)
		;find the reduced X^2
		chisq_red = total(values)/(npoints-1)

		chisq_results[i,j]=chisq_red
		sigma_array[i,j,*]=sigma_tot_rate/(summary.spex_summ_area * 0.353605)

	endfor
endfor


print,'Best reduced chi-squared is: ', min(chisq_results,loc)

print,'Found at location: ',array_indices(chisq_results,loc)


END