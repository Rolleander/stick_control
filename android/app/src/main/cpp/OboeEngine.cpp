
#include "OboeEngine.h"
#include <oboe/Oboe.h>
#include <utility>
#include <vector>
#include <android/log.h>

void OboeEngine::initialize() {
    std::vector<OboePlayer>().swap(players);
}

void OboeEngine::start() {
    AudioStreamBuilder builder;

    builder.setFormat(AudioFormat::Float);
    builder.setDirection(Direction::Output);
    builder.setChannelCount(ChannelCount::Stereo);
    builder.setPerformanceMode(PerformanceMode::LowLatency);
    builder.setSharingMode(SharingMode::Shared);

    builder.setCallback(this);

    builder.openStream(stream);

    stream->setBufferSizeInFrames(stream->getFramesPerBurst() * 2);

    stream->requestStart();

    //deviceSampleRate = stream->getSampleRate();

    isStreamOpened = true;
}

void OboeEngine::release() {
    stream->flush();
    stream->close();
    stream.reset();
    isStreamOpened = false;

    for (auto &player: players) {
        player.release();
    }

    std::vector<OboePlayer>().swap(players);
}

DataCallbackResult
OboeEngine::onAudioReady(AudioStream *audioStream, void *audioData, int32_t numFrames) {
    for (int i = 0; i < players.size(); i++) {
        players.at(i).renderAudio(static_cast<float *>(audioData), numFrames, i == 0);
    }
    return DataCallbackResult::Continue;
}


int OboeEngine::addPlayer(std::vector<float> data) {
    int index = players.size();
    players.at(index) = OboePlayer(std::move(data));
    return index;
}

void OboeEngine::addQueue(int id) {
    if (id >= 0 && id < players.size()) {
        players.at(id).addQueue();
    }
}

void OboeEngine::onErrorAfterClose(AudioStream *audioStream, Result result) {
    if (result == oboe::Result::ErrorDisconnected) {
        reopenStream();
    }
}

void OboeEngine::closeStream() {
    if (isStreamOpened) {
        stream->stop();
        stream->flush();

        stream.reset();

        isStreamOpened = false;
    }
}

void OboeEngine::reopenStream() {
    if (isStreamOpened) {
        closeStream();
    }

    start();
}