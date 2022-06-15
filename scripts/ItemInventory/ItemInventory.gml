enum itemtype {
	common,
	button1,
	button2,
	heart,
	gems,
	effects,
}

function inventory_add(_item){
	switch (_item.whatbutton) {
	    case itemtype.button1:
			global.button1 = _item;
	        break;
	    case itemtype.button2:
			global.button2 = _item;
			var _itemname = _item.itemname;
			var dupnum_ = item_find(_itemname);
			if  dupnum_== -1 {
				array_push(global.inv,_item);
			} else {
				global.inv[dupnum_].qty++;

			}
	        break;
	    case itemtype.heart:
			//with  oPlayer {
			//	maxHP_++;
			//	HP_=maxHP_;
			//}
	        break;
	    case itemtype.gems:
			//with obj_game {
			//	gemsnum_ += _item.qty;	
			//}
	        break;
	    default:
			var _itemname = _item.itemname;
			var dupnum_ = item_find(_itemname);
			if  dupnum_== -1 {
				array_push(global.inv,_item);
			} else {
				global.inv[dupnum_].qty++;
			}
	        break;
	}
}

function item_find(_itemname){
	for (var i = 0; i < array_length(global.inv); ++i) {
	    if  _itemname == global.inv[i].itemname {
				return i;
		}
	}
	return -1;
}

function item_delete(_itemname) {
	for (var i = 0; i < array_length(global.inv); ++i) {
	    if  _itemname == global.inv[i].itemname {
			if global.inv[i].qty<=0 {
				return false;
			}
			global.inv[i].qty--;
			if global.inv[i].qty<=0 {
				global.button2 = -1;
			}
			return true;
		}
	}
	return false;	
}

function  item_set_button2(){
	global.button2 = global.inv[oItem_Inventory.selected_item_];
}

function  item_set_key(){
	var used_ = false;
	if instance_exists(oDoor) {
		with oDoor {
			if (distance_to_object(oPlayer) <= 20)   {
				instance_destroy();
				used_ = true;
			}
		}
	}
	
	if used_ {
		item_delete("Key");
		array_delete(global.inv, oItem_Inventory.selected_item_,1);
		oItem_Inventory.openInventory_ = false;
	}
}
function  item_set_none(){
	
}

function  item_set_sword(){
	
}
function  item_set_heart(){
	
}

function  item_set_potion(){
	//with oGameController {
	//	HP_+=3;
	//	if (HP_ >= maxHP_)   HP_=maxHP_;
	//}
	array_delete(global.inv, oItem_Inventory.selected_item_,1);
}
