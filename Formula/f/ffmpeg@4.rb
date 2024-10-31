class FfmpegAT4 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-4.4.5.tar.xz"
  sha256 "f9514e0d3515aee5a271283df71636e1d1ff7274b15853bcd84e144be416ab07"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(4(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "8cd274fed127a329542b1cffbb42d89a8a17ada501932a2c7bff212ad20c517d"
    sha256 arm64_sonoma:  "553bd8964c5f9d4554f1a4dceae9c33a64a4b0eb9c9e51fa909d84672cf56a33"
    sha256 arm64_ventura: "688eb32df8983b0b3c62182b0723290f489353cad94464ac127f863597c4ad7c"
    sha256 sonoma:        "4983648a259c4c29cbe58f5bfe67186f8a681ca4ae53c62bfdc32ad04a16fb57"
    sha256 ventura:       "04ef93dc3b527fa1dc8f6cd75258d0fd653228c2700d7270e19356344965418e"
    sha256 x86_64_linux:  "2e0b5fab250869f1aceb769c23b5bfbba2abda7612cd28a1f0936889f0d5988e"
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