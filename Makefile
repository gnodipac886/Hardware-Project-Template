VCS=vcs
VCSFLAGS=-sverilog -timescale=1ns/10ps -full64 -debug_access+all +v2k -nc -lca
VCSGUIFLAGS=-gui -kdb
.DEFAULT_GOAL:=top

SRC=src
VAL_SRC=$(SRC)/val
RTL_SRC=$(SRC)/rtl
RTL_DEPS=
RTL=$(addprefix $(RTL_SRC)/, $(RTL_DEPS)) $(shell find $(RTL_SRC)/ -type f -name '*.sv' | sort) $(shell find $(RTL_SRC)/ -type f -name '*.v' | sort)
VAL=$(wildcard $(VAL_SRC)/*.v) $(wildcard $(VAL_SRC)/*.sv)

.PHONY: top
top: $(RTL) $(VAL)
	$(VCS) $(VCSFLAGS) -top top $^
	./simv

.PHONY: top_gui
top_gui: $(RTL) $(VAL)
	$(VCS) $(VCSFLAGS) $(VCSGUIFLAGS) -top top $^
	./simv

.PHONY: clean
clean:
	rm -f *.vcd simv ucli.key
	rm -rf csrc/ simv.daidir/