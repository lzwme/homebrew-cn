class Ffmpeg < Formula
  desc "Play, record, convert, and stream select audio and video codecs"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-9.0.tar.xz"
  sha256 "7f607a00dd0d28a729d5a4811205812eef01cf6ef6155025febb6f36a9062d52"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  # Passing `--enable-version3` changes the license to GPL v3+.
  license "GPL-3.0-or-later"
  compatibility_version 3
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b11cc23021fab066662346cc686e30d1a9a80f73620ab0a842f28e249ab7447b"
    sha256 arm64_sequoia: "df7e48e54d0f0e355b7a110c77ed5589f30b6385ddc5de083d64c2709530db16"
    sha256 arm64_sonoma:  "9408ed8851acfe7abc6df4ea8da4eeb803e557e58c6d594bcea54acd3eeaa3ff"
    sha256 sonoma:        "5ec5e49eb5cce8194c390669bfaf1348f9d189da9aafa19a0438786bea80f34d"
    sha256 arm64_linux:   "3dbed52525e0db2cb3ee0bda6d07c2f4de19f5c1517d697649cec29a96c34b03"
    sha256 x86_64_linux:  "cf751c19b3e502ef241185cbf5aa66ed6ffd6e393cc225c03f9cec37301f458b"
  end

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core
  # or INCREDIBLY widely used and light codecs in the current year (2026).
  # Add other dependencies to ffmpeg-full formula.
  # We should expect to remove e.g. x264 eventually (>=2027) when usage of it is
  # negligible and has all moved to e.g. x265 instead.
  depends_on "dav1d"
  depends_on "lame"
  depends_on "libvmaf" # dependent: ab-av1
  depends_on "libvpx"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "sdl2-compat"
  depends_on "svt-av1"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

  def install
    # The new linker leads to duplicate symbol issue https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.ld64_version.between?("1015.7", "1022.1")

    # Fine adding any new options that don't add dependencies to the formula.
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gpl
      --enable-libsvtav1
      --enable-libopus
      --enable-libx264
      --enable-libmp3lame
      --enable-libdav1d
      --enable-libvmaf
      --enable-libvpx
      --enable-libx265
      --enable-openssl
    ]

    # Needs corefoundation, coremedia, corevideo
    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath/"tools/python"
  end

  def caveats
    <<~EOS
      ffmpeg-full includes additional tools and libraries that are not included in the regular ffmpeg formula.
    EOS
  end

  test do
    # Create a 5 second test MP4
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4out
    assert_path_exists mp4out, "Failed to create video.mp4!"
  end
end