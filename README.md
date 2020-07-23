# Builtup_Change_Detection
In this project, for all 3 satellites (Landsat-7, Landsat-8, and Sentinel-2), we detect the change in the builtup areas at pixel level. We do this for the year 2016 and 2019. So, each pixel is classified as one of the following-
  * **CBU (Constantly Builtup) -** This pixel remains builup in all 4 years (2016-2019)
  * **CNBU (Constantly Non-builtup) -** This pixel remains non-builup in all 4 years (2016-2019)
  * **Changing -** This pixel is non-builtup in 2016 and by the year 2019 it becomes builup and hence is designated as a "Changing pixel"
  
# Input
 As an input to this project we use the land-cover predictions from the [IndiaSat](https://github.com/ChahatBansal8060/IndiaSat) project. The yearly predictions corresponding to each city/area of interest are kept in a directory named **Landcover_Predictions_Using_IndiaSat**. Apart from this, we require the groundtruth for testing the accuracy of our change detection procedure and is stored in the directory **CBU_CNBU_Changing_Groundtruth**. Finally, we require some reference tiffiles of each city for the accuracy determining procedure, which can be found in **Reference_district_tiffiles**.
 
# Description
  * We are testing the change classifier across 3 satellites- Landsat-7, Landsat-8, Sentinel-2.
  * For each of these satellites, the [IndiaSat](https://github.com/ChahatBansal8060/IndiaSat) project computes the landcover predictions for 6 years- 2015, 2016, 2017, 2018, 2019, and 2020. Out of these 6 years the purpose of 2015 and 2020 is to temporally correct the corner years of interest i.e. 2016 and 2019. So, we test the change classifier for both the cases when the corner years are improved VS corner years not being improved. The procedure of temporal correction is covered in the [IndiaSat](https://github.com/ChahatBansal8060/IndiaSat) project.
  * Now for each case, we check whether a regression-based change classifier works better with a fixed threshold, or simply taking the difference of corner years (2016 and 2019) works for us. So for each satellite we test the following 4 combinations-
    * Un-improved corner years, regression-based change classifier
    * Un-improved corner years, difference-based change detection
    * Improved corner years, regression-based change classifier
    * Improved corner years, difference-based change detection
   
# Final Results
As a compilation of all results and comparing the performance across different satellites, find the slides in the document named **Change_Classifier_Document.pdf**. As per our analysis, **Improved Corner Years, With difference-based change detection** gives the best results in the most simplest manner.

# Execution
Each directory has a run.sh file. Run that using sh run.sh command in your terminal, and it'll guide you through the process.

# Contact
For any queries, contact- Chahat Bansal **(chahat.bansal@cse.iitd.ac.in)**
 
 
