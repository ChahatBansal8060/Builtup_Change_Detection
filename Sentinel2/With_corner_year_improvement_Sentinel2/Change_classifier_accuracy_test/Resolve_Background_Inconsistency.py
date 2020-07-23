import numpy as np
import os, sys
from PIL import Image

districts = ['Chennai','Kolkata','Bangalore','Delhi','Gurgaon','Hyderabad','Mumbai']

for district in districts:
    print (district)
    main_folder = 'Landcover_Predictions_Using_IndiaSat/'+district
    
    years = ['2016','2017','2018','2019']
    
    dataset = [ np.array(Image.open(main_folder+'/'+district+'_prediction_'+i+'.png')) for i in years]
        
    image_dimensions = dataset[0].shape

    # verify all images have same number of background pixels
    backgroundPixels = np.unique(dataset[0],return_counts=True)[1][0] #With [1] access frequency list, with [0] get frequency of background pixels
    
    # If the background pixel count in each year's image is not same, mark pixel as background in all years if it is 0 in any year  
    if not all( np.unique(dataset[k],return_counts = True)[1][0] == backgroundPixels for k in range(len(dataset))):        
        print("Resolving inconsistency in the number of background pixels across years")
        for i in range(image_dimensions[0]):
            for j in range(image_dimensions[1]):
                res = False
                res = True in (image[i][j] == 0 for image in dataset) 
                if res == True:
                    for image in dataset:
                        image[i][j] = 0

    backgroundPixels = np.unique(dataset[0],return_counts=True)[1][0] #With [1] access frequency list, with [0] get frequency of background pixels
    if not all( np.unique(dataset[k],return_counts = True)[1][0] == backgroundPixels for k in range(len(dataset))):        
        print("Inconsistencies in the number of background pixels across years still exists\n")
        break

     
    # storing corrected images
    for i in range(len(years)):
        dataset[i] = (Image.fromarray(dataset[i])).convert("L")
        dataset[i].save(main_folder+'/'+district+'_prediction_'+years[i]+'.png')

