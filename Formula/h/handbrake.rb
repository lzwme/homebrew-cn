class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://ghfast.top/https://github.com/HandBrake/HandBrake/releases/download/1.10.1/HandBrake-1.10.1-source.tar.bz2"
  sha256 "eafa87d64b99c457240675f6b89a7f6aa3c1eb56352ec057a0a0949ba449fe8e"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73e3779f544c82080f013f96cdb7ec5e76d9d018a7244c7fed7f6d830216a9e2"
    sha256 cellar: :any,                 arm64_sonoma:  "7794d9edb3ffe560774d9ec00db5992bc900f847ca28c87df84251a34f8b43c0"
    sha256 cellar: :any,                 arm64_ventura: "bea23ce93467204404fac8cb461f162dde5ce5b8d775d39bef7ec85bee5e4454"
    sha256 cellar: :any,                 sonoma:        "71a39bd0e91c8383a9ddf3d2d78029d2fb00f4b2809e6dbddadf9831f4231955"
    sha256 cellar: :any,                 ventura:       "2822759289bafa7b29e5df3e2f1f0b101f59ffa4f63b20469bfbd0c325a4755c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f49a99f61d05f19f70c28568455b552a1e78736be1dc15816861bc01079d47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b2132c55ed38ea390c0920eb645cf15f09d627608cc563285cb573ca638af1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "yasm" => :build

  depends_on "dav1d"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "jansson"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libdvdnav"
  depends_on "libdvdread"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "speex"
  depends_on "svt-av1"
  depends_on "theora"
  depends_on "x264"
  depends_on "xz"
  depends_on "zimg"

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "numactl"
  end

  def install
    # Several vendored dependencies, including x265 and svt-av1, attempt detection
    # of supported CPU features in the compiler via -march flags.
    ENV.runtime_cpu_detection

    # Remove bundled dependencies and use homebrew formulae
    # ffmpeg : error: use of undeclared identifier 'AV_FRAME_DATA_DOVI_RPU_BUFFER_T35'
    # x265 : error: no member named 'ambientIlluminance' in 'struct x265_param'
    libs = %w[
      freetype fribidi harfbuzz jansson lame
      libass libbluray libdav1d libdvdread libdvdnav
      libjpeg-turbo libogg libopus libspeex libtheora
      libvorbis libvpx svt-av1 x264 zimg
    ]
    inreplace "make/include/main.defs" do |s|
      libs.each { |dep| s.gsub! "contrib/#{dep}", "" }
    end

    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"

    if OS.linux? && Hardware::CPU.arm?
      # Disable SVE2 for ARM builds, as it causes issues with the x265 module.
      inreplace ["contrib/x265_10bit/module.defs", "contrib/x265_12bit/module.defs", "contrib/x265_8bit/module.defs"],
                "-DENABLE_CLI=OFF",
                "-DENABLE_CLI=OFF -DENABLE_SVE2=OFF"

      # Fix AArch64 assembly for pixel-util.S
      (buildpath/"contrib/x265/A09-aarch64-fix.patch").write <<~PATCH
        diff --git a/source/common/aarch64/pixel-util.S b/source/common/aarch64/pixel-util.S
        index e2b31e4..1bcaf4a 100644
        --- a/source/common/aarch64/pixel-util.S
        +++ b/source/common/aarch64/pixel-util.S
        @@ -860,7 +860,7 @@ function PFX(scanPosLast_neon)
             lsl             w13, w13, w6
             lsl             w15, w15, w6
             extr            w14, w14, w13, #31
        -    bfc             w15, #31, #1
        +    bfm             w15, wzr, #31, #31
             cbnz            w15, .Loop_spl_1
         .Lpext_end:
             strh            w14, [x2], #2
      PATCH
    end

    ENV.append "CFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2" if OS.linux?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end