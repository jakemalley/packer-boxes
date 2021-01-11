.DEFAULT_GOAL := build
.PHONY : build build-box clean vagrant-clean vagrant-box-clean packer-cache-clean packer-box-clean

build:
	@echo building all boxes
	ansible-playbook build.yml

BOX_NAME ?= centos8-stream
ifndef BOX_VERSION
	ANSIBLE_EXTRA_ARGS := {"boxes": [{"box_name": "$(BOX_NAME)"}]}
else
	ANSIBLE_EXTRA_ARGS := {"boxes": [{"box_name": "$(BOX_NAME)", "override_box_version": "$(BOX_VERSION)"}]}
endif
build-box:
	@echo building box $(BOX_NAME)
	ansible-playbook build.yml --extra-vars '$(ANSIBLE_EXTRA_ARGS)'

vagrant-clean:
	find . -type d -name ".vagrant" -print0 | xargs -0 -I{} sh -c 'cd {}/../ && vagrant destroy -f && cd -'

vagrant-box-clean:
	vagrant box list | grep 'file://build/' | cut -d' ' -f1 | xargs -I{} vagrant box remove {}

packer-cache-clean:
	find . -type d -name "packer_cache" -exec rm -rf {} \;

packer-box-clean:
	find . -type f -name "*.box" -exec rm -f {} \;

clean: vagrant-clean vagrant-box-clean packer-box-clean packer-cache-clean
