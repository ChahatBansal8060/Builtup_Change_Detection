# Builtup_Change_Detection
In this project, for all 3 satellites (Landsat-7, Landsat-8, and Sentinel-2), we detect the change in the builtup areas at pixel level. We do this for the year 2016 and 2019. So, each pixel is classified as one of the following-
  * **CBU (Constantly Builtup) -** This pixel remains builup in all 4 years (2016-2019)
  * **CNBU (Constantly Non-builtup) -** This pixel remains non-builup in all 4 years (2016-2019)
  * **Changing -** This pixel is non-builtup in 2016 and by the year 2019 it becomes builup and hence is designated as a "Changing pixel"
  
 # Input
 As an input to this project we use the land-cover predictions from the [IndiaSat](https://github.com/ChahatBansal8060/IndiaSat) project. The yearly predictions corresponding to each city/area of interest are kept in a directory named **Landcover_Predictions_Using_IndiaSat**. Apart from this, we require the groundtruth for testing the accuracy of our change detection procedure and is stored in the directory **CBU_CNBU_Changing_Groundtruth**. Finally, we require some reference tiffiles of each city for the accuracy determining procedure, which can be found in **Reference_district_tiffiles**.
 
 
