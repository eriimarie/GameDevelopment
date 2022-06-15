
function check_collision(Collision){
	if(place_meeting(x, y, Collision)) {
		for(var i = 0; i < 1000; ++i) {
			//Right
			if(!place_meeting(x + i, y, Collision)) {
				x += i;
				break;
			}
			//Left
			if(!place_meeting(x - i, y, Collision)) {
				x -= i;
				break;
			}
			//Up
			if(!place_meeting(x, y - i, Collision)) {
				y -= i;
				break;
			}
			//Down
			if(!place_meeting(x, y + i, Collision)) {
				y += i;
				break;
			}
			//Top Right
			if(!place_meeting(x + i, y - i, Collision)) {
				x += i;
				y -= i;
				break;
			}
			//Top Left
			if(!place_meeting(x - i, y - i, Collision)) {
				x -= i;
				y -= i;
				break;
			}
			//Bottom Right
			if(!place_meeting(x + i, y + i, Collision)) {
				x += i;
				y += i;
				break;
			}
			//Bottom Left
			if(!place_meeting(x - i, y + i, Collision)) {
				x -= i;
				y += i;
				break;
			}
		}
	}	
}


function what_tile(_x, _y,_layer){
	var _tm = layer_tilemap_get_id(_layer);
	return tile_get_index(tilemap_get(_tm, _x, _y)) ;
}


function tile_meeting(x_,y_,_layer){

	var _tm = layer_tilemap_get_id(_layer);

	var _x1 = tilemap_get_cell_x_at_pixel(_tm, bbox_left + (x_ - x), y),
	    _y1 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_top + (y_ - y)),
	    _x2 = tilemap_get_cell_x_at_pixel(_tm, bbox_right + (x_ - x), y),
	    _y2 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_bottom + (y_ - y));

	for(var _x = _x1; _x <= _x2; _x++){
	 for(var _y = _y1; _y <= _y2; _y++){
	    if(tile_get_index(tilemap_get(_tm, _x, _y))){
	    return true;
	    }
	 }
	}
	return false;
}

function is_colliding_on_tile(tiles){
	//Right Collision
	var left_collision_   = tilemap_get_at_pixel(tiles, bbox_left + x_speed_, y) <= 0;
	var right_collision_  = tilemap_get_at_pixel(tiles, bbox_right + x_speed_, y) <= 0;
	var top_collision_    = tilemap_get_at_pixel(tiles, x, bbox_top + y_speed_) <= 0;
	var bottom_collision_ = tilemap_get_at_pixel(tiles, x, bbox_bottom + y_speed_) <= 0;
	if (left_collision_ and  right_collision_){
		x += x_speed_;
		while(tilemap_get_at_pixel(tiles, x, bbox_top) > 0) {
			y+=1;
		}
		while(tilemap_get_at_pixel(tiles, x, bbox_bottom) > 0) {
			y-=1;
		}
	}
	if (top_collision_ and  bottom_collision_){
		y += y_speed_;
		while(tilemap_get_at_pixel(tiles, bbox_right, y) > 0) {
			x-=1;
		}	
		while(tilemap_get_at_pixel(tiles, bbox_left, y) > 0) {
			x+=1;
		}
	}
}
