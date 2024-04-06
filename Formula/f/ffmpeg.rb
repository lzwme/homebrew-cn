class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https:ffmpeg.org"
  url "https:ffmpeg.orgreleasesffmpeg-6.1.1.tar.xz"
  sha256 "8684f4b00f94b85461884c3719382f1261f0d9eb3d59640a1f4ac0873616f968"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 7
  head "https:github.comFFmpegFFmpeg.git", branch: "master"

  livecheck do
    url "https:ffmpeg.orgdownload.html"
    regex(href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "973e435d6fc2e2b45da23221e656edd544eaf50be45140aa260a495f87b97e40"
    sha256 arm64_ventura:  "f0565860b29b18ce59068a726bb48d240f85ca80d9c38026e1d636394a5cb36a"
    sha256 arm64_monterey: "4a93890954c0a9ca2e23e0af60fb71a0b9407a459b99f9ac21708f1a8305e0d6"
    sha256 sonoma:         "39344b91b4730ad5a4660bc48f647a7148bc83bd14912550b1501e4a97b2cc45"
    sha256 ventura:        "38824d1b0703ba9969b4357c83cb6585248394807aef5615cb12993144dc95c8"
    sha256 monterey:       "f03f5ceb30bcaf74fa045988ab237867855705eab01cc8d4a11ba48268398424"
    sha256 x86_64_linux:   "509cfdd22223985f59fc5ac441535e3dc1b0a759c116b9abf51e79d1429b4421"
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
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "openvino"
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

  on_linux do
    depends_on "alsa-lib"
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
      --enable-libopenvino
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
    bin.install Dir["tools*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin
    mv bin"python", pkgshare"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath"video.mp4"
    system bin"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end