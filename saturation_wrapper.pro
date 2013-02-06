PRO saturation_wrapper,hsi_image,fit_time

spawn,'\ls *_0094.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,t,hsi_image=hsi_image,/quiet,fit_time=fit_time
sat_per_max_0094 = max(sat_percents,in)
t_max_0094=t[in]

spawn,'\ls *_0131.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,t,hsi_image=hsi_image,/quiet,fit_time=fit_time
sat_per_max_0131 = max(sat_percents,in)
t_max_0131=t[in]

spawn,'\ls *_0171.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,t,hsi_image=hsi_image,/quiet,fit_time=fit_time
sat_per_max_0171 = max(sat_percents,in)
t_max_0171=t[in]

spawn,'\ls *_0193.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,t,hsi_image=hsi_image,/quiet,fit_time=fit_time
sat_per_max_0193 = max(sat_percents,in)
t_max_0193=t[in]

spawn,'\ls *_0211.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,t,hsi_image=hsi_image,/quiet,fit_time=fit_time
sat_per_max_0211 = max(sat_percents,in)
t_max_0211=t[in]

spawn,'\ls *_0335.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,t,hsi_image=hsi_image,/quiet,fit_time=fit_time
sat_per_max_0335 = max(sat_percents,in)
t_max_0335=t[in]

print,'Worst saturation percentage for each wavelength:'
print,'--------------------------------------------------'
print,'94A : ',sat_per_max_0094,' located at: ',anytim(t_max_0094,/vms)
print,'131A: ',sat_per_max_0131,' located at: ',anytim(t_max_0131,/vms)
print,'171A: ',sat_per_max_0171,' located at: ',anytim(t_max_0171,/vms)
print,'193A: ',sat_per_max_0193,' located at: ',anytim(t_max_0193,/vms)
print,'211A: ',sat_per_max_0211,' located at: ',anytim(t_max_0211,/vms)
print,'335A: ',sat_per_max_0335,' located at: ',anytim(t_max_0335,/vms)

SAVE,sat_per_max_0094,sat_per_max_0131,sat_per_max_0171,sat_per_max_0193,sat_per_max_0211,sat_per_max_0335, $
t_max_0094,t_max_0131,t_max_0171,t_max_0193,t_max_0211,t_max_0335,filename='saturation_results.sav'
print,' '
print,'Saved results in file: saturation_results.sav'

END