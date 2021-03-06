using Godot;
using System;
using System.Collections;
using static WorldGenLines;
public class linestest : Node2D
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	[Export]
	private WorldGenLines worldGenLines;
	[Export]
	private bool display_width;
	static int TILE_SIZE=24;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var LineScene =(PackedScene) GD.Load("res://Testing/line.tscn");
//		foreach(Point point in worldGenLines.points){
//			GD.Print(point);
//			var linescene = LineScene.instance();
//			linescene.points =new Vector2[lines.points[point]["position"],lines.points[point]["position"]+Vector2(10,0)];
//			linescene.default_color = Color.from_hsv(1.0*lines.points[point]["depth"]/lines.tree_depth,1.0,1.0);
//			add_child(linescene);
//		}
		foreach(Line line in worldGenLines.lines){


			var linescene = (Line2D)LineScene.Instance();
			linescene.Points =new Vector2[2]{line.start_pos,line.end_pos};
			linescene.DefaultColor = Color.FromHsv(1.0F*line.depth/WorldGenLines.tree_depth,1.0F,1.0F);
			if (display_width){
				if (line.start_width>line.end_width){
					linescene.Width = line.start_width;
					linescene.WidthCurve.SetPointValue(1,1);
					linescene.WidthCurve.SetPointValue(0,line.end_width/line.start_width);
				} else {
					linescene.Width = line.end_width;
					linescene.WidthCurve.SetPointValue(1,line.start_width/line.end_width);
					linescene.WidthCurve.SetPointValue(0,1);
				}
				linescene.Width=linescene.Width*(float)(Math.Sqrt(TILE_SIZE*TILE_SIZE+TILE_SIZE*TILE_SIZE)/TILE_SIZE);
			} else {
				linescene.Width = 5;
			}
			AddChild(linescene);
			}
	}

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
