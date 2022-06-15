enum playerState {
	walk,
	sword,
	bow,
	pick,
	melee,
	range,
	fly,
}

function button_bow(){
	if !instance_exists(obj_player_weapon) {
		instance_create_layer(x,y,"Instances",obj_player_weapon);
	}
	if instance_exists(obj_player) obj_player.state = playerState.bow;
	if instance_exists(oPlayer) oPlayer.state = playerState.bow;
	obj_player_weapon.image_index=0;
}

function button_sword(){
	if !instance_exists(obj_player_weapon) {
		instance_create_layer(x,y,"Instances",obj_player_weapon);
	}
	if instance_exists(obj_player) obj_player.state = playerState.sword;
	if instance_exists(oPlayer) oPlayer.state = playerState.sword;
	obj_player_weapon.image_index=1;
}

function change_weapon(weapon_idx){
	switch (weapon_idx) {
	    case itemList.sword:
	        button_sword();
	        break;
	    case itemList.bow:
	        button_bow();
	        break;
	}
}

function button_close(){
	with obj_ReadMe {
		state_ = buttonstate.readme;
		global.show_readme=false;	
		instance_activate_layer("Instances");
	}
}

function button_open(){
	with obj_ReadMe {
		state_ = buttonstate.readme;
		global.show_readme=true;	
		instance_deactivate_layer("Instances");
	}
}

function button_whatisthis(){
	with obj_ReadMe {
		state_ = buttonstate.itemcollect;
		global.show_readme=true;	
		instance_deactivate_layer("Instances");
	}
}

function button_decline(){
	with obj_ReadMe {
		state_ = buttonstate.itemcollect;
		global.show_readme=false;	
		instance_activate_layer("Instances");
	}
}

function button_collect(){
	with obj_ReadMe {
		state_ = buttonstate.itemcollect;
		global.show_readme=false;	
		instance_activate_layer("Instances");
		with itemsearch_ {
			add_item(item_);
			instance_destroy();
		}
		
	}
}