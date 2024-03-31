package com.broll.stick_control

import android.media.MediaExtractor
import android.media.MediaFormat
import java.nio.ByteBuffer
import java.nio.ByteOrder


class AudioReaderException(message: String) : Exception(message)

fun readAudioFile(path: String): FloatArray {
    val extractor = MediaExtractor()
    with(extractor) {
        setDataSource(path)
        val trackIndex = findAudioTrackIndex() ?: throw AudioReaderException("No audio track found")
        selectTrack(trackIndex)
        return MediaCodecReader(getTrackFormat(trackIndex), this).readBytes().toFloatArray()
    }
}

private fun ByteArray.toFloatArray(): FloatArray {
    val shorts = ShortArray(size / 2)
    ByteBuffer.wrap(this).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(shorts)
    val result = FloatArray(shorts.size)
    for (i in shorts.indices) {
        result[i] = shorts[i] * 2.0f / UShort.MAX_VALUE.toFloat()
    }
    return result
}

private fun MediaExtractor.getMime(trackIndex: Int) =
    getTrackFormat(trackIndex).getString(MediaFormat.KEY_MIME)

private fun MediaExtractor.findAudioTrackIndex() =
    (0 until trackCount).find { getMime(it)?.startsWith("audio/") == true }


