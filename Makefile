-include Makefile.common

all: compile test

Makefile.common:Makefile
	@echo "export PATH=${PATH}" >${@}

compile:
	gprbuild -j0 -p
test:
	${MAKE} -C tests ${@}

clean:
	git clean -xdf
install:
	${MAKE} -C examples ${@}

tag:
