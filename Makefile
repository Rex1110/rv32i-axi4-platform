root_dir := $(PWD)
src_dir := ./src
inc_dir := ./include
sim_dir := ./sim
bld_dir := ./build


rtl0: | $(bld_dir)
	make -C $(sim_dir)/prog0/; \
	cd $(bld_dir); \
	irun $(root_dir)/$(sim_dir)/top_tb.sv \
	-64bit \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(src_dir)/AXI+$(root_dir)/$(inc_dir)+$(root_dir)/$(sim_dir) \
	+define+prog0$(FSDB_DEF) \
	+access+r \
	+prog_path=$(root_dir)/$(sim_dir)/prog0

.PHONY: clean

clean:
	rm -rf $(bld_dir); \
	rm -rf $(sim_dir)/prog*/result*.txt; \
	make -C $(sim_dir)/prog0/ clean;

