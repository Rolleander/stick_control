package com.broll.stick_control

import android.media.MediaCodec
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.nio.ByteOrder

class OboePlayer {

    private external fun load(data: FloatArray): Int
    external fun play(id: Int)
    external fun init()

    fun load(result : MethodChannel.Result, path: String) {
        val reader = AudioReader(path)
        if (reader.canDo) {
            val resArray = reader.getPCM(MediaCodec.BufferInfo()).toByteArray()
            val id = load(toFloatArray(resArray))
            result.success(id)
        } else {
            result.error("FOP_SOUND_INIT_FAILURE", "Failed to initialize sound", null)
        }
    }

    private fun toFloatArray(bytes: ByteArray): FloatArray {
        val shorts = ShortArray(bytes.size / 2)
        ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(shorts)
        val result = FloatArray(shorts.size)
        for (i in shorts.indices) {
            result[i] = shorts[i] * 2.0f / 65535
        }
        return result
    }

}