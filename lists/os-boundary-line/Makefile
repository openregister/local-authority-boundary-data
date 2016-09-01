# Data from OS, download here: https://www.ordnancesurvey.co.uk/opendatadownload/products.html
# made accessible by MySociety: http://parlvid.mysociety.org/os/
URL='http://parlvid.mysociety.org/os/bdline_gb-2016-05.zip'
ZIP=cache/bdline_gb-2016-05.zip

exec: os-boundary-line.tsv clean_tmp

os-boundary-line.tsv: county.tsv district.tsv
	if [[ -e county.tsv ]];   then cat county.tsv > $@ ; fi
	if [[ -e district.tsv ]]; then sed 1d district.tsv >> $@ ; fi

district.tsv: district.csv
	[[ -e os-boundary-line.tsv ]] || mix run -e 'BoundaryLine.tsv(nil, "district.csv", :district, 4)' > $@

county.tsv: mix.deps county.csv
	[[ -e os-boundary-line.tsv ]] || mix run -e 'BoundaryLine.tsv(nil, "county.csv", :county, 4)' > $@

mix.deps:
	[[ -e mix.lock ]] || mix deps.get
	[[ -e os-boundary-line.tsv ]] || mix compile

district.csv: county.csv district.shp
	[[ -e $@ ]] || ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f CSV -lco "GEOMETRY=AS_WKT" -lco "SEPARATOR=TAB" $@ district.shp

county.csv: county.shp
	[[ -e $@ ]] || ogr2ogr -s_srs EPSG:27700 -t_srs EPSG:4326 -f CSV -lco "GEOMETRY=AS_WKT" -lco "SEPARATOR=TAB" $@ county.shp

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
	rm -f *.shx
	rm -f *.prj
	rm -f *.dbf
	rm -f *.shp
	rm -f county.tsv
	rm -f district.tsv

clean:
	rm -f *.csv
	rm -f *.tsv

$(ZIP):
	mkdir -p cache
	curl -qs $(URL) > $@
