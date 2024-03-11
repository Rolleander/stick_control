//
// Created by Roland on 11.03.2024.
//

#include <jni.h>
#include <vector>
#include <algorithm>
#include <string>
#include "OboeEngine.h"

using namespace std;

OboeEngine engine;

extern "C" {

JNIEXPORT  void JNICALL
Java_com_broll_stick_1control_OboePlayer_init(JNIEnv *env, jobject instance) {
    engine.initialize();
    engine.start();
}


JNIEXPORT  jint JNICALL
Java_com_broll_stick_1control_OboePlayer_load(JNIEnv *env, jobject instance, jfloatArray data) {
    int size = env->GetArrayLength(data);

    auto *parse = (jfloat *) (env->GetFloatArrayElements(data, nullptr));

    auto *vectorData = new vector<float>;

    for (int i = 0; i < size; i++) {
        vectorData->push_back(parse[i]);
    }
    return engine.addPlayer(*vectorData);
}

JNIEXPORT  void JNICALL
Java_com_broll_stick_1control_OboePlayer_play(JNIEnv *env, jobject instance, jint id) {
    engine.addQueue(id);
}

}

