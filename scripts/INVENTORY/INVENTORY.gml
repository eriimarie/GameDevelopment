/// add_item(item);
function add_item(item_list) {

	for(var ix = 0; ix < obj_game.num_slotsx; ix++)
	{
		for(var iy = 0; iy < obj_game.num_slotsy; iy++)
		{
			if(global.inventory[ix, iy] == itemList.empty)
			{
				global.inventory[ix, iy] = item_list;
				return(1);
			}
		}
	}
	return(0);
}

function find_item(item_list) {
	for(var ix = 0; ix < obj_game.num_slotsx; ix++)
	{
		for(var iy = 0; iy < obj_game.num_slotsy; iy++)
		{
			if(global.inventory[ix, iy] == item_list)
			{
				return true;
			}
		}
	}
	return false;
}

function delete_item(item_list) {
	for(var ix = 0; ix < obj_game.num_slotsx; ix++)
	{
		for(var iy = 0; iy < obj_game.num_slotsy; iy++)
		{
			if(global.inventory[ix, iy] == item_list)
			{
				global.inventory[ix, iy] = itemList.empty;
				return(1);
			}
		}
	}
	return(0);
}
