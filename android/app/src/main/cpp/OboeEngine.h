#ifndef ANDROID_OBOEENGINE_H
#define ANDROID_OBOEENGINE_H

#include <oboe/Oboe.h>
#include <vector>
#include "OboePlayer.h"

using namespace oboe;

class OboeEngine : public AudioStreamCallback {

public:
    void initialize();

    void start();

    void closeStream();

    void reopenStream();

    void release();

    bool isStreamOpened = false;
    std::shared_ptr <AudioStream> stream;
    std::vector <OboePlayer> players = std::vector<OboePlayer>();

    DataCallbackResult
    onAudioReady(AudioStream *audioStream, void *audioData, int32_t numFrames) override;

    void onErrorAfterClose(AudioStream *audioStream, Result result) override;


    int addPlayer(std::vector<float> data);

    void addQueue(int id);

};

#endif