PRO replot_hsi_count_spectrum_from_dem,epstein=epstein,ps=ps,type=type,chisq_results=chisq_results,combobest=combobest,emfactor=emfactor,sigma_array=sigma_array

default,type,'combo'


IF keyword_set(epstein) THEN BEGIN
   restore,'aia_hsi_fit_results_epstein.sav',/verbose
ENDIF ELSE BEGIN
   restore,'aia_hsi_fit_results.sav',/verbose
ENDELSE

a=aia_hsi_fit_results


IF keyword_set(epstein) THEN BEGIN
   restore,'aia_fit_results_epstein.sav',/verbose
ENDIF ELSE BEGIN
   restore,'aia_fit_results.sav',/verbose
ENDELSE

;find the best-fit AIA parameters and assign the model spectrum
f=aia_fit_results
tloc=value_locate(f.telog,f.telog_best)
sigloc=value_locate(f.tsig,f.sig_best)

aia_spec=a.model_count_flux_hsi[tloc,sigloc,*]*emfactor
aia_sigma=sigma_array[tloc,sigloc]

;find the best-fit combo parameters and assign the model spectrum
pos=[combobest[0],combobest[1]]
;chi_combo=a.chi_2d + a.chi2d_hsi
;m=min(chi_combo,pos)
;pos=array_indices(chi_combo,pos)
combo_spec=a.model_count_flux_hsi[pos[0],pos[1],*]*emfactor
combo_sigma=sigma_array[pos[0],pos[1]]

;find the best-fit RHESSI parameters and assign the model spectrum
m=min(chisq_results,hsipos)
hsipos=array_indices(chisq_results,hsipos)
hsi_spec=a.model_count_flux_hsi[hsipos[0],hsipos[1],*] * emfactor
hsi_sigma=sigma_array[hsipos[0],hsipos[1]]

;xticks=[' ',' ','5',' ',' ',' ',' ','10']

IF (type eq 'hsi') THEN BEGIN
   model=hsi_spec
   yrange=[0.01,max(model) + 1]
   chi_label=min(chisq_results)
   err=hsi_sigma
ENDIF ELSE IF (type eq 'aia') THEN BEGIN
   model=aia_spec
   yrange=[0.01,max(model) + 1]
   chi_label=chisq_results[tloc,sigloc]
   err=aia_sigma
ENDIF ELSE IF (type eq 'combo') THEN BEGIN
   model=combo_spec
   yrange=[0.01,max(model) + 1]
   chi_label=chisq_results[pos[0],pos[1]]
   err=combo_sigma
ENDIF ELSE BEGIN
   print,' '
   print,'-----------------'
   print,'Unknown value of TYPE keyword. Aborting.'
   return
ENDELSE

IF keyword_set(ps) THEN BEGIN
   set_plot,'ps'
   IF keyword_set(epstein) THEN BEGIN
      device,encaps=1,color=1,filename='replot_rhessi_count_spectrum_vs_model_'+type+'_epstein.ps'
   ENDIF ELSE BEGIN
      device,encaps=1,color=1,filename='replot_rhessi_count_spectrum_vs_model_'+type+'.ps'
   ENDELSE
ENDIF

loadct,39

plot,a.axis[0,*],a.real_count_flux_hsi[1,1,*],/xlog,/ylog,thick=3,xthick=3,ythick=3,xrange=[3,12],yrange=yrange,linestyle=3,charsize=1.5, $
xtitle='energy (keV)',ytitle='counts s!U-1!N cm!U-2!N kev!U-1!N',xstyle=1,ystyle=1,charthick=3,/nodata 
oplot,a.axis[0,*],a.real_count_flux_hsi[1,1,*],thick=3,color=50,linestyle=3
oploterr,a.axis[0,*],a.real_count_flux_hsi[1,1,*],err,psym=0,thick=3,linestyle=3,color=50,errcolor=50
oplot,a.axis[0,*],model,thick=3,color=240

;show the fitting range on the plot
oplot,(findgen(10000)*0. + 4),(findgen(10000)*0.01),linestyle=1,thick=2
oplot,(findgen(10000)*0. + 8),(findgen(10000)*0.01),linestyle=1,thick=2

xyouts,0.75,0.8,textoidl('\chi^2_{hsi} = ' + num2str(chi_label,length=4)),/norm,charsize=1.5,charthick=3
ssw_legend,['RHESSI count flux','Model count flux'],linestyle=[3,0],color=[50,240],thick=[3,3],/bottom,/left,charsize=1.2,charthick=3


IF keyword_set(ps) THEN BEGIN
   device,/close
   set_plot,'x'
ENDIF

END
