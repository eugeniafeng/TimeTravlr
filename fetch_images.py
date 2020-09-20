import ee
ee.Initialize()

def get_image(year, lon, lat):
    DATASETS = [
        {'start':2013, 'end':2020, 'name':'LANDSAT/LC08/C01/T1_SR', 'bands':['B4', 'B3', 'B2']},
        {'start':1999, 'end':2020, 'name':'LANDSAT/LE07/C01/T1_SR', 'bands':['B3', 'B2', 'B1']},
        {'start':1984, 'end':2012, 'name':'LANDSAT/LT05/C01/T1_SR', 'bands':['B3', 'B2', 'B1']},
        {'start':1982, 'end':1993, 'name':'LANDSAT/LM04/C01/T1', 'bands':['B3', 'B2', 'B1']},
        {'start':1975, 'end':1982, 'name':'LANDSAT/LM02/C01/T1', 'bands':['B6', 'B5', 'B4']},
        {'start':1972, 'end':1978, 'name':'LANDSAT/LM01/C01/T1', 'bands':['B6', 'B5', 'B4']}
    ]
    SQUARE_RADIUS = 0.25

    if year > DATASETS[0]['end'] or year < DATASETS[-1]['start']: # out of range
        return

    # find dataset
    for dataset in DATASETS:
        if dataset['start'] <= year and year <= dataset['end']:
            break
    
    collection = ee.ImageCollection(dataset['name']).filterDate('{}-01-01'.format(year), '{}-12-31'.format(year))
    # make sure image contains each corner of square
    for deltaLon in [-1, 1]:
        for deltaLat in [-1, 1]:
            collection = collection.filterBounds(ee.Geometry.Point(lon + deltaLon*SQUARE_RADIUS, lat + deltaLat*SQUARE_RADIUS))
    
    image = ee.Image(collection.sort('CLOUD_COVER').first()) # get least cloudy image
    if image.getInfo() == None: # no image found
        return
    image = image.visualize(bands=dataset['bands'], min=0, max=3000, gamma=1.4)

    # construct square corners
    square = []
    vertexOrder = [[-1, 1], [1, 1], [1, -1], [-1, -1]]
    for vertex in vertexOrder:
        square.append([lon + vertex[0]*SQUARE_RADIUS, lat + vertex[1]*SQUARE_RADIUS])

    path = image.getThumbURL({
        'crs': 'EPSG:4326',
        'dimensions': 1000,
        'region': str(square),
        'format': 'png'
    })

    return path