.PHONY: clean gencode

VCS=vcs +warn=all +error+1000

all: gencode test_loop
	$(VCS) build.v 

gencode:
	$(MAKE) -C util
	$(MAKE) -C reg

clean:
	$(MAKE) -C util clean
	$(MAKE) -C reg clean
	rm -rf csrc simv.daidir ucli.key simv
	rm mem/mem.dat

test_addx: gencode
	ln -sf addx.dat mem/mem.dat

test_loop: gencode
	ln -sf loop.dat mem/mem.dat

