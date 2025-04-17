examples_list.libsonnet:
	ls examples | jsonnet -S gen_example_list.jsonnet | jsonnetfmt - > examples_list.libsonnet

output:
	jsonnet -S -m docs -c -J vendor main.libsonnet
