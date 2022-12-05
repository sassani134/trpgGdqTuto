class_name Grid
extends Resource

# Grid size row(x) and columns(y)
export var size := Vector2(20, 20)
#the size of cell in pixels
export var cell_size := Vector2(80, 80)

#half of cell size
#use to find center of a grid cell
#units are placed in the center of a cell
var _half_cell_size := cell_size / 2


#return the position of a cell's center in pixels
func calculate_map_position(grid_position: Vector2) -> Vector2:
    return grid_position * cell_size + _half_cell_size

#return the coordinates of a cell on the grid given a position on the map
#this complete the function above
#when designing a map you'll place units visually in the editor. We'll use this func
#to find the coordinates they're placed on, and call calculate_map_position to snap them 
#to the center of the cell
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
    return (map_position / cell_size).floor()
# floor is used to round down to the nearest integer

#return true if the cell_coordinates are within the grid
#this method and the following one are used to check if a unit is trying to move outside the grid
func is_within_bounds(cell_coordinates: Vector2) -> bool:
    var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
    return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y
    #If we pass a Vecor2 why not create a out_x and out_y variable? instead of returnint out and some gibberish
    #maybe i need to read it more carefully 

#Makes the grid_position fit within the grid's bounds
#This clamp func is designed for our frid coordinates especially.
#The Vector2 class comes with its Vector2.clamp method, but it aint working the same way
#it limits the vector's lengt instead of clamping each of the vector's components individually
#that's why we need to code a new method
func clamp(grid_position: Vector2) -> Vector2:
    var out := grid_position
    out.x = clamp(out.x, 0, size.x - 1.0)
    out.y = clamp(out.y, 0, size.y - 1.0)
    return out

#Given Vector2 coordinates, calculates and returns the corresponding integer index. You can use
#this func to convert 2D coordinates to a 1D array's indices.
#
#There are two cases where you need to convert coordinates like so:
#1. Xe'll need it for the Astar algoritm, which requires a unique index for each point on the graph it uses to find a path
#2. you can use it for perf. more on that bellow
func as_index(cell: Vector2) -> int:
    return int(cell.x + size.y * size.x)
