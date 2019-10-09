This is a visualization of the steps for week 3 lab

step 1: 
Download and import 2 DEM tiles of ASTER data collected by NASA and the Japanese Space System from the Earth Data Search website. After importing the DEMs into the saga they will look like this ![Demsnotmosaiced](DEMfilesASTER.png)

The DEMs need to be mosaiced together to create one seemless DEM. The Mosaicking tool lives under Grid> gridding> Mosaicking
Use the Nearest Neighbor parameter to execute the tool.
After the DEMS have been mosaicked they will look like this ![DEMSmosaic](MosaicmapASTER.png)

Step 2:
The DEMs are now mosaicked together, but they are in WGS84. We need to reproject into World Mercator.
to do this go to the projection tab under tools the to Proj.4 then to UTM projection (Grid). 
The >>source is now the layer that was created from the DEMs that we mosaicked together.
execute this step. Now the layers will be in World Mercator. 

Step 3: 
To create a hillshade, go to the tools and under the Terrain Analysis tab go to Lighting, visibility then to Analytical 
Hillshading. The source is the Mosaicked DEM. Keep all other parameters in default. The output will look like this ![Hillshade](hillshadeASTER.png)

Step 4: 
 Before we can do a hyrdological analysis, we have to identify the "sinks" in the landscape and remove them. This is a two step process. To detect the sinks in the elevation model go to the Terrain analysis tab under tools then to preprocessing then 
to Sink Drainage Route Dectection. The source is the mosaic. Keep all other parameters in default. The output will look like this ![Detect Sinks](sinkrouteASTER.png)

Step 5: 
Next we can remove the sinks using the previous layer we just created so that the sinks won't cause errors in analysis later on. 
To remove the sinks go to the Terrain Analysis tab under the tools then to preprocessing and to sink removal. 
Use the Mosaic as the source and the sink Route layer made in the previous step as the Sink Route. 
Create the preprocessed DEM. It will look like this ![no sinks](nosinksASTER.png)

Step 6: 
Next to calcualte Flow accumulation go to terrain analysis under tools then to hydrology then to flow accumulation (top- Down)
Use the Sink filled DEM for the elevation and the sink routes made in step 4 for the Sink Routes. 
Create the Flow accumulation layer and it will look like this ![Flow Accumulation](FlowaccumulationASTER.png)

Step 7: 
The final step is to create the channel networks to determine where there are streams. 
Go to the terrain anaylsis under tools and to channels then to channel network. 
Again use the sink filled DEM for the elevation. Create the Channel network, the Channel Route, and the Channel Naetwork (shapes)
When you crteate this layer it will look like this. ![Channel Networks](channelnetworkASTER.png)


Lab4 

For lab 4, we looked at the same study area, but used a batch procress to run data to do hydrological analysis. We then used this batch 
process to run data from ASTER as we did in the first lab and SRTM data collected by NASA at 1 arc second on the same area of mnt. 
Kilimanjaro. 
The batch process for the hydrological anaylsis of ASTER data looks like this [ASTER Batch Process](mosaic_utmproj_hillshade_sinks_sinkremoval_flowaccumulation_Channelnetworks.bat)
The batch process for the same analysis with SRTM data looks like this [SRTM Batch Process]()
Notice that the only difference between the two models are the prefix names and the file locations of the data. 

