PRO test_saturation,filenames,sat_nums,tot_nums,sat_percents,t,xrange=xrange,yrange=yrange,hsi_image=hsi_image,quiet=quiet

length=n_elements(filenames)
sat_nums=fltarr(length)
tot_nums=fltarr(length)
sat_percents=fltarr(length)
t=fltarr(length)

FOR n=0,length-1 do begin

	read_sdo,filenames[n],index,data
	index2map,index,data,map

	IF keyword_set(xrange) OR keyword_set(yrange) THEN BEGIN	
		sub_map,map,smap,xrange=xrange,yrange=yrange
		data=smap.data
	ENDIF

	IF keyword_set(hsi_image) THEN BEGIN
		IF keyword_set(xrange) OR keyword_set(yrange) THEN BEGIN
			aiamap=smap
		ENDIF ELSE BEGIN
			aiamap=map
		ENDELSE
		fits2map, hsi_image, hsimap
		; interpolate the rhessi map to the aia map
	
		mask_map = inter_map(hsimap,aiamap)
		;need to check if the source is on the disk, if so run drot, if not 
		;do not!
		;mask_map = drot_map(mask_map, time = aiamap.time)
		m = max(mask_map.data, mindex)
		; set the mask at everything above 50% contour
		ind = where(mask_map.data LE m*0.5, complement = complement)
		mask_map.data[ind] = 0
		mask_map.data[complement] = 1
	
	ENDIF ELSE BEGIN
		;if no RHESSI image, then by default entire AIA map is used
		IF keyword_set(xrange) OR keyword_set(yrange) THEN BEGIN
			mask_map = smap
		ENDIF ELSE BEGIN
			mask_map = map
		ENDELSE
			mask_map.data[*] = 1
	ENDELSE

	e=size(data)

	i1=e[1]
	j1=e[2]

	saturation_array=fltarr(i1,j1)
	saturation_array[*,*]=0

	for i=0,i1-1 do begin
		for j=0,j1-1 do begin
			if (data[i,j] gt 16000.) THEN saturation_array[i,j]=1
		endfor
	endfor

	tot_num=total(mask_map.data)
	sat_num=total(saturation_array)

	sat_percent=(sat_num/tot_num) * 100.
	IF NOT keyword_set(quiet) THEN BEGIN
	print,' '
	print,'number of saturated pixels in image is: ',sat_num
	print,'total number of pixels in image is: ',tot_num
	print,'percentage of saturated pixels in image is: ',sat_percent
	print,' '
	ENDIF
	
	sat_nums[n]=sat_num
	tot_nums[n]=tot_num
	sat_percents[n]=sat_percent
	t[n]=anytim(index.date_obs)

ENDFOR

END