.PHONY: clean 

all: simv

simv: test/test_if.v if/*.v top/*.v
	$(MAKE) -C util
	$(MAKE) -C reg
	vcs $^

clean:
	$(MAKE) -C util clean
	$(MAKE) -C reg clean
	rm -rf csrc simv.daidir ucli.key simv

test_if: test/test_if.v test/test_if_top.v if/*.v
	vcs $^
	
