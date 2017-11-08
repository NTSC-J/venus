.PHONY: clean 

all: simv

simv: test/test_if.v if/*.v top/*.v
	$(MAKE) -C util
	vcs $^

clean:
	$(MAKE) -C util clean
	rm -rf csrc simv.daidir ucli.key simv

