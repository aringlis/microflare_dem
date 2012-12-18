PRO all_events,event,spec_file,drm_file,fit_time,bkg_time

CASE event of
1: BEGIN	
	spec_file='hsi_spectrum_20110605_010128_d1.fits'
	drm_file='hsi_srm_20110605_010128_d1.fits'
	fit_time=['05-Jun-2011 02:13:30.000', '05-Jun-2011 02:14:30.000']
	bkg_time=['05-Jun-2011 02:02:00.000', '05-Jun-2011 02:06:00.000']
   END
2: BEGIN
	spec_file = 'hsi_spectrum_20110606_120744_d1.fits'
	drm_file = 'hsi_srm_20110606_120744_d1.fits'
	fit_time = ['06-Jun-2011 13:19:00.000', '06-Jun-2011 13:20:00.000'] 
	bkg_time = ['06-Jun-2011 13:05:00.000', '06-Jun-2011 13:09:00.000']  
   END
3: BEGIN
	spec_file = 'hsi_spectrum_20110621_175120_d1.fits'
	drm_file = 'hsi_srm_20110621_175120_d1.fits'
	fit_time = ['21-Jun-2011 18:22:00.000', '21-Jun-2011 18:23:00.000'] 
	bkg_time = ['21-Jun-2011 18:36:00.000', '21-Jun-2011 18:39:00.000']
   END
4: BEGIN
	spec_file = 'hsi_spectrum_20110716_161036_d1.fits'
	drm_file = 'hsi_srm_20110716_161036_d1.fits'
	fit_time = ['16-Jul-2011 17:02:00.000', '16-Jul-2011 17:03:00.000'] 
	bkg_time = ['16-Jul-2011 17:36:00.000', '16-Jul-2011 17:39:00.000'] 
   END
5: BEGIN
	spec_file = 'hsi_spectrum_20110826_200140_d1.fits'
	drm_file = 'hsi_srm_20110826_200140_d1.fits'
	fit_time = ['26-Aug-2011 20:53:00.000', '26-Aug-2011 20:54:00.000'] 
	bkg_time = ['26-Aug-2011 20:34:00.000', '26-Aug-2011 20:38:00.000'] 
   END
6: BEGIN
	spec_file = 'hsi_spectrum_20111010_232840_d1.fits'
	drm_file = 'hsi_srm_20111010_232840_d1.fits'
	fit_time = ['11-Oct-2011 00:35:00.000', '11-Oct-2011 00:36:00.000'] 
	bkg_time = ['11-Oct-2011 00:44:00.000', '11-Oct-2011 00:48:00.000'] 
   END
7: BEGIN
	spec_file = 'hsi_spectrum_20120620_151020_d1.fits'
	drm_file = 'hsi_srm_20120620_151020_d1.fits'
	fit_time = ['20-Jun-2012 15:48:00.000', '20-Jun-2012 15:49:00.000'] 
	bkg_time = ['20-Jun-2012 15:33:00.000', '20-Jun-2012 15:37:00.000'] 
   END
8: BEGIN
	spec_file = 'hsi_spectrum_20120910_063840_d1.fits'
	drm_file = 'hsi_srm_20120910_063840_d1.fits'
	fit_time = ['10-Sep-2012 07:22:00.000', '10-Sep-2012 07:23:00.000'] 
	bkg_time = ['10-Sep-2012 07:08:00.000', '10-Sep-2012 07:12:00.000']
   END
9: BEGIN
	spec_file = 'hsi_spectrum_20110716_161036_d1.fits'
	drm_file = 'hsi_srm_20110716_161036_d1.fits'
	fit_time = ['16-Jul-2011 17:02:00.000', '16-Jul-2011 17:03:00.000'] 
	bkg_time = ['16-Jul-2011 17:36:00.000', '16-Jul-2011 17:39:00.000']
   END
10:BEGIN
	spec_file = 'hsi_spectrum_20120927_053956_d1.fits'
	drm_file = 'hsi_srm_20120927_053956_d1.fits'
	fit_time = ['27-Sep-2012 06:56:00.000', '27-Sep-2012 06:57:00.000'] 
	bkg_time = ['27-Sep-2012 06:40:00.000', '27-Sep-2012 06:42:00.000']
   END
ENDCASE

END
