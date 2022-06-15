// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function attack_none(){

}

function attack_bubble(){
	if ctr_ >= room_speed * 0.5 {
		image_index=0;
		ctr_ = 0;
		state_ = enemyState.ready;
		var slashInst_ = instance_create_layer(x,y,"Instances",oBubble);
		with slashInst_ {
			direction=other.direction;
		}
	} 
}

function attack_bullet(_x,_y){
	image_index=0;
	ctr_ = 0;
	var slashInst_ = instance_create_layer(x + _x,y + _y,"Instances",oBullet1);
	with slashInst_ {
		direction = point_direction(x,y,oPlayer.x,oPlayer.y);
	}
}

function attack_tripplebullet(){
	ctr_ = 0;
	state_ = enemyState.ready;
	var _target    = target_;
	var dir_       = point_direction(x,y,_target.x,_target.y);
	var slashInst_ = instance_create_layer(x,y,"Instances",oBullet1);
	with slashInst_ {
		direction=dir_-10;
	}
	var slashInst1_ = instance_create_layer(x,y,"Instances",oBullet1);
	with slashInst1_ {
		direction=dir_;
	}
	var slashInst2_ = instance_create_layer(x,y,"Instances",oBullet1);
	with slashInst2_ {
		direction=dir_+10;
	}
}