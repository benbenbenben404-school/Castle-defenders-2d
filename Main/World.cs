using Godot;
using System;
using System.Threading;
using static Godot.GD;
using static WorldGenLines;
public class World : Node2D
{
	
	public  struct ChunkInfo {
		public Vector2 chunkpos;
		public Vector2 chunksize;

	}
	[Export]
	private WorldGenLines worldGenLines;
	[Export]
	private Vector2 mapSize;
	private TileMap grassTileMap ;
	public override void _Ready() {
		//WorldGenLines worldGenLines =new WorldGenLines();
		GD.Print("REady");
		int minWorker,maxWorker,a;
		GD.Print("REady");
		ThreadPool.GetAvailableThreads(out minWorker,out a);
		ThreadPool.GetMaxThreads(out maxWorker,out a);
		GD.Print(minWorker);
		GD.Print(maxWorker);
		ThreadPool.SetMaxThreads(150,150);
		grassTileMap=GetNode<TileMap>("Grass");

		for (int x=0; x<mapSize.x;x++){
			for (int y=0; y<mapSize.y;y++){

				var chunk_info = new ChunkInfo();
				chunk_info.chunkpos= new Vector2(x,y);
				chunk_info.chunksize= new Vector2(50,50);
				//ThreadPool.QueueUserWorkItem(gen_chunk,  chunk_info);
				gen_chunk(chunk_info);

			}
		}
	}
	public void gen_chunk(object args){
		Vector2 chunk_pos = ((ChunkInfo)args).chunkpos;
		Vector2 chunk_size = ((ChunkInfo)args).chunksize;
		for (int x=0; x<chunk_size.x;x++){
			for (int y=0; y<chunk_size.y;y++){
				var tile = new Vector2(chunk_pos.x*chunk_size.x+x-350,chunk_pos.y*chunk_size.y+y);
				//GD.Print(tile);
				var world_pos=grassTileMap.MapToWorld(tile);
				if (worldGenLines.distance_to_lines(world_pos)<worldGenLines.get_width_point(world_pos)){
					grassTileMap.SetCellv(tile,0);
				}

			}
		}
		
		
	}
//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {

}
