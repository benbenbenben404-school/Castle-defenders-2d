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
	public float speed = 20.0F;
	public bool agroToSoldiers;
	public bool agroToWalls;
	public float dectectionRadius;
	public float attack;
	public Line line;
	public WorldGenLines worldGenLines;
	// How far offset from the center line  should zombie be
	public float width_ratio;
	Random r = new Random();
	public override void _Ready()
	{


		speed = (float)new decimal(r.NextDouble())*2+1;
		width_ratio = (float)new decimal(r.NextDouble())*2-1;

		vel = (line.start_pos-line.end_pos).Normalized();
		perp_vel = new Vector2(vel.y,-vel.x);
	}

	public void tick(){
		float dist_on_line=worldGenLines.distance_on_line(line,Position);
		if (dist_on_line >0.99){
			line = worldGenLines.get_parent_lines(line)[r.Next(worldGenLines.get_parent_lines(line).Count)];
			vel = (line.start_pos-line.end_pos).Normalized();
			
			Rotation = vel.Angle();
			perp_vel = new Vector2(vel.y,-vel.x);
		} 
		var closest_point_on_line=worldGenLines.get_closest_point_on_line(line, Position);
		
		Position = closest_point_on_line +vel*speed+get_width_offset(line);
		
	}
	
	public Vector2 get_width_offset(Line line){
		var width_at_point = worldGenLines.get_width(line,Position);
		var width_offset = width_at_point*width_ratio;

		return width_offset*perp_vel;
	}
}
