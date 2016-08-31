# Data from OS, download here: https://www.ordnancesurvey.co.uk/opendatadownload/products.html
# made accessible by MySociety: http://parlvid.mysociety.org/os/
URL='http://parlvid.mysociety.org/os/bdline_gb-2016-05.zip'
ZIP=cache/bdline_gb-2016-05.zip

district_borough_unitary.csv: county.csv
	ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f CSV -lco "GEOMETRY=AS_WKT" -lco "SEPARATOR=TAB" $@ cache/Data/GB/district_borough_unitary_region.shp

county.csv: $(ZIP)
	ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f CSV -lco "GEOMETRY=AS_WKT" -lco "SEPARATOR=TAB" $@ cache/Data/GB/county_region.shp

$(ZIP):
	mkdir -p cache
	curl -qs $(URL) > $@
	cd cache
	unzip $(ZIP)
