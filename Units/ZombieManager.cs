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
	public override void _Ready()
	{
		for (int i=0; i<10000; i++)
		createNewZombie();
	}
	public override void _PhysicsProcess(float delta) {
		iterateZombies ();
		
	}
	
	public void iterateZombies (){
		for(int zomb_index =0 ;zomb_index < zombieList.Count; zomb_index++) {
			zombieList[zomb_index].tick();
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

		zombieList.Add(zomb);
		((Node2D)zomb).Position = zomb.pos;
		AddChild(zomb);
	}
}
