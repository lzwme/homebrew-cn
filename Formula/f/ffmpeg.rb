class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-7.0.2.tar.xz"
  sha256 "8646515b638a3ad303e23af6a3587734447cb8fc0a0c064ecdb8e95c4fd8b389"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comFFmpegFFmpeg.git", branch: "master"

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "f304b6bf3b67183b9b390ce3e62fcb4eb02c8da31456c540f4c8bbe7d2d6a220"
    sha256 arm64_sonoma:  "afadd6a7d7698e1bb21bff339c787e8fef3e9678d29b2f4c8e09713527b96b4a"
    sha256 arm64_ventura: "5cdfdc7387f2a446a7f9d452b88f87f4f68643432aaf6f742f47164b4236b857"
    sha256 sonoma:        "44e41ccf552d92157f54d337a1b38282c0ea23b5e8fc62cb9792c7a6393453df"
    sha256 ventura:       "18c1dc237917c54dba4dc22e31bcea3b4f7a97ea5173434f354ea0fb17a88067"
    sha256 x86_64_linux:  "114b2aecc4519f4fc762b2b4e691b9e3beb8da10c4a58148212b1ab84624c92d"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "aribb24"
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "harfbuzz"
  depends_on "jpeg-xl"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "librist"
  depends_on "libsoxr"
  depends_on "libssh"
  depends_on "libvidstab"
  depends_on "libvmaf"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "rav1e"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
  depends_on "srt"
  depends_on "svt-av1"
  depends_on "tesseract"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"
  depends_on "zeromq"
  depends_on "zimg"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libarchive"
    depends_on "libogg"
    depends_on "libsamplerate"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxext"
    depends_on "libxv"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  fails_with gcc: "5"

  # Fix for QtWebEngine, do not remove
  # https:bugs.freebsd.orgbugzillashow_bug.cgi?id=270209
  patch do
    url "https:gitlab.archlinux.orgarchlinuxpackagingpackagesffmpeg-raw5670ccd86d3b816f49ebc18cab878125eca2f81fadd-av_stream_get_first_dts-for-chromium.patch"
    sha256 "57e26caced5a1382cb639235f9555fc50e45e7bf8333f7c9ae3d49b3241d3f77"
  end

  def install
    # The new linker leads to duplicate symbol issue https:github.comhomebrew-ffmpeghomebrew-ffmpegissues140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libaribb24
      --enable-libbluray
      --enable-libdav1d
      --enable-libharfbuzz
      --enable-libjxl
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librist
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libssh
      --enable-libsvtav1
      --enable-libtesseract
      --enable-libtheora
      --enable-libvidstab
      --enable-libvmaf
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-libspeex
      --enable-libsoxr
      --enable-libzmq
      --enable-libzimg
      --disable-libjack
      --disable-indev=jack
    ]

    # Needs corefoundation, coremedia, corevideo
    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    system ".configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath"toolspython"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath"video.mp4"
    system bin"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end