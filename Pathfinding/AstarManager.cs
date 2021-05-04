using Godot;
using System;

public class AstarManager : Node
{
	[Export]
	private NodePath  terrain_tile_map;
	[Export]
	private NodePath wall_tile_map;
	[Export]
	private int wall_cost = 1000;
	[Export]	
	private Vector2 map_size= new Vector2(100,100);

	public AStar astar_node ;
	private Vector2 start_pos;
	private Vector2 end_pos;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready() {
		astar_node = new AStar();
		
		var walkable_cells= (GetNode(terrain_tile_map) as TileMap).GetUsedCellsById(1);
		astar_add_walkable_cells(walkable_cells);
		astar_connect_walkable_cells(walkable_cells);
		var walls = (GetNode(wall_tile_map) as TileMap).GetUsedCellsById(0 );
		foreach(Vector2 wall in walls){
			edit_astar_connection_weight(wall,wall_cost);
		}
	}
	public void astar_add_walkable_cells(Godot.Collections.Array cells){
		foreach ( Vector2 cell in cells){
			astar_node.AddPoint(calculate_point_index(cell),new Vector3(cell.x,cell.y,0),1);
		}
	}
	
	public int calculate_point_index(Vector2 point){
		int index = (int)((point.x+10000) + map_size.x * (point.y+10000)); 
		return index;
	}

	public void astar_connect_walkable_cells(Godot.Collections.Array points_array){
		foreach (Vector2 point in points_array){
			var point_index = calculate_point_index(point);
		
			Vector2[] points_relative = {
				point + new Vector2(0,1),
				point + new Vector2(0,-1),
				point + new Vector2(1,0),
				point + new Vector2(-1,0),
				point + new Vector2(1,1),
				point + new Vector2(-1,1),
				point + new Vector2(1,-1),
				point + new Vector2(-1,-1)
			};
			foreach (Vector2 point_relative in points_relative){
				var point_relative_index = calculate_point_index(point_relative);

				if ( !astar_node.HasPoint(point_relative_index)){
					continue;
				}
				astar_node.ConnectPoints(point_index, point_relative_index, false);
			}
		}
	}
	public void edit_astar_connection_weight(Vector2 cell, int weight){
		astar_node.AddPoint(calculate_point_index(cell),new Vector3(cell.x,cell.y,0),weight);
	}
	
	
	
	public Godot.Collections.Array calculate_path(Vector2 start_pos, Vector2 end_pos){

		start_pos = (GetNode(terrain_tile_map) as TileMap).WorldToMap(start_pos);
		end_pos = (GetNode(terrain_tile_map) as TileMap).WorldToMap(end_pos);


		var start_point_index = astar_node.GetClosestPoint(new Vector3(start_pos.x,start_pos.y,0));
		var end_point_index =astar_node.GetClosestPoint(new Vector3(end_pos.x,end_pos.y,0));



		var point_path_ids = astar_node.GetPointPath(start_point_index, end_point_index);

		Godot.Collections.Array point_path= new Godot.Collections.Array();
		foreach(Vector3 point in point_path_ids){
			
			point_path.Add((GetNode(terrain_tile_map) as TileMap).MapToWorld(new Vector2(point.x,point.y)));


		}
		return point_path	;
	}
}
