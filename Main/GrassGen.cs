using Godot;
using System;
using System.Threading;
using static Godot.GD;
using static WorldGenLines;
//using System.Collections;
public class GrassGen : TileMap
{
	
	public  struct ChunkInfo {
		public Vector2 chunkpos;
		public Vector2 chunksize;

	}
	//private ArrayList grass_tiles = new ArrayList();
	[Export]
	private WorldGenLines worldGenLines;
	[Export]
	private Vector2 mapSize;
	private TileMap grassTileMap ;
	public override void _Ready() {
		gen_world(); 
	}
	public void gen_world(){
		Vector2 chunk_offset = new Vector2(mapSize.x*50/2,50);

		for (int x=0; x<mapSize.x;x++){
			for (int y=0; y<mapSize.y;y++){

				

				gen_chunk(new Vector2(x,y),new Vector2(50,50),chunk_offset);

			}
		}
		//GD.Print(grass_tiles);
		//while (ThreadPool.PendingWorkItemCount!=0) 
		//{
		  // code block to be executed

		
		
		
	}
	public void gen_chunk(Vector2 chunk_pos,Vector2 chunk_size,Vector2 chunk_offset){
		GD.Print("start");

		for (int x=0; x<chunk_size.x;x++){
			for (int y=0; y<chunk_size.y;y++){
				var tile = new Vector2(chunk_pos.x*chunk_size.x+x-chunk_offset.x,chunk_pos.y*chunk_size.y+y-chunk_offset.y);
				//GD.Print(tile);
				var world_pos=MapToWorld(tile);
				
				//SetCellv(tile,0);
				//grass_tiles.Add(tile);
				if (worldGenLines.distance_to_lines(world_pos)<worldGenLines.get_width(world_pos)){
				
					SetCellv(tile,1);
				}

			}
		}
		
		
	}
//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {

}
