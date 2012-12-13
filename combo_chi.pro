;NAME:
;	COMBO_CHI
;PURPOSE:
;	Utility function to combine AIA and RHESSI chi^2 maps. given a pair of 2D chi^2 maps, the minimum in the
;	combined map will be found, and the reduced chi^2 of this minimum recalculated.
;
;INPUTS:
;	chi1 - the AIA chi^2 map
;	chi2 - the RHESSI chi^2 map.
;KEYWORDS:
;	n_aia - number of AIA data points. Default is 6
;	n_hsi - number of RHESSI data points. Default is 21
;	nfree - number of free parameters. Default is 3
;OUTPUT:
;	returns the reduced chi^2 value of the combined map, and prints its array location.
;WRITTEN:
;	Andrew Inglis, 2012/12/13
;

FUNCTION combo_chi,chi1,chi2,n_aia=n_aia,n_hsi=n_hsi,nfree=nfree

chi_combo=chi1 + chi2

m=min(chi_combo,loc)
p=array_indices(chi_combo,loc)
print,'mininum in joint chi-squared located at: ',p

print,'individual reduced chi-squared values are :',chi1[p[0],p[1]],chi2[p[0],p[1]]

c=get_combined_chisq(chi1[p[0],p[1]],chi2[p[0],p[1]],n_aia=n_aia,n_hsi=n_hsi,nfree=nfree)
print,'combined reduced chi-squared value is :',c

return,c;[chi1[p[0],p[1]],chi2[p[0],p[1]]]

END
