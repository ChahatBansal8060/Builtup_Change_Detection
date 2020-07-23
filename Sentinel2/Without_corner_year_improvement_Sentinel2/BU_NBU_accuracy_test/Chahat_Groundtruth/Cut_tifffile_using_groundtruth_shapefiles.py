# ---------------------------------------------------------------------

# Copyright © 2020  Chahat Bansal

# All rights reserved

# ----------------------------------------------------------------------

import json
import rasterio
from rasterio.mask import mask
from json import loads
import os
from os import listdir
import kml2geojson
import shutil

#print("******** Cutting Predicted Tiffiles into smaller shapes according to groundtruth***********")
'''
The ground truth is manually created for 6 districts for the year 2016 and 2019
'''
districts = ['Bangalore', 'Chennai', 'Delhi', 'Gurgaon', 'Hyderabad', 'Mumbai']
years = ['2016','2017','2018','2019']

main_output_directory = 'Trimmed_tiffiles'
# Delete old results if any 
if os.path.exists(main_output_directory) and os.path.isdir(main_output_directory):
    shutil.rmtree(main_output_directory)

for district in districts:
    print("\n**************************\n")
    for year in years:
        
        folder_containing_tifffiles = "BU_NBU_maps/"+district+"/tifs"
        tiff_file_name = district+'_BU_NBU_'+year+'.tif'
        
        folder_containing_groundtruth_shapefiles = 'BU_NBU_Groundtruth/'+district
        
        for shapefile in listdir(folder_containing_groundtruth_shapefiles):
            if shapefile[-3:] == 'kml':
                kml2geojson.main.convert(folder_containing_groundtruth_shapefiles+'/'+shapefile, folder_containing_groundtruth_shapefiles)
                
                json_filepath = folder_containing_groundtruth_shapefiles+'/'+shapefile[:-3]+'geojson'
                json_data = json.loads( open(json_filepath).read() )
                
                output_directory = 'Trimmed_tiffiles/'+district+'/'+year+'/'+shapefile[:-4]
                os.makedirs(output_directory, exist_ok=True)
                
                i = 0            
                for currFeature in json_data["features"]:
                    i += 1
                    try:
                        geoms = [currFeature["geometry"]]

                        with rasterio.open(folder_containing_tifffiles+'/'+tiff_file_name) as src:
                            out_image, out_transform = mask(src, geoms, crop = True)
                            out_meta = src.meta

                            # save the resulting raster
                            out_meta.update({ "driver": "GTiff", "height": out_image.shape[1], "width": out_image.shape[2], "transform": out_transform})

                            saveFileName = output_directory+"/"+str(i)+".tif"
                            with rasterio.open(saveFileName, "w", **out_meta) as dest:
                                dest.write(out_image)
                    except:
                        continue
        print("The Tiffiles of ",district," have been cut wrt its groundtruth shapefiles for year ",year)
                           
print('\n#### Check Trimmed_tiffiles directory for output results ####\n')    





