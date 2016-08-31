# Data from OS, download here: https://www.ordnancesurvey.co.uk/opendatadownload/products.html
# made accessible by MySociety: http://parlvid.mysociety.org/os/
URL='http://parlvid.mysociety.org/os/bdline_gb-2016-05.zip'
ZIP=cache/bdline_gb-2016-05.zip

exec: district.csv clean_tmp

district.csv: county.csv district.shp
	ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f CSV -lco "GEOMETRY=AS_WKT" -lco "SEPARATOR=TAB" $@ district.shp

county.csv: county.shp
	ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f CSV -lco "GEOMETRY=AS_WKT" -lco "SEPARATOR=TAB" $@ county.shp

county.shp:	county.dbf
	unzip -p $(ZIP) Data/GB/county_region.shp > $@

county.dbf:	county.prj
	unzip -p $(ZIP) Data/GB/county_region.dbf > $@

county.prj:	county.shx
	unzip -p $(ZIP) Data/GB/county_region.prj > $@

county.shx:	$(ZIP)
	unzip -p $(ZIP) Data/GB/county_region.shx > $@

district.shp:	district.dbf
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.shp > $@

district.dbf:	district.prj
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.dbf > $@

district.prj:	district.shx
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.prj > $@

district.shx:	$(ZIP)
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.shx > $@

clean_tmp:
	rm *.shx
	rm *.prj
	rm *.dbf
	rm *.shp

clean:
	rm *.csv

$(ZIP):
	mkdir -p cache
	curl -qs $(URL) > $@
