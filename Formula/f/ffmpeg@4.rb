class FfmpegAT4 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-4.4.4.tar.xz"
  sha256 "e80b380d595c809060f66f96a5d849511ef4a76a26b76eacf5778b94c3570309"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(4(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "4f5ace691cad243ec96c11a9c76c5837195dcea7553f5ed64023226ddefd39e1"
    sha256 arm64_ventura:  "6a82e473024dd933cf00f49b9b839abf4fd6074c58890ae7717b46014d5507b6"
    sha256 arm64_monterey: "273acec6bbcd0ff8e8d5292025e9bb64a9c47418d0d9e074d1fae7135dd810c3"
    sha256 sonoma:         "04cf6ba8ef77cb81f6c565b02edf82647bc86c35c00365c481cf998c06fa8ac8"
    sha256 ventura:        "ea321a2ad09b9789042b9c794f7544a21ac90ff2cb2531d245f417690e8dadd1"
    sha256 monterey:       "aa6490e2a0d3e81bdf09ae1a6433a30acce409e9968ec0577ab33fb84f011784"
    sha256 x86_64_linux:   "12a824150d597e520ad0ca531cc6e73f2d363ba913b4f2e285693eb9de590a2f"
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
  depends_on "libvmaf"
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

  # Fixes assembling with binutil as >= 2.41
  patch do
    url "https:github.comFFmpegFFmpegcommiteffadce6c756247ea8bae32dc13bb3e6f464f0eb.patch?full_index=1"
    sha256 "9800c708313da78d537b61cfb750762bb8ad006ca9335b1724dbbca5669f5b24"
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

    # Replace hardcoded default VMAF model path
    %w[docfilters.texi libavfiltervf_libvmaf.c].each do |f|
      inreplace f, "usrlocalsharemodel", HOMEBREW_PREFIX"sharelibvmafmodel"
      # Since libvmaf v2.0.0, `.pkl` model files have been deprecated in favor of `.json` model files.
      inreplace f, "vmaf_v0.6.1.pkl", "vmaf_v0.6.1.json"
    end

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