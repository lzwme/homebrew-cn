class FfmpegAT4 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-4.4.6.tar.xz"
  sha256 "2290461f467c08ab801731ed412d8e724a5511d6c33173654bd9c1d2e25d0617"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(4(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "a2508966724fb12078b2e0b981aedeb7b18dac5f3995b5e5388c53297e50551f"
    sha256 arm64_sonoma:  "92e153df0f123bd5ceb1c0c88de8bde25007a1622ec19b7081e63548077ad7db"
    sha256 arm64_ventura: "587159f4bcc8b40e784bdf5fbb8d6165398fbd024ccfb866b6d69ba278862939"
    sha256 sonoma:        "9b40b097dce999c56d0889d2a7184b45a72e164273d7900af73b8e03187c7cff"
    sha256 ventura:       "56a95d8b566303ce1cf4f9deb56cf5a11c8cb0d132ea5b72979b6b20b82452d1"
    sha256 arm64_linux:   "d8932f2f98065daf06f10fc6c26f296eac95c9067fe4c11734045c8580fc2e38"
    sha256 x86_64_linux:  "40167f3f7c6eb31238a6e04780b9361f1a212e3fcb3b51c0f371c30f4d027096"
  end

  keg_only :versioned_formula

  depends_on "nasm" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "librist"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "libvpx"
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
    depends_on "libvmaf"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxv"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-avresample
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-libdav1d
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librist
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libtesseract
      --enable-libtheora
      --enable-libvidstab
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
    args << "--enable-videotoolbox" if OS.mac?

    # The new linker leads to duplicate symbol issue
    # https:github.comhomebrew-ffmpeghomebrew-ffmpegissues140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system ".configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools*"].select { |f| File.executable?(f) && !File.directory?(f) }

    pkgshare.install "toolspython"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath"video.mp4"
    system bin"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_path_exists mp4out
  end
end