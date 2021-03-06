PRO plot_qflux_histogram_single,filename,qflux_final=qflux_final,ps=ps

restore,filename,/verbose
delvarx,te_map,em_map,sig_map,chi_map,tsig_errmap_symmetric,telog_errmap_symmetric,temperature_map,emission_map,sigma_map

big=size(aia_simul_map_cube.data)
qflux_final=fltarr(big[1],big[2],6)
!p.multi=[0,2,3]

wave=['131','171','193','211','335','94']

IF keyword_set(ps) THEN begin
set_plot,'ps'
device,encaps=1,bits_per_pixel=8,ysize=20,filename='qflux_histogram.ps'
ENDIF ELSE BEGIN
window,17,xsize=1024,ysize=1024
ENDELSE

for n=0,5 do begin

qflux_final(*,*,n)=float(aia_simul_map_cube(n).data(*,*))/float(aia_map_cube(n).data(*,*)) 
endfor

for i=0,big[1]-1 do begin
for j=0,big[2]-1 do begin 
for k=0,5 do begin
	IF (qflux_final(i,j,k) gt 10.) OR (qflux_final(i,j,k) le 0.0) THEN qflux_final(i,j,k)=10.

endfor
endfor
endfor

histo0=histogram(reform(qflux_final(*,*,0)),binsize=0.1,locations=locations0,max=3)
histo1=histogram(reform(qflux_final(*,*,1)),binsize=0.1,locations=locations1,max=3)
histo2=histogram(reform(qflux_final(*,*,2)),binsize=0.1,locations=locations2,max=3)
histo3=histogram(reform(qflux_final(*,*,3)),binsize=0.1,locations=locations3,max=3)
histo4=histogram(reform(qflux_final(*,*,4)),binsize=0.1,locations=locations4,max=3)
histo5=histogram(reform(qflux_final(*,*,5)),binsize=0.1,locations=locations5,max=3)


plot,locations0,histo0,psym=10,xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
al_legend,wave[0]+'A',/right,charsize=1.5

plot,locations1,histo1,psym=10,xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
al_legend,wave[1]+'A',/right,charsize=1.5

plot,locations2,histo2,psym=10,xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
al_legend,wave[2]+'A',/right,charsize=1.5

plot,locations3,histo3,psym=10,xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
al_legend,wave[3]+'A',/right,charsize=1.5

plot,locations4,histo4,psym=10,xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
al_legend,wave[4]+'A',/right,charsize=1.5

plot,locations5,histo5,psym=10,xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
al_legend,wave[5]+'A',/right,charsize=1.5

set_plot,'ps'
device,encaps=1,bits_per_pixel=8,ysize=20,xsize=20,filename='qflux_histogram.ps'
plot,locations0,histo0,psym=10,yrange=[0,60],xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
xyouts,2.5,50,'131A'
plot,locations1,histo1,psym=10,yrange=[0,60],xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
xyouts,2.5,50,'171A'
plot,locations2,histo2,psym=10,yrange=[0,60],xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
xyouts,2.5,50,'193A'
plot,locations3,histo3,psym=10,yrange=[0,60],xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
xyouts,2.5,50,'211A'
plot,locations4,histo4,psym=10,yrange=[0,60],xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
xyouts,2.5,50,'335A'
plot,locations5,histo5,psym=10,yrange=[0,60],xrange=[0,3],charsize=1.5,ytitle='N',xtitle='qflux'
xyouts,2.5,50,'94A'

qflux_final(*,*)=0.
;endfor
;device,/close
;set_plot,'x'

IF keyword_set(ps) THEN BEGIN
device,/close
set_plot,'x'
ENDIF

!p.multi=[0,1,1]



END