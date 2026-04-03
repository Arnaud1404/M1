EXECS = \
exercise-1-32	\
exercise-1-64 	\
exercise-2-32 	\
exercise-2-64	\
exercise-3-32 	\
exercise-3-64

CFLAGS = -Wall -Wextra -std=c11 -g
CPPFLAGS =
LDFLAGS =

all: $(EXECS)

# Exercise 1
exercise-1-32: exercise-1.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -m32 -O0 -o $@ $< $(LDFLAGS)

exercise-1-64: exercise-1.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -O0 -o $@ $< $(LDFLAGS)

# Exercise 2
exercise-2-32: exercise-2.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -m32 -O3 -o $@ $< $(LDFLAGS)
	strip $@

exercise-2-64: exercise-2.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -O3 -o $@ $< $(LDFLAGS)
	strip $@

# Exercise 3
exercise-3-32: exercise-3.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -m32 -O3 -o $@ $< $(LDFLAGS)
	strip $@

exercise-3-64: exercise-3.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -O3 -o $@ $< $(LDFLAGS)
	strip $@

clean:
	rm -f $(EXECS)

.PHONY: all clean
