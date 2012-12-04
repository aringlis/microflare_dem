FUNCTION get_combined_chisq,chi_red_aia,chi_red_hsi

n_aia=6
n_hsi=21
nfree=3

chi_full_aia=chi_red_aia*(n_aia-nfree)
chi_full_hsi=chi_red_hsi*(n_hsi-nfree)

chi_full_combo=chi_full_aia+chi_full_hsi

chi_red_combo=chi_full_combo/(n_aia + n_hsi - nfree)

return, chi_red_combo


END
