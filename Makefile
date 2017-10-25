.PHONY: clean distclean

all: simv

simv: test/test_if.v if/*.v top/*.v
	vcs $^

clean:
	rm -rf csrc simv.daidir

distclean: clean
	rm -f simv

