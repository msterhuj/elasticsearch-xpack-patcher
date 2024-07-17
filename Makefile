shell:
	docker build --tag espacher --file patcher.Dockerfile . --platform linux/amd64
	docker run --platform linux/amd64 -it --rm --name espacher --volume $(PWD)/:/espatcher/ espacher
