
MKTOP    := jsoo_mktop

all: toplevel.js  
JSFILES= +weak.js +toplevel.js +nat.js

PACKAGES= \
	lwt bigarray tyxml.functor \
	js_of_ocaml \
	js_of_ocaml.tyxml \
	fan.common \
	fan.toplib
# Note that for linking fan.toplib is enough
# however fan.common also produce missing cmi files
# so you have cmi files 

MKTOP=jsoo_mktop --verbose -safe-string \
	-dont-export-unit gc \
	-jsopt "--disable shortvar" \
	${addprefix -export-package , ${PACKAGES}} 




toplevel.js: toplevel.cmo
	$(MKTOP) \
	toplevel.cmo \
	${addprefix -jsopt , ${JSFILES}} \
	-o toplevel.byte


%.cmi:%.mli
	ocamlfind ocamlc -c -package js_of_ocaml,js_of_ocaml.tyxml $<
%.cmo:%.ml
	ocamlfind ocamlc -c -package fan.toplib  -syntax camlp4o -safe-string \
		-package js_of_ocaml.syntax,lwt,js_of_ocaml.tyxml,js_of_ocaml.toplevel \
		$< -c $@
clean::
	rm -f *.cm[io] *.byte *.native *.js *.annot *~
