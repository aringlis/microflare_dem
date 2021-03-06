PRO replot_combo_dem,n=n,epstein=epstein,combobest=combobest,emfactor=emfactor,chisq_results=chisq_results

IF keyword_set(epstein) THEN BEGIN
   restore,'aia_hsi_fit_results_epstein.sav',/verbose
   ah=aia_hsi_fit_results
ENDIF ELSE BEGIN
   restore,'aia_hsi_fit_results.sav',/verbose
   ah=aia_hsi_fit_results
ENDELSE

IF keyword_set(epstein) THEN BEGIN
   restore,'aia_fit_results_epstein.sav',/verbose
   a=aia_fit_results
ENDIF ELSE BEGIN
   restore,'aia_fit_results.sav',/verbose
   a=aia_fit_results
ENDELSE

telog=ah.telog
tsig=ah.tsig

m=min(chisq_results,loc)
loc=array_indices(chisq_results,loc)
hsi_telog=telog[loc[0]]
hsi_tsig=tsig[loc[1]]

hsi_emconvert=a.em_2d[loc[0],loc[1]]
;hsi_emconvert=hsi_emconvert*1d24
;hsi_emconvert=hsi_emconvert*1d25
;hsi_emconvert=hsi_emconvert/(ah.flare_area * 11.6e6)
;hsi_emconvert=hsi_emconvert*emfactor
;chi_combo=a.chi_2d+a.chi2d_hsi


;combo_min=MIN(chi_combo,pos)
;pos=array_indices(chi_combo,pos)
pos=combobest

telog_best_combo=telog(pos[0])
tsig_best_combo=tsig(pos[1])
em_best_combo=a.em_2d[pos[0],pos[1]]

stop
;plot the dems
aia_dem=get_dem_from_params(telog,[(10^(a.em_best)),a.telog_best,a.sig_best],n=n,epstein=epstein)

;hsi_dem=get_dem_from_params(telog,[hsi_emconvert,hsi_telog,hsi_tsig],n=n,epstein=epstein)

combo_dem=get_dem_from_params(telog,[(em_best_combo),telog_best_combo,tsig_best_combo],n=n,epstein=epstein)

;window,1,xsize=756
set_plot,'ps'
device,encaps=1,color=1
IF keyword_set(epstein) THEN BEGIN
   device,filename='replot_combo_dem_epstein.ps'
ENDIF ELSE BEGIN
   device,filename='replot_combo_dem.ps'
ENDELSE

loadct,39
plot,telog,alog10(aia_dem),thick=3,xthick=3,ythick=3,charthick=3,charsize=1.5,linestyle=0,yrange=[18,23],ytitle='log EM (cm!U-5!N K!U-1!N)',xtitle = 'log T (K)',/nodata
oplot,telog,alog10(aia_dem),thick=3,color=240
;oplot,telog,alog10(hsi_dem),thick=3,linestyle=2

oplot,telog,alog10(combo_dem),thick=3,linestyle=0,color=50

ssw_legend,['AIA only','AIA and HSI'],linestyle=[0,0],thick=[3,3],color=[240,50],/right,charsize=1.2,charthick=3
device,/close
;set_plot,'x'

;device,color=1,bits_per_pixel=16
;IF keyword_set(epstein) THEN BEGIN
;   device,filename='replot_combo_chi_surface_epstein.ps'
;ENDIF ELSE BEGIN
;   device,filename='replot_combo_chi_surface.ps'
;ENDELSE

;loadct,3
;shade_surf,chi_combo,telog,tsig,charsize=2,/zlog,ax=40,az=70,yrange=[0,0.5],xtitle='log T (K)',ytitle='sigma',ztitle='chi_combo'

;device,/close
;set_plot,'x'
;device,color=1,bits_per_pixel=16
;IF keyword_set(epstein) THEN BEGIN
;   device,filename='replot_combo_chi_contour_epstein.ps'
;ENDIF ELSE BEGIN
;   device,filename='replot_combo_chi_contour.ps'
;ENDELSE
;window,1
;loadct,0

;nlevels = 200
;levels = a.chimin_hsi * (findgen(nlevels) + 1.0)
;contour,chi_combo,telog,tsig,charsize=2,levels=levels,thick=2,yrange=[0,0.5],xthick=3,ythick=3,charthick=3

;device,/close
;set_plot,'x'
END
