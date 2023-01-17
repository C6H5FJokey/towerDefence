tool
extends Resource
class_name MapConfig

var wave_set := []

func _get_property_list():
	var properties := [
		{
			name="wave_set",
			type=TYPE_ARRAY,
			usage=PROPERTY_USAGE_STORAGE
		},
		{
			name="wave_set_size",
			type=TYPE_INT,
			usage=PROPERTY_USAGE_EDITOR
		},
	]
	for i in wave_set.size():
		var wave_data = wave_set[i]
		properties.append({
				name="wave/"+str(i)+"/fund",
				type=TYPE_INT,
				usage=PROPERTY_USAGE_EDITOR
			})
		properties.append({
				name="wave/"+str(i)+"/size",
				type=TYPE_INT,
				usage=PROPERTY_USAGE_EDITOR
			});
		for j in wave_data.enemies.size():
			properties.append({
					name="wave/"+str(i)+"/"+str(j),
					type=TYPE_DICTIONARY,
					usage=PROPERTY_USAGE_EDITOR
			})
	
	return properties


func _get(property):
	if property == "wave_set_size":
		return wave_set.size()
	if property.begins_with("wave/"):
		property = property.trim_prefix("wave/")
		if property.ends_with("/fund"):
			property = property.trim_suffix("/fund")
			return wave_set[int(property)].fund
		elif property.ends_with("/size"):
			property = property.trim_suffix("/size")
			return wave_set[int(property)].enemies.size()
		else:
			property = property.split("/")
			var pos = [int(property[0]),int(property[1])]
			return wave_set[pos[0]].enemies[pos[1]]
	return null


func _set(property, value):
	if property == "wave_set_size":
		var wave_set_size = wave_set.size()
		if wave_set_size > value:
			for i in wave_set_size-value:
				wave_set.pop_back()
		elif wave_set_size < value:
			for i in value-wave_set_size:
				wave_set.push_back({
					fund=-1,
					enemies=[]
				})
		emit_changed()
		property_list_changed_notify()
		return true
	if property.begins_with("wave/"):
		property = property.trim_prefix("wave/")
		if property.ends_with("/fund"):
			property = property.trim_suffix("/fund")
			property = int(property)
			wave_set[property].fund = value
			emit_changed()
			return true
		elif property.ends_with("/size"):
			property = property.trim_suffix("/size")
			property = int(property)
			var wave_size = wave_set[property].enemies.size()
			if wave_size > value:
				for i in wave_size-value:
					wave_set[property].enemies.pop_back()
			elif wave_size < value:
				for i in value-wave_size:
					var enemy := {
						name="",
						path_ind=0,
						wait_time=0.5}
					wave_set[property].enemies.push_back(enemy)
			emit_changed()
			property_list_changed_notify()
			return true
		else:
			property = property.split("/")
			var pos = [int(property[0]),int(property[1])]
			wave_set[pos[0]].enemies[pos[1]] = value
			emit_changed()
			return true
	return false
