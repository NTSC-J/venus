.PHONY: clean 

all: simv

simv:
	$(MAKE) -C util
	$(MAKE) -C reg
	vcs +error+1000 build.v

clean:
	$(MAKE) -C util clean
	$(MAKE) -C reg clean
	rm -rf csrc simv.daidir ucli.key simv

test_if: test/test_if.v test/test_if_top.v if/*.v
	vcs $^
	
