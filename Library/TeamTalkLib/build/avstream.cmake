include (ttlib)
include (ffmpeg)
include (dshow)
include (vidcap)
include (speexdsp)
include (webrtc)

set (AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MediaStreamer.cpp)
set (AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MediaStreamer.h)

list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MediaPlayback.cpp)
list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MediaPlayback.h)

list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/AudioInputStreamer.cpp)
list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/AudioInputStreamer.h)

option (SPEEXDSP "Build SpeexDSP codec classes" ON)

if (SPEEXDSP)
  list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/SpeexPreprocess.cpp)
  list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/SpeexResampler.cpp)
  list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/SpeexPreprocess.h)
  list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/SpeexResampler.h)
  list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_SPEEXDSP)
  list (APPEND AVSTREAM_INCLUDE_DIR ${SPEEXDSP_INCLUDE_DIR})
  list (APPEND AVSTREAM_LINK_FLAGS ${SPEEXDSP_LINK_FLAGS})
endif()

if (MSVC)
  option (FFMPEG "Build ffmpeg classes" OFF)
else()
  option (FFMPEG "Build ffmpeg classes" ON)
endif()

if (FFMPEG)
  list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Streamer.cpp)
  list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Resampler.cpp)
  list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Streamer.h)
  list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Resampler.h)
  list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_FFMPEG3 ${FFMPEG_COMPILE_FLAGS})
  list (APPEND AVSTREAM_INCLUDE_DIR ${FFMPEG_INCLUDE_DIR})
  list (APPEND AVSTREAM_LINK_FLAGS ${FFMPEG_LINK_FLAGS})

  if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    option(V4L2 "Build Video for Linux 2 (V4L2) classes" ON)

    if (V4L2)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Capture.cpp)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.cpp)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/V4L2Capture.cpp)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Capture.h)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.h)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/V4L2Capture.h)
      list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_V4L2)
    endif()
  endif()

  if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    option(AVF "Build video capture (AVFoundation) classes for macOS" ON)

    if (AVF)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/AVFCapture.mm)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/AVFVideoInput.cpp)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Capture.cpp)
      list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.cpp)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/AVFCapture.h)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/AVFVideoInput.h)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/FFMpeg3Capture.h)
      list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.h)
      list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_AVF)
    endif()
  endif()
endif()

if (FFMPEG)
  if (${CMAKE_SYSTEM_NAME} MATCHES "Linux" AND ${CMAKE_SIZEOF_VOID_P} EQUAL 8)
    list (APPEND AVSTREAM_LINK_FLAGS "-Wl,-Bsymbolic")
  endif()
endif()

option (WEBRTC "Build using WebRTC libraries" ON)

if (WEBRTC)
  list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/WebRTCPreprocess.cpp)
  list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/WebRTCPreprocess.h)
  list (APPEND AVSTREAM_INCLUDE_DIR ${WEBRTC_INCLUDE_DIR})
  list (APPEND AVSTREAM_LINK_FLAGS ${WEBRTC_LINK_FLAGS})
  list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_WEBRTC)
endif()

if (MSVC)
  
  option (MSDMO "Build Microsoft DirectX Media Objects (DMO) Resampler classes" ON)

  if (MSDMO)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/DMOResampler.h)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/DMOResampler.cpp)
    list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_DMORESAMPLER)
    list (APPEND AVSTREAM_LINK_FLAGS Msdmo strmiids)
  endif()

  option (DSHOW "Build Microsoft DirectShow Streaming classes" OFF)

  if (DSHOW)
    list (APPEND AVSTREAM_INCLUDE_DIR ${DSHOW_INCLUDE_DIR})
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/WinMedia.h)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MediaStreamer.h)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/WinMedia.cpp)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MediaStreamer.cpp)
    list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_DSHOW)
    list (APPEND AVSTREAM_LINK_FLAGS ${DSHOW_STATIC_LIB})
  endif()

  option (VIDCAP "Build DirectShow Video Capture classes" OFF)

  if (VIDCAP)
    list (APPEND AVSTREAM_INCLUDE_DIR ${VIDCAP_INCLUDE_DIR})
    list (APPEND AVSTREAM_LINK_FLAGS ${VIDCAP_STATIC_LIB})
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.h)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/LibVidCap.h)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.cpp)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/LibVidCap.cpp)
    list (APPEND AVSTREAM_COMPILE_FLAGS -DENABLE_LIBVIDCAP )
  endif()
  
  option (MEDIAFOUNDATION "Build Media Foundation Streaming classes" ON)

  if (MEDIAFOUNDATION)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MediaStreamer.h)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MFCapture.h)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MFStreamer.h)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/MFTransform.h)
    list (APPEND AVSTREAM_HEADERS ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.h)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MediaStreamer.cpp)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MFCapture.cpp)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MFStreamer.cpp)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/MFTransform.cpp)
    list (APPEND AVSTREAM_SOURCES ${TEAMTALKLIB_ROOT}/avstream/VideoCapture.cpp)
    list (APPEND AVSTREAM_LINK_FLAGS mf mfplat mfreadwrite mfuuid shlwapi propsys)
    list (APPEND AVSTREAM_COMPILE_FLAGS -DWINVER=0x0601 -DENABLE_MEDIAFOUNDATION) # WINVER=_WIN32_WINNT_WIN7
  endif()
endif()
