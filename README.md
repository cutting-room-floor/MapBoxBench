# MapBox Bench

This is a benchmarking tool for testing iOS tile loading from our (or other) servers. 

## Options

### Retina

On capable devices, choose to either use retina-compatible tiles drawn at actual 256px size or non-compatible tiles drawn at 512px in order to retain legibility. 

### Concurrency

These are our testbed options for concurrency approaches. For now, choose our regular method or an experimental asynchronous mode. More to come. 

### Concurrency Options

If using the experimental modes, configure them here. 

#### Prefetch Radius

Consider a tile request for tile `X`. Entering a radius value of `2` will synchronously request tile `X` as well as kick off concurrent, asynchronous fetches for the following tiles (`2` tiles in all directions). These tiles go straight to local cache if successful, to be drawn later by subsequent tile requests (cache is always checked first before network fetching). 

    o o o o o
    o o o o o
    o o X o o
    o o o o o
    o o o o o

#### Max Concurrency

Aside from the normal synchronous tile fetches, how many simultaneous background fetches should be allowed. 

### User Location Services

Configure the standard "show user" & "center on user" options here. 

### Debugging

#### Tile borders & labels

Draw borders on fetched tiles as well as their `z`/`x`/`y` values. 

### TileJSON URL

Enter an alternate TileJSON URL to load or choose the default MapBox Streets. 

### MapKit Debug Layer

Temporarily hide SDK functionality to see how Apple's MapKit shows the current view. 

### Artificial Latency

Introduce an artificial delay in tile loads to simulate various network conditions. 