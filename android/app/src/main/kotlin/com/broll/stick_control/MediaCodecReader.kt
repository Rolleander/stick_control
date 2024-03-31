package com.broll.stick_control

import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import android.os.Build

class MediaCodecReader(format: MediaFormat, private val extractor: MediaExtractor) {
    private val codec = MediaCodec.createDecoderByType(format.getString(MediaFormat.KEY_MIME)!!)
    private val info = MediaCodec.BufferInfo()
    private val timeoutUs = 10000L

    init {
        codec.configure(format, null, null, 0)
        codec.start()
    }

    fun readBytes(): ByteArray {
        val byteArrays = mutableListOf<ByteArray>()
        var eof = false
        while (true) {
            if (!eof) {
                eof = queueInput()
            }
            releaseOutput()?.let {
                byteArrays += it
            }
            if (isComplete()) {
                codec.stop()
                codec.release()
                extractor.release()
                return byteArrays.concat()
            }
        }
    }

    private fun List<ByteArray>.concat(): ByteArray {
        val concatArray = ByteArray(sumOf { it.size })
        var offset = 0
        this.forEach {
            it.copyInto(concatArray, destinationOffset = offset)
            offset += it.size
        }
        return concatArray
    }

    private fun isComplete() =
        info.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0

    private fun releaseOutput(): ByteArray? {
        val index = codec.dequeueOutputBuffer(info, timeoutUs)
        if (index < 0) {
            return null
        }
        val buffer = codec.accessOutputBuffer(index)
        val bytes = ByteArray(info.size - info.offset)

        val pos = buffer.position()

        buffer.get(bytes)
        buffer.position(pos)

        codec.releaseOutputBuffer(index, true)
        return bytes
    }

    private fun queueInput(): Boolean {
        val index = codec.dequeueInputBuffer(timeoutUs)
        if (index < 0) {
            return false
        }
        val inputBuffer = codec.accessInputBuffer(index)
        val size = extractor.readSampleData(inputBuffer, 0)
        if (size < 0) {
            codec.queueInputBuffer(index, 0, 0, 0, MediaCodec.BUFFER_FLAG_END_OF_STREAM)
        } else {
            codec.queueInputBuffer(index, 0, size, extractor.sampleTime, 0)
            extractor.advance()
        }
        return size < 0
    }

    private fun MediaCodec.accessOutputBuffer(index: Int) =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getOutputBuffer(index)
        } else {
            outputBuffers[index]
        } ?: throw AudioReaderException("Cannot access outputBuffer : $index")

    private fun MediaCodec.accessInputBuffer(index: Int) =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getInputBuffer(index)
        } else {
            inputBuffers[index]
        } ?: throw AudioReaderException("Cannot access inputBuffer : $index")

}