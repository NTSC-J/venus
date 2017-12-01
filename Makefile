.PHONY: clean gencode

all: simv

simv: gencode
	vcs +error+1000 build.v

gencode:
	$(MAKE) -C util
	$(MAKE) -C reg

clean:
	$(MAKE) -C util clean
	$(MAKE) -C reg clean
	rm -rf csrc simv.daidir ucli.key simv

test_if: test/test_if.v test/test_if_top.v if/*.v
	vcs $^
	
test_addx: gencode
	vcs test/test_addx.v build.v 

