using Godot;
using System;
using static Godot.GD;
using static WorldGenLines;
using System.Collections;
using System.Collections.Generic;
public class ZombieManager : Node2D
{

	public PackedScene zombieNodePath = (PackedScene)Load("res://Units/Zombie.tscn");
	public List<Zombie> zombieList=new List<Zombie>();
	Random random = new Random();
	[Export]
	private WorldGenLines worldGenLines;
	Physics2DShapeQueryParameters wall_query;
	Physics2DDirectSpaceState space;
	CircleShape2D shape;
	public override void _Ready(){		
		space = GetWorld2d().DirectSpaceState;
		wall_query = new Physics2DShapeQueryParameters();
		shape = new CircleShape2D();
		shape.Radius=48;
		wall_query.SetShape(shape);
		wall_query.Transform = new Transform2D(0,new Vector2());
		wall_query.CollisionLayer = 0b100;
		
		for (int i=0; i<1000; i++) {
			createNewZombie();
		}

	}
	public override void _PhysicsProcess(float delta) {
		iterateZombies (delta);
		
	}
	
	public void iterateZombies (float delta){
		
		for(int i =0 ;i < zombieList.Count; i++) {
			zombieList[i].tick(delta);

		}
	
	}
	public void createNewZombie(){
		var zomb = (Zombie)zombieNodePath.Instance();
		var end_lines = worldGenLines.get_end_lines();
		Line line = end_lines[random.Next(end_lines.Count)];
		zomb.pos = line.end_pos;
		zomb.line = line;
		zomb.vel = new Vector2(1,2);
		zomb.worldGenLines = worldGenLines;
		zomb.wall_query = wall_query;
		zomb.space = space ;
		zomb.shape = shape ;

		zombieList.Add(zomb);
		((Node2D)zomb).Position = zomb.pos;
		AddChild(zomb);
	}
}
