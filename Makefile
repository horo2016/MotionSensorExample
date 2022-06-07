##### Make sure all is the first target.
all:

CXX = g++
CC  = gcc
CXX_OPTS= -DMPU9250 -DMPU_DEBUG #-DDEBUG#-DMPU_DEBUGOFF 

CFLAGS  += -g -pthread -Wall 
CFLAGS  += -rdynamic -funwind-tables
CFLAGS  += -I./     -I./inv_mpu_lib   
CFLAGS  += -I./libs
CFLAGS  += -I./libs/I2Cdev
CFLAGS  += -I./MotionSensor
CFLAGS  += -I./MotionSensor/inv_mpu_lib
CFLAGS += -D__unused="__attribute__((__unused__))"
CFLAGS +=  $(CXX_OPTS)


C_SRC=
C_SRC += MotionSensor/inv_mpu_lib/inv_mpu.c  
C_SRC += libs/I2Cdev/I2Cdev.c
C_SRC += MotionSensor/inv_mpu_lib/inv_mpu_dmp_motion_driver.c

CXX_SRC=

CXX_SRC += MotionSensor/sensor.cpp 
CXX_SRC += main.cpp 

OBJ=
DEP=



OBJ_CAM_SRV = main.o
TARGETS    += mtest
$(TARGETS): $(OBJ_CAM_SRV)
TARGET_OBJ += $(OBJ_CAM_SRV)

FILE_LIST := files.txt
COUNT := ./make/count.sh
MK := $(word 1,$(MAKEFILE_LIST))
ME := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

OBJ=$(CXX_SRC:.cpp=.o) $(C_SRC:.c=.o)
DEP=$(OBJ:.o=.d) $(TARGET_OBJ:.o=.d)

CXXFLAGS +=  $(CFLAGS)

#include ./common.mk
.PHONY: all clean distclean

all: $(TARGETS)

clean:
	rm -f $(TARGETS) $(FILE_LIST)
	find . -name "*.o" -delete
	find . -name "*.d" -delete

distclean:
	rm -f $(TARGETS) $(FILE_LIST)
	find . -name "*.o" -delete
	find . -name "*.d" -delete

-include $(DEP)

%.o: %.c $(MK) $(ME)
	@[ -f $(COUNT) ] && $(COUNT) $(FILE_LIST) $^ || true
	@$(CC) -c $< -MM -MT $@ -MF $(@:.o=.d) $(CFLAGS) $(LIBQCAM_CFLAGS)
	$(CC) -c $< $(CFLAGS) -o $@ $(LIBQCAM_CFLAGS)

%.o: %.cpp $(MK) $(ME)
	@[ -f $(COUNT) ] && $(COUNT) $(FILE_LIST) $^ || true
	@$(CXX) -c $< -MM -MT $@ -MF $(@:.o=.d) $(CXXFLAGS)
	$(CXX) -c $< $(CXXFLAGS) -o $@

$(TARGETS): $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)
	@[ -f $(COUNT) -a -n "$(FILES)" ] && $(COUNT) $(FILE_LIST) $(FILES) || true
	@[ -f $(COUNT) ] && $(COUNT) $(FILE_LIST) || true
