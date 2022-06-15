#region neural network functions

function f_activate(argument0, argument1) {
	return argument0>argument1
}

/// @func nn_add_neuron(id)
function nn_add_neuron(argument0) {
	var list=argument0, l=ds_list_create();

	repeat(list[| 0])
	{
	    ds_list_add(l, 0) // set wight for new neuron
	}

	ds_list_add(list, l)
}

/// @unc nn_create(input_layer_size)
function nn_create(argument0) {
	var list=ds_list_create();
	ds_list_add(list, argument0)
	return list;
}

/// @func nn_destroy(nn)
function nn_destroy(argument0) {
	for(var i=1; i<ds_list_size(argument0); i++)
	{
	    ds_list_destroy(argument0[| i])
	}
	ds_list_destroy(argument0)
}

/// @func nn_get_neuron_number(nn)
function nn_get_neuron_number(argument0) {
	return ds_list_size(argument0)-1
}
	
/// @func nn_get_output(id, list_input)
function nn_get_output(argument0, argument1) {
	// return list of output
	var i, j, l, output=ds_list_create(), list=argument0, input=argument1;

	for(i=0; i<ds_list_size(list)-1; i++)
	{
	    l=list[| i+1]
    
	    output[| i]=0
	    for(j=0; j<ds_list_size(l); j++)
	    {
	        output[| i]+=l[| j]*input[| j]
	    }
	    output[| i]=f_activate(output[| i], ds_list_size(list)-1)
	}

	return output;
}

/// @func nn_train(id, list_input, list_output)
function nn_train(argument0, argument1, argument2) {
	var output, input=argument1, output_need=argument2, list=argument0, i, j, l, E=0;

	output=nn_get_output(list, input)

	for(i=0; i<ds_list_size(list)-1; i++)
	{
	    l=list[| i+1]
	    E+=abs(output[| i]-output_need[| i])
	    for(j=0; j<ds_list_size(l); j++)
	    {
	        l[| j]+=(output_need[| i]-output[| i])*input[| j]
	    }
	}

	return E
}
	
/// @func  nn_train_train(id, train_id, repeats, error_limit)
function nn_train_train(argument0, argument1, argument2, argument3) {

	var network=argument0, train=argument1, i, E, w=ds_grid_width(train), repeats=0, time;

	show_debug_message("Train started...")
	time=get_timer()
	asdad=argument3
	repeat argument2
	{
	    E=0
	    for(i=0; i<w; i++)
	    {
	        E+=nn_train(network, train[# i, 0], train[# i, 1])
	    }
	    repeats++
	    if E<argument3 break
	}
	show_debug_message("Train completed. Repeats: "+string(repeats)+"; error: "+string(E)+"; time: "+string((get_timer()-time)/1000)+"/1000 sec")

	//  If neural network return too big error, try add some neurons
}
	
#endregion

#region neural network wrapper
function neural_network(input_layer_size) constructor {
	if (input_layer_size == undefined)
		input_layer_size = 0;
		
	nn = nn_create(input_layer_size);
	
	function add_neuron() {
		return nn_add_neuron(nn);
	}
	
	function destroy() {
		return nn_destroy(nn);
	}
	
	function get_neuron_number() {
		return nn_get_neuron_number(nn);
	}
	
	function get_input_number() {
		return nn[| 0];
	}
	
	function get_output(list_input) {
		return nn_get_output(nn, list_input);
	}
	
	function train(list_input, list_output) {
		return nn_train(nn, list_input, list_output);
	}
	
	function train_template(train, repeats, error_limit) {
		if (is_struct(train)) {
			train = train.train;
		}
		
		return nn_train_train(nn, train, repeats, error_limit);
	}
	
	function save_to_buffer() {
		var b = buffer_create(64, buffer_grow, 1);
		buffer_seek(b, buffer_seek_start, 0);
		buffer_write(b, buffer_u32, nn[| 0]);
		buffer_write(b, buffer_u32, ds_list_size(nn) - 1);
		for(var i = 1; i < ds_list_size(nn); i++) {
			var neuron = nn[| i];
			for(var j = 0; j < ds_list_size(neuron); j++) {
				buffer_write(b, buffer_f32, neuron[| j]);
			}
		}
		
		return b;
	}
	
	function load_from_buffer(buffer) {
		destroy();
		
		buffer_seek(buffer, buffer_seek_start, 0);
		var input_n = buffer_read(buffer, buffer_u32);
		var output_n = buffer_read(buffer, buffer_u32);
		
		nn = nn_create(input_n);
		repeat (output_n) 
			add_neuron();
			
		for(var i = 1; i < ds_list_size(nn); i++) {
			var neuron = nn[| i];
			for(var j = 0; j < ds_list_size(neuron); j++) {
				neuron[| j] = buffer_read(buffer, buffer_f32);
			}
		}
	}
		
	function save_to_file(fname) {
		var b = save_to_buffer();
		buffer_save(b, fname);
		buffer_delete(b);
	}
	
	function load_from_file(fname) {
		if (!file_exists(fname)) {
			show_debug_message("cannot find file `" + string(fname) + "` to load neural network");
			return false;
		}
		
		var b = buffer_load(fname);
		if (!buffer_exists(b)) {
			show_debug_message("file `" + string(fname) + "` is not a neural network");
			return false;
		}
		
		load_from_buffer(b);
		buffer_delete(b);
		
		return true;
	}
}
#endregion

#region neural network train functions

function train_add_input() {

	var train=argument[0], l=ds_list_create(), i, w=ds_grid_width(train);

	for(i=1; i<argument_count; i++)
	{
	    ds_list_add(l, argument[i])
	}

	ds_grid_resize(train, w+1, 2)
	train[# w, 0]=l
}

/// @func train_add_input_list(id, val)
function train_add_input_list(argument0, argument1) {

	var train=argument0, l=argument1, i, w=ds_grid_width(train);

	ds_grid_resize(train, w+1, 2)
	train[# w, 0]=l
}

/// @func train_add_output([values])
function train_add_output() {

	var train=argument[0], l=ds_list_create(), i, w=ds_grid_width(train);

	for(i=1; i<argument_count; i++)
	{
	    ds_list_add(l, argument[i])
	}

	train[# w-1, 1]=l
}

/// @func train_add_output_list(id, val)
function train_add_output_list(argument0, argument1) {
	var train=argument0, l=argument1, i, w=ds_grid_width(train);

	train[# w-1, 1]=l
}

function train_create() {
	// return id of train
	return ds_grid_create(0, 0)
}

/// @func train_destroy(id)
function train_destroy(argument0) {
	for(var i=0; i<ds_grid_width(argument0); i++)
	{
	    ds_list_destroy(argument0[# i, 0])
	    ds_list_destroy(argument0[# i, 1])
	}

	ds_grid_destroy(argument0)
}

/// @func train_update(id, output_n)
function train_update(argument0, argument1) {
	var l;
	for(i=0; i<ds_grid_width(argument0); i++)
	{
	    l=argument0[# i, 1]
	    repeat(argument1-ds_list_size(l))
	        ds_list_add(l, 0)
	}
}

#endregion

