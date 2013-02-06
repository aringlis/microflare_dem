;
; NAME: GET_ENERGY_FROM_DEM
;
; PURPOSE: Utility function which performs an estimate of the total
; radiated energy of an event based on an input DEM. This is done by
; generating the radiative loss function from the Chianti database and
; performing an integral of dEM(T) x loss_func(T).
;
; CALLING SEQUENCE:
; result = get_energy_from_dem(temperatures, dem=dem,params=params,area=area,n=n,epstein=epstein)
;
; INPUTS:
;      TEMPERATURES:      an input temperature array
;
; KEYWORD INPUTS:
;      PARAMS: the DEM fit parameters. Used to generate the DEM array
;      over the range specified by temperatures. Assumed to consist of 3
;              components.
;              params[0] - emission measure value at the DEM centre
;              params[1] - temperature where the DEM centre is located
;              params[2] - width parameter associated with the DEM
;                          distribution
;      DEM:    alternatively, the pre-constructed DEM array can be
;      passed in using this keyword.
;      AREA: the estimated area of the flare. Needed to convert to
;      emission measure in terms of cm^-3
;      EPSTEIN:  If set, the input DEM parameters are interpreted as
;                an Epstein profile. Otherwise a Gaussian profile is
;                assumed.
;      n:        The steepness parameter of the Epstein distribution. Needed
;                if EPSTEIN keyword is set.
;
; WRITTEN:
;      Andrew Inglis, 2012/11/27
;

FUNCTION get_energy_from_dem,temperatures,dem=dem,params=params,area=area,n=n,epstein=epstein

IF not keyword_set(area) THEN BEGIN
    print,' '
    print,'-------------------'
    print,'Please provide a flare area estimate using the AREA keyword.'
    print,'-------------------'
    print,' '
    return, -1
ENDIF

IF keyword_set(params) THEN BEGIN
   IF keyword_set(dem) THEN BEGIN
      print,'Error: DEM and PARAMS are mutually exclusive.'
      return, -1
   ENDIF
   dem=get_dem_from_params(temperatures,params,n=n,epstein=epstein)
ENDIF

temp_lin=10^temperatures
area=double(area)

spawn,'\ls rad_loss.sav',rfile
IF (rfile ne '') THEN BEGIN
   print,'-----------------'
   print,'Restoring previously saved radiative loss function'
   print,'-----------------'
   restore,rfile,/verbose
ENDIF ELSE BEGIN
   print,'-----------------'
   print,'Generating the radiative loss function (user input is required)...'
   print,'-----------------'
   ;get the radiative loss function
   rad_loss,rad_temps,loss,density=1e11
   SAVE,rad_temps,loss,filename='rad_loss.sav',/verbose
ENDELSE

;interpolate the radiative loss function before performing integral
rlossfunction=interpol(loss,rad_temps,temp_lin,/quadratic)

total_energy_per_sec=int_tabulated(temp_lin,(rlossfunction*dem*area))

print,'total radiated energy per second: ' + num2str(total_energy_per_sec) + ' (erg/s)'

return,total_energy_per_sec

END
