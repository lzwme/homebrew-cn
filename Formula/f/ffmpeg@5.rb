class FfmpegAT5 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-5.1.6.tar.xz"
  sha256 "f4fa066278f7a47feab316fef905f4db0d5e9b589451949740f83972b30901bd"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(5(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "60e187bca86a0511aaddd3bf0c961144bb7724ffe76b74bee81e1578d3efd472"
    sha256 arm64_sonoma:  "2a0b4d257f3d5dd05ad5ea4d9b2b223c1c92d274fb18598fdfe5c0a8962f657f"
    sha256 arm64_ventura: "f02da9244e184fc0822c2bc5d481cf75e1632bb45e7cac48a067854b132077cd"
    sha256 sonoma:        "3dedfa0a10924e3fb09b3ac9a04aea5d1da278e9ebbdf1a7b8efe23896eed3f5"
    sha256 ventura:       "c8b0cca141773d4dd3f725dd70d42db0f71a287f35e3b6bb4ae6e296a4af99ca"
    sha256 x86_64_linux:  "ce1eaff90caf0c5cc64d1d80aa1becf8f2b3d664df5624e6717df6e6b7ca4364"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "aribb24"
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

  def install
    # The new linker leads to duplicate symbol issue https:github.comhomebrew-ffmpeghomebrew-ffmpegissues140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      --prefix=#{prefix}
      --datadir=#{share}ffmpeg
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
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librist
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
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
    args << "--enable-videotoolbox" if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    system ".configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath"tools").children.select { |f| f.file? && f.executable? }
    (share"ffmpeg").install buildpath"toolspython"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath"video.mp4"
    system bin"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end