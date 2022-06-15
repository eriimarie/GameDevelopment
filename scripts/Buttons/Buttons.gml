enum buttonType {
	x_,
	y_,
	bgSprite,
	amount,
	useScript,
}

function button_declare(array_,_x,_y,_sprite,_amount,_script) {
	ctrButton_++;
	button_def[array_,buttonType.x_]             = _x;
	button_def[array_,buttonType.y_]             = _y;
	button_def[array_,buttonType.bgSprite]       = _sprite;
	button_def[array_,buttonType.amount]         = _amount;
	button_def[array_,buttonType.useScript]      = _script;
	var size_		= 3;
	var spriteW_	= sprite_get_width(button_def[array_,buttonType.bgSprite]) * size_;
	var spriteH_	= sprite_get_height(button_def[array_,buttonType.bgSprite]) * size_;
	menux1_[array_] = button_def[array_,buttonType.x_];
	menuy1_[array_] = button_def[array_,buttonType.y_];
	menux2_[array_] = menux1_[array_] + spriteW_;
	menuy2_[array_] = menuy1_[array_] + spriteH_;
}

function button_draw_gui(_index) {
	draw_sprite_ext(button_def[_index,buttonType.bgSprite], _index, menux1_[_index],menuy1_[_index],3,3,0,c_white,1);
}

function button_left_click(_index, arg_) {
	for (var i = 0; i < ctrButton_; ++i) {
		var hover_button = (mouseX >= menux1_[i]) && (mouseX <= menux2_[i]) && (mouseY >= menuy1_[i]) && (mouseY <= menuy2_[i]);
		if (hover_button) and (_index == i){
			var _itemScript = button_def[i,buttonType.useScript];
			script_execute(_itemScript,i,arg_);
			return true;
		}
	}
}

function button_left_check() {
	var mouseX = device_mouse_x_to_gui(0);
	var mouseY = device_mouse_y_to_gui(0);
	
	for(var ix = 0; ix < num_slotsx; ix++)
	{
		for(var iy = 0; iy < num_slotsy; iy++)
		{
			var xx1 = inv_posx + ix * slot_sizex;
			var yy1 = inv_posy + iy * slot_sizey;
			var xx2 = inv_posx + (1 + ix) * slot_sizex;
			var yy2 = inv_posy + (1 + iy) * slot_sizey;
			var hover_button = (mouseX >= xx1) && (mouseX <= xx2) && (mouseY >= yy1) && (mouseY <=yy2);
			if (global.inventory[ix, iy] != itemList.empty) and (hover_button){
				return (global.inventory[ix, iy]);
			}
		}
	}
	return -1;
}