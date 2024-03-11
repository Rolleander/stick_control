//
// Created by Roland on 11.03.2024.
//

#include "OboePlayer.h"


void OboePlayer::renderAudio(float *audioData, int32_t numFrames, bool reset) {
    if (reset) {
        resetAudioData(audioData, numFrames);
    }

    for (auto &queue: queues) {
        if (!queue.queueEnded) {
            queue.renderAudio(audioData, numFrames);
        }
    }

    smoothAudio(audioData, numFrames);

    queues.erase(std::remove_if(queues.begin(), queues.end(),
                                [](const PlayerQueue &p) { return p.queueEnded; }), queues.end());
}


void OboePlayer::smoothAudio(float *audioData, int32_t numFrames) {
    for (int i = 0; i < numFrames; i++) {
        if (audioData[i * 2] > 1.0)
            audioData[i * 2] = 1.0;
        else if (audioData[i * 2] < -1.0)
            audioData[i * 2] = -1.0;

        if (audioData[i * 2 + 1] > 1.0)
            audioData[i * 2 + 1] = 1.0;
        else if (audioData[i * 2 + 1] < -1.0)
            audioData[i * 2 + 1] = -1.0;
    }
}

void OboePlayer::resetAudioData(float *audioData, int32_t numFrames) {
    for (int i = 0; i < numFrames; i++) {
        audioData[i * 2] = 0;
        audioData[i * 2 + 1] = 0;
    }
}

void PlayerQueue::renderAudio(float *audioData, int32_t numFrames) {
    renderStereo(audioData, numFrames);
}

void PlayerQueue::renderStereo(float *audioData, int32_t numFrames) {
    for (int i = 0; i < numFrames; i++) {
        float real = (float) (offset + i);
        int index = (int) real;

        if (index * 2 + 3 < player->data.size()) {
            float left = player->data.at(index * 2) + (real - (float) index) *
                                                      (player->data.at((index + 1) * 2) -
                                                       player->data.at(index * 2));
            float right = player->data.at(index * 2 + 1) + (real - (float) index) *
                                                           (player->data.at((index + 1) * 2 + 1) -
                                                            player->data.at(index * 2 + 1));

            audioData[i * 2] += left;
            audioData[i * 2 + 1] += right;
        } else {
            break;
        }
    }

    offset += numFrames;

    if ((float) offset >= player->data.size()) {
        offset = 0;
        queueEnded = true;
    }
}


void OboePlayer::release() {
    std::vector<float>().swap(data);
    std::vector<PlayerQueue>().swap(queues);
}