using Godot;
using System;
using static Godot.GD;
using static WorldGenLines;
using System.Collections;
using System.Collections.Generic;
public class Zombie : Node2D
{
  	public Vector2 pos;
	public Vector2 vel;
	public Vector2 perp_vel;
	public float health;
	public float speed = 2000.0F;
	public bool agroToSoldiers;
	public bool agroToWalls;
	public float dectectionRadius;
	public float attack;
	public Line line;
	public WorldGenLines worldGenLines;
	// How far offset from the center line  should zombie be
	public float width_ratio;
	Random r = new Random();
	int tick_no = 0;
	int tick_frame = 20;
	float time_since_frame = 0F;
	float dist_on_line=0.5F;
	public Physics2DShapeQueryParameters wall_query;
	public Physics2DDirectSpaceState space;
	public CircleShape2D shape;
	public override void _Ready()
	{


		speed = (float)new decimal(r.NextDouble())*75+20;
		width_ratio = (float)new decimal(r.NextDouble())*2-1;
		tick_no = r.Next(0,5);
		vel = (line.start_pos-line.end_pos).Normalized();
		perp_vel = new Vector2(vel.y,-vel.x);
	}

	public void tick(float delta){
		tick_no+=1;
		time_since_frame+=delta;
		if (tick_no%tick_frame== 0){

			dist_on_line=worldGenLines.distance_on_line(line,Position);
			check_walls();

		}


		if (dist_on_line >0.99){

			if (line.left_parent_index !=-1 &&line.right_parent_index!=-1){
				line = worldGenLines.get_parent_lines(line)[r.Next(worldGenLines.get_parent_lines(line).Count)];
			} else if (line.left_parent_index !=-1 || line.right_parent_index!=-1){
				line = worldGenLines.get_parent_lines(line)[0];
			}

			vel = (line.start_pos-line.end_pos).Normalized();
			
			Rotation = vel.Angle();
			perp_vel = new Vector2(vel.y,-vel.x);
			dist_on_line=0.0F;
		} 
		var closest_point_on_line=worldGenLines.get_closest_point_on_line(line, Position);
		Vector2 desired_pos = closest_point_on_line +vel*1.0F+get_width_offset(line);
		Position = (desired_pos-Position).Normalized() *speed*time_since_frame+Position;
		time_since_frame=0F;
	}
	public bool check_walls(){
		

		wall_query.Transform =new Transform2D(0,Position);
		var wall_collide = space.IntersectShape(wall_query);


		if (wall_collide.Count ==0 ){
			return true;
		} else{
			GD.Print("collide");
			return false;
		}
		
	}
	public Vector2 get_width_offset(Line line){
		var width_at_point = worldGenLines.get_width(line,Position);
		var width_offset = width_at_point*width_ratio*0.8F;

		return width_offset*perp_vel;
	}
}
