LOCALBASE?=/usr/local
CFLAGS+=-std=c11 -Wall -Wextra -pedantic -I${LOCALBASE}/include
LDFLAGS+=-s
EXTRA_LIBS=-L${LOCALBASE}/lib -Liniparse -lpcre -liniparser
CC?=clang
AR?=ar

BRUTEBLOCK_OBJS=bruteblock.o utils.o ipfw2.o
BRUTEBLOCKD_OBJS=bruteblockd.o bruteblockd_global.o utils.o ipfw2.o pidfile.o
INIPARSE_SRC=iniparse/dictionary.c iniparse/iniparser.c iniparse/strlib.c
INIPARSE_H=iniparse/dictionary.h iniparse/iniparser.h iniparse/strlib.h

all: bruteblock bruteblockd

iniparse/libiniparser.a: $(INIPARSE_SRC) $(INIPARSE_H)
	@cd iniparse  && make

bruteblock: $(BRUTEBLOCK_OBJS) iniparse/libiniparser.a
	$(CC) $(LDFLAGS) -o $@ $(BRUTEBLOCK_OBJS) $(EXTRA_LIBS)

bruteblockd: $(BRUTEBLOCKD_OBJS) pidfile.h
	$(CC) $(LDFLAGS) -o $@ $(BRUTEBLOCKD_OBJS) $(EXTRA_LIBS)

clean:
	@rm -f *.o *~  bruteblockd bruteblock *.core
	@cd iniparse && make clean

