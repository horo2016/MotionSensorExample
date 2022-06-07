#ifndef SENSOR_H
#define SENSOR_H
#include "helper_3dmath.h"
#define YAW 0
#define PITCH 1
#define ROLL 2
#define DIM 3
extern float ypr[3]; //yaw, pitch, roll
extern float accel[3];
extern float gyro[3];
extern float temp;
extern float compass[3];

extern int ms_open();
extern int ms_update();
extern int ms_close();


extern unsigned char GetGravity(VectorFloat *v, Quaternion *q);
extern unsigned char GetYawPitchRoll(float *data, Quaternion *q, VectorFloat *gravity); 
extern unsigned char GetGyro(int32_t *data, const unsigned char* packet);


#endif
