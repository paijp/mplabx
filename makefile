DEVICE	= 16f887
AS	= /opt/microchip/mplabx/v3.35/mpasmx/mpasmx -q -p$(DEVICE)
DATE	= $(shell date '+_%y%m%d_%H%M%S')
TARGET	= test


help:
	@awk '/#[#]/{sub(":[^#]*", "\t\t");print $0;}' makefile

build:	$(TARGET).HEX makefile.done		## build .HEX

check:	poff.mdb	## check PICkit
	echo y |mdb poff.mdb

burn:	program
program:	build $(TARGET).mdb poff.mdb		## program a device.
	echo y |mdb $(TARGET).mdb

burnandoff:	program poff.mdb			## program and power-off
	echo y |mdb poff.mdb

$(TARGET).mdb:	makefile
	echo '# # # # this file is auto built by makefile.' >$@
	echo 'device pic$(DEVICE)' >>$@
	echo 'set AutoSelectMemRanges auto' >>$@
	echo 'set poweroptions.powerenable true' >>$@
	echo 'set voltagevalue 4.9' >>$@
	echo 'hwtool pickit3 -p' >>$@
	echo 'program $(TARGET).HEX' >>$@
	echo 'sleep 1000' >>$@
	echo 'quit' >>$@
	@mkdir -p hist
	cp $@ hist/$@$(DATE)

poff.mdb:	makefile
	echo '# # # # this file is auto built by makefile.' >$@
	echo 'device pic$(DEVICE)' >>$@
	echo 'set AutoSelectMemRanges auto' >>$@
	echo 'set poweroptions.powerenable false' >>$@
	echo 'set voltagevalue 4.9' >>$@
	echo 'hwtool pickit3 -p' >>$@
	echo 'quit' >>$@
	@mkdir -p hist
	cp $@ hist/$@$(DATE)


%.HEX:	%.asm
	@mkdir -p hist
	cp $< hist/$<$(DATE)
	$(AS) $<
	@cat $(<:.asm=.ERR)
	cp $@ hist/$@$(DATE)

%.done:	%
	@mkdir -p hist
	cp $< hist/$<$(DATE)
	touch $@

