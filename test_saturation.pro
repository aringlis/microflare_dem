PRO test_saturation,filename,sat_num,tot_num,xrange=xrange,yrange=yrange


read_sdo,filename,index,data


IF keyword_set(xrange) OR keyword_set(yrange) THEN BEGIN
	index2map,index,data,map
	sub_map,map,smap,xrange=xrange,yrange=yrange
	data=smap.data
ENDIF

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

tot_num=e[4]
sat_num=total(saturation_array)

sat_percent=(sat_num/tot_num) * 100.
print,' '
print,'number of saturated pixels in image is: ',sat_num
print,'total number of pixels in image is: ',tot_num
print,'percentage of saturated pixels in image is: ',sat_percent
print,' '

END