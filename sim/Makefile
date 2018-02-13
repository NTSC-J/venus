.PHONY: clean gencode

VCS=vcs +warn=all +error+1000 +lint=TFIPC-L

all: gencode
	$(VCS) build.v 

gencode:
	$(MAKE) -C ../util
	$(MAKE) -C ../reg

clean:
	$(MAKE) -C ../util clean
	$(MAKE) -C ../reg clean
	rm -rf csrc simv.daidir ucli.key simv
	rm ../mem/mem.dat

run:
	printf "\x1b[8;19;80t"
	./simv | tail -n+4 | head -n-6 | less -R
	printf "\x1b[8;73;80t"

test_addx: gencode
	ln -sf addx.dat ../mem/imem.dat

test_loop: gencode
	ln -sf loop.dat ../mem/imem.dat

test_interlock: gencode
	ln -sf interlock.dat ../mem/imem.dat

test_load: gencode
	ln -sf load.dat ../mem/imem.dat

test_store: gencode
	ln -sf store.dat ../mem/imem.dat

