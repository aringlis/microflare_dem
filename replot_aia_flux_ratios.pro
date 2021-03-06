PRO replot_aia_flux_ratios, epstein=epstein, OUTPS = outps, combobest=combobest

;plots modelled vs observed AIA flux for a given model DEM.


;restore,'aia_fit_results_manual.sav',/verbose
;a_man=aia_fit_results

;set_plot,'ps'
;device,encaps=1,filename='aia_flux_ratios_for_hsi_best.ps'

;plot,findgen(6)+1,a_man.flux_dem_3d[15,18,*]/a_man.flux_obs,psym=4,symsize=2,charsize=1.2,xrange=[0,7],xticks=7, $
;xtickname=[' ','131A','171A','193A','211A','335A','94A',' '],ytitle='flux_model/flux_obs',yran=[-0.2,2.5]

;oploterr,findgen(6)+1,a_man.flux_dem_3d[15,18,*]/a_man.flux_obs,findgen(6)*0 + 0.2,psym=4,symsize=2

;oplot,findgen(10),findgen(10)*0 + 1,linestyle=2,thick=2
;leg = num2str(a_man.chimin) + '[' + num2str(22.04) +',' + num2str(6.75) + ',' + num2str(0.1) + ']'

;leg = num2str(a_man.chimin) + '[' + num2str(6.75) + ',' + num2str(0.1) + ']'
;legend, leg, psym = 4,charsize=1.2

;device,/close
;set_plot,'x'

texps=[2.9,2.9,2.0,2.0,2.9,2.9]

IF keyword_set(epstein) THEN BEGIN
restore,'aia_fit_results_epstein.sav'
a=aia_fit_results
fname='replot_aia_flux_ratios_for_aia_best_epstein.ps'
ENDIF ELSE BEGIN
restore,'aia_fit_results.sav'
a=aia_fit_results
fname='replot_aia_flux_ratios_for_aia_best.ps'
ENDELSE

error=sqrt((0.2* a.flux_obs)^2 + (sqrt(a.flux_obs * texps)/texps)^2)
frac_error=error/a.flux_obs

tt=value_locate(a.telog,a.telog_best)
ss=value_locate(a.tsig,a.sig_best)

IF keyword_set(OUTPS) THEN BEGIN
	set_plot,'ps'
	device,encaps=1,filename=fname
ENDIF

!P.MULTI = [0,1,2]
!y.margin=[2,1]
hsi_linecolors
plot,findgen(6)+1,a.flux_dem_best,charsize=1.2,xrange = [0,7],xticks=7, $
xtickname=[' ','131A','171A','193A','211A','335A','94A',' '], ytitle='AIA DN Numbers', /nodata,xthick=3,ythick=3,thick=3,charthick=3

oploterr,findgen(6)+1,a.flux_obs,a.flux_obs*error, psym = symcat(14),symsize=2, /nohat,thick=3
oplot, findgen(6)+1, a.flux_dem_best, psym = 7, symsize = 1,thick=3

ssw_legend, ['AIA observed', 'FIT'], psym = [symcat(14), 7], charsize = 1.0,charthick=3,thick=3

plot,findgen(6)+1,a.flux_dem_best/a.flux_obs,psym=4,symsize=2,charsize=1.2,xrange=[0,7],xticks=7, $
xtickname=[' ','131A','171A','193A','211A','335A','94A',' '],ytitle='flux_model/flux_obs',yran=[0.0,2.5],thick=3,xthick=3,ythick=3,charthick=3

oploterr,findgen(6)+1,a.flux_dem_3d[tt,ss,*]/a.flux_obs,frac_error*(a.flux_dem_3d[tt,ss,*]/a.flux_obs),psym=symcat(14),symsize=2,thick=3
oplot,findgen(10),findgen(10)*0 + 1,linestyle=2,thick=3

leg = textoidl('\chi^2 = ') + num2str(a.chimin^2, length = 5) + ' [log(EM) = ' + num2str(a.em_best, length = 5) + ' cm!U-5!N, log(Tmax) = ' + num2str(a.telog_best, length = 5) + ' (' + num2str(10d^a.telog_best/1d6, length=5) + ' MK), sigma = ' + num2str(a.sig_best) + ']'
ssw_legend, leg, psym = symcat(14),charsize=0.75,charthick=3
!P.MULTI = 0
!y.margin=[4,2]
IF keyword_set(OUTPS) THEN BEGIN
	device,/close
	set_plot,'x'
;ENDIF

print,' '
print,'------------------------------'
print,'Wrote file: ',fname
print,'------------------------------'
print,' '

ENDIF
;f = file_search('aia_hsi_fit_results*')

;IF f[0] NE '' THEN BEGIN
	IF keyword_set(epstein) THEN BEGIN
;	restore,'aia_hsi_fit_results_epstein.sav'
;	ah=aia_hsi_fit_results
	fname='replot_aia_flux_ratios_for_best_combo_epstein.ps'
	ENDIF ELSE BEGIN
;	restore,'aia_hsi_fit_results.sav'
;	ah=aia_hsi_fit_results
	fname='replot_aia_flux_ratios_for_best_combo.ps'
	ENDELSE
	
	;chi_combo=ah.chi_2d+ah.chi2d_hsi
	;m= min(chi_combo,pos)
	;pos=array_indices(chi_combo,pos)
	pos=combobest
	chi_label=a.chi_2d[pos[0],pos[1]]^2
	IF keyword_set(OUTPS) THEN BEGIN
		set_plot,'ps'
		device,encaps=1,color=1,filename=fname
	ENDIF
	loadct,39

	;error=(0.2* a.flux_obs)
	;frac_error=error/a.flux_obs

	plot,findgen(6)+1,a.flux_dem_3d[pos[0],pos[1],*]/a.flux_obs,psym=4,symsize=2,charsize=1.5,xrange=[0,7],xticks=7, $
	xtickname=[' ','131A','171A','193A','211A','335A','94A',' '],ytitle=textoidl('flux_{model}/flux_{obs}'),yran=[0.0,2.5], charthick=3,thick=3,xthick=3,ythick=3
	
	oploterr,findgen(6)+1,a.flux_dem_3d[pos[0],pos[1],*]/a.flux_obs,frac_error*(a.flux_dem_3d[pos[0],pos[1],*]/a.flux_obs),psym=4,symsize=2,thick=3
	oplot,findgen(10),findgen(10)*0 + 1,linestyle=2,thick=3
	
	leg = [(textoidl('\chi^2_{aia} = ' + num2str(chi_label,length=4))), ('EM = '+ num2str(alog10(a.em_2d[pos[0],pos[1]]),length=4) $
	+', log T = '+num2str(a.telog[pos[0]],length=4) + ', ' + textoidl('\sigma') + ' = ' + num2str(a.tsig[pos[1]],length=4))]; + '[' + num2str(alog10(ah.em_2d[pos[0],pos[1]])) +',' + num2str(ah.telog[pos[0]]) + ',' + num2str(ah.tsig[pos[1]]) + ']'
	legend, leg,charsize=1.2,/top,/left,thick=3,charthick=3
	
	IF keyword_set(OUTPS) THEN BEGIN
		device,/close
		set_plot,'x'
	;ENDIF

                print,' '
                print,'------------------------------'
                print,'Wrote file: ',fname
                print,'------------------------------'
                print,' '

         ENDIF

;ENDIF


END
