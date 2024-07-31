class FfmpegAT4 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-4.4.5.tar.xz"
  sha256 "f9514e0d3515aee5a271283df71636e1d1ff7274b15853bcd84e144be416ab07"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(4(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "844f9fcfd73ff9fe92d317f3221dc4ca7c6f7f2239edc0b33241473b7d655f63"
    sha256 arm64_ventura:  "f61c7d552d5f7229796024bb48dff1b0a5bcf41b6b02d2d811035a5709698452"
    sha256 arm64_monterey: "e12fe4e2172ac35c0512c6aca98c30da73dbc86b6fe20d45e77cf8eae0a7ff3c"
    sha256 sonoma:         "797829b1631c473486ea9fa264deebdd7979e4845c0ece944f6b73cfef8f091e"
    sha256 ventura:        "58ceb35af0ba32e147c20ae074c74a4e1cc64def5d35abc211b583d90f546f5c"
    sha256 monterey:       "2e4330e21e0eeee05bf2c4dcd5363fb2f96f5380a066668116edd7eb3e2cbf53"
    sha256 x86_64_linux:   "b31766d170cd71ddaf9c14266a07e4a697d8805bd567d937ff90755b52a993e0"
  end

  keg_only :versioned_formula

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
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

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
  end

  fails_with gcc: "5"

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
    assert_predicate mp4out, :exist?
  end
end