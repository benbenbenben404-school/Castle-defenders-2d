using Godot;
using System;
using System.Collections;
using System.Collections.Generic;
using static Godot.GD;


public class WorldGenLines:Resource {
	public struct  Line {
		public Vector2 start_pos;
		public Vector2 end_pos;
		public int depth;
		public float start_width;
		public float end_width;
		public int position_in_level;
		public int line_index;
		public Line(Vector2 start_pos, Vector2 end_pos,int depth,float start_width,float end_width,int position_in_level,int line_index)
		{
			this.line_index=line_index;
			this.start_pos = start_pos;
			this.end_pos= end_pos;
			this.depth = depth;
			this.start_width=start_width;
			this.end_width=end_width;
			this.position_in_level= position_in_level;
		}
	};
	public struct  Point {
		public Vector2 position;
		public int depth;
		public int position_in_level;
		public float width;
		public Point(Vector2 position, int depth,int position_in_level,float width)
		{
			this.position = position;
			this.position_in_level= position_in_level;
			this.width = width;
			this.depth=depth;
		}
	};
	public static int tree_depth =7;
	public List<Line> lines=new List<Line>();
	static int num_of_points= (tree_depth+1)*(tree_depth+2)/2;
	public List<Point> points = new List<Point>();
	public List<Point> end_points = new List<Point>();
	public List<Line> end_lines = new List<Line>();
	public List<int> line_map = new List<int>();
		

	Vector2 root_pos = new Vector2(0,0);

	static int TILE_SIZE = 24;

	[Export]
	int node_sepration_vertical =30;

	[Export]
	int node_sepration_horizontal =32;

	int random_factor=200;
	float connection_threshold=0.7F;
	float width_mutliplier =7.0F;
	float width_range = 0.4F;
	int start_pos;
	int end_pos;
	int angle;
	int length;


	public WorldGenLines() {

	
		GD.Print(tree_depth);
		GD.Randomize();
		//GD.Seed((ulong)99);
		//Generate the points
		for (int level=0; level<tree_depth+1; level++){

			float node_y = level *node_sepration_vertical*TILE_SIZE;
			foreach(int i in GD.Range(level+1)){
				float width =(float) GD.RandRange(width_range*width_mutliplier*TILE_SIZE,width_mutliplier*TILE_SIZE);
				float node_x = (float)((-level/2.0 *node_sepration_horizontal+i*node_sepration_horizontal)*TILE_SIZE);
				Vector2 node_pos = new Vector2(node_x,node_y)+new Vector2(random_factor,random_factor)*(GD.Randf()-0.5F);
				Point new_point = new Point(node_pos,level,i,width);
				//GD.Print(points.IsFixedSize);

				points.Add(new_point);
				if (level == tree_depth) {
					end_points.Add(new_point);
				}
			}		
		}

		foreach (int level in GD.Range(tree_depth-0)){
			foreach (int node in GD.Range(level+1)){
				var point_index = level*(level+1)/2+node;
				
				var start_point = (Point)(points[point_index]);
				var end_point = (Point)points[point_index+level+1];
				
				var start_pos=start_point.position;
				var end_pos=end_point.position;
				var start_width = start_point.width;
				var end_width = end_point.width;
				
				var leftLineIndex = point_index;
				var leftLine =  new Line(start_pos,end_pos,level,start_width,end_width,end_point.position_in_level,leftLineIndex);
				lines.Add(leftLine);
				line_map.Add(leftLineIndex);
				

				end_point = (Point)points[point_index+level+2];
				end_pos=end_point.position;
				end_width = end_point.width;
				var righgtLineIndex = point_index+1;
				var rightLine = new Line(start_pos,end_pos,level,start_width,end_width,end_point.position_in_level,righgtLineIndex);
				lines.Add(rightLine);
				line_map.Add(righgtLineIndex);
				if (level == tree_depth-1) {
					end_lines.Add(leftLine);
					end_lines.Add(rightLine);
				}
			}
		}
		ArrayList endpoints=new ArrayList();
		ArrayList linesRemove=new ArrayList();


		foreach (Line line in lines){
			if (!(endpoints.Contains( line.end_pos)) && GD.Randf() > connection_threshold &&line.position_in_level!=0 &&line.position_in_level!=line.depth+1){
				endpoints.Add(line.end_pos);
				linesRemove.Add(line);
				
			} 
		}
		foreach (Line line in linesRemove){
				line_map.Remove(lines.IndexOf(line));
				lines.Remove(line);
				
			
		}
	}
	public float Distance(Vector2 start,Vector2 end,Vector2 point){
		var A = point.x - start.x;
		var B = point.y - start.y;
		var C = end.x - start.x;
		var D = end.y - start.y;

		var len_sq = C * C + D * D;
		var param = -1.0;
		if (len_sq != 0){
			var dot = A * C + B * D;
			param = dot / len_sq;
		}
		float xx;
		float yy;

		if (param < 0) {
			xx = start.x;
			yy = start.y;
		}
		else if (param > 1){
			xx = end.x;
			yy = end.y;
		}
		else {
			xx = (float)(start.x + param * C);
			yy = (float)(start.y + param * D);
		}

		var dx = point.x - xx;
		var dy = point.y - yy;
		return Mathf.Sqrt(dx * dx + dy * dy);
	}
	public float distance_to_lines(Vector2 point){
		float distance = 10000000000.0F;
		float distance_to_line = 100000.0F;

		foreach (Line line in lines){
			var start = line.start_pos;
			var end = line.end_pos;
			distance_to_line = Distance(start,end,point);
			distance = Mathf.Min(distance,distance_to_line);
		}
		return distance;
	}
	public Line get_closest_line(Vector2 point){
		float distance = 10000000000.0F;
		float distance_to_line = 1000.0F;
		Line closest =(Line)lines[0];
		foreach ( Line line in lines){
			var start = line.start_pos;
			var end = line.end_pos;
			distance_to_line = Distance(start,end,point);
			if (distance_to_line < distance){
				distance=distance_to_line;
				closest = line;
			}
		}

		return closest;
	}
	//borrowed from stack overflow
	public  Vector2 GetClosestPointOnLineSegment(Vector2 start, Vector2 end, Vector2 point){
		var A = point.x - start.x;
		var B = point.y - start.y;
		var C = end.x - start.x;
		var D = end.y - start.y;

		var len_sq = C * C + D * D;
		var param = -1.0;
		if (len_sq != 0){
			var dot = A * C + B * D;
			param = dot / len_sq;
		}
		float xx;
		float yy;

		if (param < 0) {
			xx = start.x;
			yy = start.y;
		}
		else if (param > 1){
			xx = end.x;
			yy = end.y;
		}
		else {
			xx = (float)(start.x + param * C);
			yy = (float)(start.y + param * D);
		}

		return new Vector2(xx,yy);
	}
	
	public Vector2 get_closest_point_on_line(Line current_line, Vector2 point){
		Vector2 start_point= current_line.start_pos;
		Vector2 end_point= current_line.end_pos;
		return GetClosestPointOnLineSegment(start_point,end_point,point);
	}
	public float distance_on_line(Line current_line, Vector2 point){
		//returns how far through a line a point is, with 1.0 being at the top of the line and 0.0 being the bottom
		Vector2 start_point= current_line.start_pos;
		Vector2 end_point= current_line.end_pos;
		Vector2 closest_point = GetClosestPointOnLineSegment(start_point,end_point,point);
		float start_dist = closest_point.DistanceTo(end_point)+0;

		float total_dist= end_point.DistanceTo(start_point)+0;
		
		return start_dist/total_dist;
	}
	
	public float get_width_point(Vector2 point){
		Line current_line =get_closest_line(point);
		float width = get_width(current_line,point);
		return width;
		
	}
	
	
	public float get_width(Line current_line, Vector2 point){
	
		
		Vector2 start_point= current_line.start_pos;
		Vector2 end_point= current_line.end_pos;
		Vector2 closest_point = GetClosestPointOnLineSegment(start_point,end_point,point);
		float start_dist = closest_point.DistanceTo(start_point)+0;
		float end_dist = closest_point.DistanceTo(end_point)+0;
		float total_dist= end_point.DistanceTo(start_point)+0;
		//GD.Print(start_dist);
		//GD.Print(end_dist);
		//GD.Print(total_dist);

		float width = (1-start_dist/total_dist)*current_line.start_width+(1-end_dist/total_dist)*current_line.end_width;
		//GD.Print(width);
		//GD.Print("");
		return width;
	} 
	public List<Point> get_end_points(){
		return end_points;
	}
	public List<Line> get_end_lines(){
		return end_lines;
	}
	
	public List<Line>  get_parent_lines(Line line){
		GD.Print(lines.Count);
		GD.Print(line_map.Count);
		int line_index = line.line_index;
		int level = line.depth;
		int node = line.position_in_level;
		int leftParentIndex = line_map.IndexOf(line_index-level+node*2);
		int rightParentIndex = line_map.IndexOf(line_index-level+node*2+1);
		var parentLines = new List<Line>();
		if (leftParentIndex !=-1){
			parentLines.Add(lines[leftParentIndex]);
		}
		if (rightParentIndex !=-1){
			parentLines.Add(lines[rightParentIndex]);
		}
		return parentLines;
	}
}

