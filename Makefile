BLACKLIST=blacklist
RELEASE_DIR=release

all: cleanup gen-lsrules gen-ip-blacklist gen-hosts gen-cloaking-rules

test-local:
	@command -v act-cli >/dev/null && exec act-cli || \
	command -v act >/dev/null && exec act || \
	command -v gh >/dev/null && exec gh extension exec act || \
	echo "No available act command found"

cleanup:
	sort -u -o $(BLACKLIST) $(BLACKLIST)

gen-lsrules:
	mkdir -p $(RELEASE_DIR)
	utils/lsrules.py < $(BLACKLIST) > $(RELEASE_DIR)/apple-telemetry.lsrules

gen-ip-blacklist:
	mkdir -p $(RELEASE_DIR)
	echo "Generating IP blacklist, please be patient."
	utils/resolve.py < $(BLACKLIST) > $(RELEASE_DIR)/ip-blacklist
	sort -u -o $(RELEASE_DIR)/ip-blacklist $(RELEASE_DIR)/ip-blacklist

gen-hosts:
	mkdir -p $(RELEASE_DIR)
	sed 's/^/0.0.0.0 /' $(BLACKLIST) > $(RELEASE_DIR)/hosts

gen-cloaking-rules:
	mkdir -p $(RELEASE_DIR)
	sed 's/$$/ 0.0.0.0/' $(BLACKLIST) > $(RELEASE_DIR)/cloaking-rules
