CFLAGS   = -g -Wall -Wextra -Wno-unused-parameter -Wno-uninitialized \
	   -Wstringop-overflow=0 \
	   -fno-stack-protector -fcf-protection=none -Wl,-z,norelro,-z,now
CPPFLAGS =
LDFLAGS  =

CC32 = $(CC) -m32
CC64 = $(CC) -m64

EXECS = vulnerable-1-static-32 vulnerable-1-shared-32 \
        vulnerable-1-static-64 vulnerable-1-shared-64 \
	vulnerable-2-32 vulnerable-2-64 \
	vulnerable-pie-32 vulnerable-pie-64 \
	get_eggshell-32 get_eggshell-64

all: $(EXECS)

vulnerable-1-static-32: vulnerable-1.c
	$(CC32) $(CFLAGS) -no-pie -static $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-1-static-64: vulnerable-1.c
	$(CC64) $(CFLAGS) -no-pie -static $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-1-shared-32: vulnerable-1.c
	$(CC32) $(CFLAGS) -no-pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-1-shared-64: vulnerable-1.c
	$(CC64) $(CFLAGS) -no-pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-2-32: vulnerable-2-32.c
	$(CC32) $(CFLAGS) -no-pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-2-64: vulnerable-2-64.c
	$(CC64) $(CFLAGS) -no-pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-pie-32: vulnerable-pie.c
	$(CC32) $(CFLAGS) -pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

vulnerable-pie-64: vulnerable-pie.c
	$(CC64) $(CFLAGS) -pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

get_eggshell-32: get_eggshell.c
	$(CC32) $(CFLAGS) -pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

get_eggshell-64: get_eggshell.c
	$(CC64) $(CFLAGS) -pie $(CPPFLAGS) -o $@ $< $(LDFLAGS)

clean:
	@rm -fr $(EXECS) *~

.PHONY: all clean
