PRO do_dem_analysis,image_file=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time

default,image_file,'hsi_image_20120910_072102.fits'
default,spec_file, 'hsi_spectrum_20120910_063840_d1.fits'
default,drm_file, 'hsi_srm_20120910_063840_d1.fits'
default,fit_time,['10-Sep-2012 07:22:00.000', '10-Sep-2012 07:23:00.000'] 
default,bkg_time,['10-Sep-2012 07:08:00.000', '10-Sep-2012 07:12:00.000']    


aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/aia_only

aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/epstein,/aia_only,n=10

aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time

aia_hsi_dem_analysis,dir='',fileset='AIA',/force_table,hsi_image=image_file,spec_file=spec_file,drm_file=drm_file,fit_time=fit_time,bkg_time=bkg_time,/epstein,n=10


;add plotting routines here
plot_aia_flux_ratios
plot_aia_flux_ratios,/epstein

plot_combo_dem
plot_combo_dem,n=10,/epstein

plot_hsi_count_spectrum_from_dem,/ps,type='aia'
plot_hsi_count_spectrum_from_dem,/ps,type='hsi'
plot_hsi_count_spectrum_from_dem,/ps,type='combo'
plot_hsi_count_spectrum_from_dem,/ps,type='aia',/epstein
plot_hsi_count_spectrum_from_dem,/ps,type='hsi',/epstein
plot_hsi_count_spectrum_from_dem,/ps,type='combo',/epstein

plot_aia_flux_ratios,/outps
plot_aia_flux_ratios,/epstein,/outps


END

