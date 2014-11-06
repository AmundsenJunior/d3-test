#Steps
- VirtualBox
- Ubuntu
- Updates
- VirtualBox Guest Additions
- Git
- Node
- NPM
- GDAL
- TopoJSON


###Installation procedure of VirtualBox, Ubuntu, GitHub account
(pulled from [amp-test tutorial](https://github.com/AmundsenJunior/amp-test/TUTORIAL.md))
- Download VirtualBox and Ubuntu Desktop (14.04 LTS 64-bit) prior to training
	https://www.virtualbox.org/wiki/Downloads
	http://www.ubuntu.com/download/desktop
- Go through full VirtualBox installation on Mac or Windows, accepting all settings, including networking (with temporary interruption of Internet connectivity during installation)
- Create New VirtualBox VM, with at least 512 MB memory, and dynamically allocated 8GB disk space, all other options at default
- Once created, Start the VM, and select the downloaded ISO Ubuntu disk image for starting installation
- Erase disk (this refers to your VirtualBox hardisk that you just created) and install Ubuntu
- Accept most settings, create a user name and password, download updates during installation
- Upon restart, you may need to select Reset in the VirtualBox window (Under File -> Reset) once the Ubuntu screen reaches “Stopping early crypto disks… [OK]”
- Once it’s restarted, find the Software Updater icon on the Launcher bar, and click to be prompted for Restart (this is installing the updates downloaded earlier.)

Install VirtualBox Guest Additions
- Under the VirtualBox window options, go to "Devices -> Insert Guest Additions CD image”
- Enter your user password to continue
    
apt updates

	$ sudo apt-get update
	$ sudo apt-get upgrade

git

	$ sudo apt-get install git

###Install Node.js and NPM
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server

	$ sudo apt-get update
	$ sudo apt-get install -y nodejs
	$ sudo apt-get install -y npm

Confirm installation

	$ nodejs -v

Add the node->nodejs symlink for Ubuntu Node installations:
http://stackoverflow.com/questions/21168141/can-not-install-packages-using-node-package-manager-in-ubuntu

	$ sudo apt-get install -y nodejs-legacy

###Installing GeoJSON and TopoJSON
http://bost.ocks.org/mike/map/

The GDAL documentation on OpenGeo.org is very out-of-date, so after some failed apt-repo additions, then after trying to build from source, I found some up-to-date help:
https://www.mapbox.com/tilemill/docs/guides/gdal/#linux

	$ sudo apt-get install gdal-bin

Install TopoJSON:

	$ sudo npm install -g topojson

Confirm both installations:

	$ which ogr2ogr
	$ which topojson

### Building the d3-test environment

Up to this point, we've been working in systemwide processes, installing dependencies for our project. Next, let's clone the d3-test repository, and from this point on, work from the project directory root. On my machine, I usually create ```~/dev/``` directory for all my projects, then clone into there:

	$ git clone https://github.com/AmundsenJunior/d3-test.git
	$ cd d3-test

Moving along with Bostock's tutorial, we'll next download a couple interesting shapefiles to start to play with. Once unpacked, we will then run through the conversion process to get them into TopoJSON format, useful for D3 processing and manipulation. The following seven shapefile sets will be downloaded.

*Cultural Vectors*:
* Sovereign States and subunits: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_map_subunits.zip
* States and Provinces: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip
* Populated places: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip
* Urban areas: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_urban_areas.zip

*Physical Vectors*:
* Coastline: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_coastline.zip
* Rivers and Lake centerlines: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_rivers_lake_centerlines.zip
* Lakes and Reservoirs: http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip

The ```na-download.sh``` and ```na-unzip.sh``` Bash scripts have been built and executed. In their process, they make the appropriate directory structure in the project, download the Natural Earth zip files to ```data/geo/source/```, then unzip those files into subdirectories of ```data/geo/shapefile/```, one per zip file. The two files are executed from the project root, on the command line with the following:

	$ bash na-download.sh
	$ bash na-unzip.sh

You can now run the ```na-convert-json.sh``` file in the same manner, and it will execute all the following steps to create two GeoJSON files, ```subunits.json``` and ```places.json```, then merge those into our new TopoJSON file, ```na.json```:

	$ bash na-convert-json.sh

Converting data is a two-step process, first using ```ogr2ogr``` to convert shapefiles (```.shp```) into GeoJSON files (```.json```). The second step converts the GeoJSON files into TopoJSON (also ```.json```). Even though we downloaded several files, we'll start with two of Bostock's suggestions, Countries and Populated Places.

(Use a backslash ('\') to write a command in the shell on multiple lines. The shell will automatically generate the right carets ('>') to prompt that it expects more for the command.)

Again, the following commands are now executed by ```build/na-convert-json.sh```. We first select the 'USA', 'CAN', and 'MEX' objects from the ```...subunits.shp``` file, then create ```places.json``` by selecting all 'US', 'CA', and 'MX' objects with a SCALERANK less than 8 (with 1 marking the largest class of places). In the script, this was later modified to ```SCALERANK < 3```, as the number of places that populated the map was exorbitant.

	$ ogr2ogr \
	> -f GeoJSON \
	> -where "ADM0_A3 IN ('USA', 'CAN', 'MEX')" \
	> subunits.json \
	> data/geo/shapefile/ne_10m_admin_0_map_subunits/ne_10m_admin_0_map_subunits.shp

	$ ogr2ogr \
	> -f GeoJSON \
	> -where "ISO_A2 IN ('US', 'CA', 'MX') AND SCALERANK < 8" \
	> places.json \
	> data/geo/shapefile/ne_10m_populated_places\ne_10m_populated_places.shp


We next pull the two GeoJSON files together into one TopoJSON file ('na.json' for 'North America') with the following:

	$ topojson \
	> -o na.json \
	> --id_property SU_A3 \
	> --properties name=NAME \
	> -- \
	> subunits.json \
	> places.json

With that process completed, I received the following output:

	bounds: -179.1435033839999 18.906117143000117 179.78093509200014 83.116522528000009
	pre-quantization: 39.9m (0.000359deg) 7.14m (0.0000642deg)
	topology: 762 arcs, 103022 points
	post-quantization: 3.991km (0.0359deg) 714m (0.00642deg)
	prune: retained 748 / 762 arcs (98%)

The next step is to load the data into a website for viewing: http://bost.ocks.org/mike/map/#loading-data

For our testing purposes, we'll serve the example site locally with Connect and Serve-Static, two packages we can install with npm:
http://stackoverflow.com/questions/6084360/using-node-js-as-a-simple-web-server

	$ npm install connect serve-static

This builds a ```./node-modules``` directory in our project. We run the server locally by first building a ```server.js``` file (already created):

	var connect = require('connect');
	var serveStatic = require('serve-static');
	connect().serveStatic(__dirname)).listen(8080);

We can now run the server from the project directory with the following:

	$ node server.js

and go to http://localhost:8080/na.html to view the running site. In the shell, the server is an open running process, so unless you open a new tab, you can't work from the shell with the server running. To stop the server, press ```Ctrl+C```.

```/na.html``` mirrors Bostock's initial ```index.html```, with "na" swapped in for any "uk" references. And as a card-carrying geographer, I have to be able to do North America better than a Mercator projection. D3 makes this incredibly easy, as there are number of standard projections supported (https://github.com/mbostock/d3/wiki/Geo-Projections).

I'm going to borrow and play with some of Bostock's example style for Albers Equal Area Conic projection (http://bl.ocks.org/mbostock/3734308). This is a beautiful thing with D3. For folks with GIS experience (especially of the ESRI variety), this is kind of really awesome. Playing with geodata in this format, the data and the map kept strictly separated, able to save all my changes to version control. Just fun.

