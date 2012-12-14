;NAME:
;	GET_COMBINED_CHISQ
;PURPOSE:
;	Utility function to combine reduced AIA and RHESSI chi^2 maps. given a pair of 2D chi^2 maps, the
;	combined reduced chi-squared map will be found. The mimimum of the combined map is printed out.
;
;INPUTS:
;	chi_red_aia - the AIA reduced chi^2 map (or a single AIA chi-squared value if /SINGLE is set)
;	chi_red_hsi - the RHESSI reduced chi^2 map (or a single RHESSI chi-squared value if /SINGLE is set)
;KEYWORDS:
;	n_aia - number of AIA data points. Default is 6
;	n_hsi - number of RHESSI data points. Default is 21
;	nfree - number of free parameters + 1. Default is 3
;	single - if set, the inputs chi_red_aia and chi_red_hsi are assumed to be single scalar values.
;OUTPUT:
;	returns the combined reduced chi^2 map, and prints out its minimum and location.
;WRITTEN:
;	Andrew Inglis, 2012/12/04
;	Andrew Inglis, 2012/12/14 - reworked function. Now accepts either two chi-squared maps as the input, or
;				two chi-squared scalar values. The number of AIA and RHESSI points are now keywords
;				as is the number of degrees of freedom.
;				Added /SINGLE keyword to allow input of two scalar values. 
;



FUNCTION get_combined_chisq,chi_red_aia,chi_red_hsi,n_aia=n_aia,n_hsi=n_hsi,nfree=nfree,single=single

default,n_aia,6
default,n_hsi,21
default,nfree,3

IF (n_elements(chi_red_aia) eq 1) OR (n_elements(chi_red_hsi) eq 1) THEN BEGIN
	print,' '
	print,'---------------------------------------------'
	print,'Scalar inputs detected. Using /SINGLE keyword'
	single=1
ENDIF 

IF (n_elements(chi_red_aia) ne n_elements(chi_red_hsi)) THEN BEGIN
	print,' '
	print,'---------------------------------------------'
	print,'Mismatched input dimensions. Aborting.'
	return,-1
ENDIF

print,'------------------------------------------'
print,'the following parameters were used:'
print,'N_AIA = ',n_aia
print,'N_HSI = ',n_hsi
print,'NFREE = ',nfree
print,'------------------------------------------'



;First, reverse engineer the full chi-squared values by multiplying by (N - nfree)
chi_full_aia=chi_red_aia*(n_aia-nfree)
chi_full_hsi=chi_red_hsi*(n_hsi-nfree)

;combine the two full chi-squared maps
chi_full_combo=chi_full_aia+chi_full_hsi

;find the reduced chi-squared for this new combined map. Divide by the TOTAL number of data points - nfree
chi_red_combo=chi_full_combo/(n_aia + n_hsi - nfree)

;if just a single value then need to avoid an error. Otherwise, find the minimum value in the new chi-squared map.
IF keyword_set(single) THEN BEGIN
	chi_red_best = chi_red_combo
	p2=0
ENDIF ELSE BEGIN
	m2=min(chi_red_combo,loc2)
	p2=array_indices(chi_red_combo,loc2)
	chi_red_best = chi_red_combo[p2[0],p2[1]]
ENDELSE


print,'combined reduced chi-squared minimum value is :',chi_red_best
print,'located at: ',p2
print,'Returning combined reduced chi-squared map.'

;return the combined reduced chi-squared map or value.
return, chi_red_combo


END
