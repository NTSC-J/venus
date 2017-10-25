.PHONY: clean distclean

all: simv

simv: if/*.v
	vcs $^

clean:
	rm -rf csrc simv.daidir

distclean: clean
	rm -f simv

