//
// Created by Roland on 11.03.2024.
//

#ifndef ANDROID_OBOEPLAYER_H
#define ANDROID_OBOEPLAYER_H

#include <vector>


class OboePlayer;

class PlayerQueue {

private:
    OboePlayer *player;

    void renderStereo(float *audioData, int32_t numFrames);

public:
    int offset = 0;
    bool queueEnded = false;

    PlayerQueue(OboePlayer *player) {
        this->player = player;
    }

    void renderAudio(float *audioData, int32_t numFrames);

};

class OboePlayer {

private:
    std::vector <PlayerQueue> queues = std::vector<PlayerQueue>();

public:
    bool isReleased = false;

    OboePlayer(std::vector<float> data) {
        this->data = data;
    }

    void renderAudio(float *audioData, int32_t numFrames, bool reset);

    static void smoothAudio(float *audioData, int32_t numFrames);

    void addQueue() {
        if (isReleased)
            return;
        queues.push_back(PlayerQueue(this));
    };

    static void resetAudioData(float *audioData, int32_t numFrames);

    void release();

    std::vector<float> data;

};


#endif //ANDROID_OBOEPLAYER_H
