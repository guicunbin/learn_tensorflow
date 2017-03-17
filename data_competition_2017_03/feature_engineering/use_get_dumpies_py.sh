#please ensure the old_table don't have chinese
python get_dumpies.py \
    --db_name tianchi_2017_03_v3 \
	--old_table_name gui_train_set_v7 \
	--new_table_name gui_train_set_v7 \
    --column_li ["cate_1_name","cate_2_name","city_name","weather_1","weather_2","weather_3","weekday_0_to_6"]
