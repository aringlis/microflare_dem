FUNCTION get_combined_chisq,chi_red_aia,chi_red_hsi,n_aia=n_aia,n_hsi=n_hsi,nfree=nfree

default,n_aia,6
default,n_hsi,21
default,nfree,3

chi_full_aia=chi_red_aia*(n_aia-nfree)
chi_full_hsi=chi_red_hsi*(n_hsi-nfree)

chi_full_combo=chi_full_aia+chi_full_hsi

chi_red_combo=chi_full_combo/(n_aia + n_hsi - nfree)

return, chi_red_combo


END
