SKILLS_HOME ?= $(HOME)/.codex/skills
DIST_DIR ?= dist

SKILL_DIRS := $(sort $(patsubst %/,%,$(dir $(shell find . -maxdepth 2 -name SKILL.md -print))))
SKILL_NAMES := $(notdir $(SKILL_DIRS))
PACKAGE_TARGETS := $(addprefix $(DIST_DIR)/,$(addsuffix .skill,$(SKILL_NAMES)))

.PHONY: list package install clean

list:
	@echo "Skills:" $(SKILL_NAMES)

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

$(DIST_DIR)/%.skill: %/SKILL.md | $(DIST_DIR)
	@rm -f $@
	@(cd $* && zip -r $(abspath $@) . > /dev/null)

package: $(PACKAGE_TARGETS)
	@echo "Packaged:" $(PACKAGE_TARGETS)

install:
	@mkdir -p $(SKILLS_HOME)
	@for dir in $(SKILL_DIRS); do \
		name=$$(basename $$dir); \
		rsync -a --exclude '.git' --exclude 'dist' --exclude '*.skill' $$dir/ $(SKILLS_HOME)/$$name/; \
	done
	@echo "Installed to" $(SKILLS_HOME)

clean:
	@rm -rf $(DIST_DIR)
