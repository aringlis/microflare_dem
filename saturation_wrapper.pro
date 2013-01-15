PRO saturation_wrapper,hsi_image

spawn,'\ls *_0094.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,hsi_image=hsi_image,/quiet
sat_per_max_0094 = max(sat_percents)

spawn,'\ls *_0131.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,hsi_image=hsi_image,/quiet
sat_per_max_0131 = max(sat_percents)

spawn,'\ls *_0171.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,hsi_image=hsi_image,/quiet
sat_per_max_0171 = max(sat_percents)

spawn,'\ls *_0193.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,hsi_image=hsi_image,/quiet
sat_per_max_0193 = max(sat_percents)

spawn,'\ls *_0211.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,hsi_image=hsi_image,/quiet
sat_per_max_0211 = max(sat_percents)

spawn,'\ls *_0335.fits',files
test_saturation,files,sat_nums,tot_nums,sat_percents,hsi_image=hsi_image,/quiet
sat_per_max_0335 = max(sat_percents)

print,'Worst saturation percentage for each wavelength:'
print,'--------------------------------------------------'
print,'94A : ',sat_per_max_0094
print,'131A: ',sat_per_max_0131
print,'171A: ',sat_per_max_0171
print,'193A: ',sat_per_max_0193
print,'211A: ',sat_per_max_0211
print,'335A: ',sat_per_max_0335


END