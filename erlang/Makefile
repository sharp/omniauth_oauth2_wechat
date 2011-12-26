.SUFFIXES: .erl .beam
.erl.beam:
	erlc -W $<

ERL = erl -boot start_clean 

MODS = merle_client merle_test

all: compile
	${ERL}  -pz 'merle/ebin'

compile: ${MODS:%=%.beam}

clean:
	rm -f *.beam
	rm -f erl_crash.dump

install: all
	mkdir -p ${LIBDIR}/${APP_NAME}-${VSN}/ebin
	for i in ebin/*.beam; do install $$i $(LIBDIR)/${APP_NAME}-${VSN}/$$i ; done
