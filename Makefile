.PHONY: build clean clean-site server reload install-deps

build:
	dune build

clean:
	dune clean

clean-site:
	rm -rf _site

fmt:
	dune build @fmt --auto-promote

reload: clean clean-site
	dune build
	./bin/blog.exe build

remove-deps:
	opam remove yocaml yocaml_jingoo yocaml_markdown yocaml_unix yocaml_yaml
	opam pin remove yocaml yocaml_jingoo yocaml_markdown yocaml_unix yocaml_yaml

install-deps:
	opam install . --deps-only
	opam install yocaml
	opam install yocaml_jingoo yocaml_markdown yocaml_unix yocaml_yaml
