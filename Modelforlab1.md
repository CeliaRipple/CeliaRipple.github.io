Distance from point model:
[Image of model](Imageofpointdistancemodel.png)
this model allows the user to find the directions and the distances of polygons on a shape file from a point either on a separate layer or created via the centroid function.
Image of Model
The user should consider their polygon shapefile to be featureinput2 in this model. City center should be a coordinate point on a separate layer, or can be created by selecting polygons on the shapefile. The Model will find the centroids of the selected polygons then average their centers to create one coordinate point. 
Then the model will find the centroids of all the polygons in the featureinput2 layer and calculate their distances and direction from the citycenter layer. 
An added feature allows the user to create original names for output fields.
The link is an example of the model used on census tracts in Milwaukee county to find the direction in degrees of census tracts from the city center [MapDirectionFromCityCenter](Direction From City Center Milwaukee Metropolitan.png)  
Here you will find a link to to the model: [lab1model](Distance_from_point.model3m.model3)
Here you will find a visual of the from the case study described visualized in a scatter plot where Median Gross Rent is graphed in relation to direction from the city center: [scatterplot](ScatterPlotRentvsDirection.html)
Here you will find the same results visualized in a polar plot:[polarplot](PolarPlotRentvsDirection.html)
