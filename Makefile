MODULE_NAME = hellomod

obj-m = $(MODULE_NAME).o

# Inside the container

KVERSION = $(shell uname -r)

MODULE_DIR = exports/hostfs/var/lib/modules/$(KVERSION)/$(MODULE_NAME)

all: build

exports: $(MODULE_DIR)/$(MODULE_NAME).ko $(dir $(MODULE_DIR))/modules.builtin $(dir $(MODULE_DIR))/modules.order \
	exports/manifest.json \
	exports/config.json.template \
	exports/hostfs/etc/dracut.conf.d/$(MODULE_NAME).conf \
	exports/hostfs/usr/local/sbin/install_$(MODULE_NAME).sh \
	exports/hostfs/usr/local/sbin/uninstall_$(MODULE_NAME).sh

$(MODULE_DIR):
	mkdir -p $@

$(MODULE_DIR)/$(MODULE_NAME).ko: $(MODULE_NAME).ko $(MODULE_DIR)
	cp $< $@

$(dir $(MODULE_DIR))/modules.builtin: $(MODULE_DIR)
	touch $@

$(dir $(MODULE_DIR))/modules.order: $(MODULE_DIR)
	touch $@

# not used.  Added to avoid a warning
exports/config.json.template: Makefile
	printf '{"process" : {"args" : []}, "root" : {"path" : "rootfs", "readonly" : true}\n\n}' > $@

exports/manifest.json: manifest.json $(MODULE_DIR)
	cp $< $@

exports/hostfs/etc/dracut.conf.d/$(MODULE_NAME).conf: Makefile
	mkdir -p $(dir $@)
	printf "echo drivers_dir+=/var/lib/modules/$(uname -r)/\n" > $@

exports/hostfs/usr/local/sbin/install_$(MODULE_NAME).sh: install_$(MODULE_NAME).sh
	mkdir -p $(dir $@)
	cp $< $@

exports/hostfs/usr/local/sbin/uninstall_$(MODULE_NAME).sh: uninstall_$(MODULE_NAME).sh
	mkdir -p $(dir $@)
	cp $< $@

$(MODULE_NAME).ko: $(MODULE_NAME).c
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules
clean:
	rm -rf exports
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean

build: exports
	docker build -t $(MODULE_NAME) .

.PHONY: build all exports clean
