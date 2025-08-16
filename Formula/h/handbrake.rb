class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://ghfast.top/https://github.com/HandBrake/HandBrake/releases/download/1.10.0/HandBrake-1.10.0-source.tar.bz2"
  sha256 "f931012ee251113d996b61aceaaef57165efcc5ea5a2705efffc4265f6b53d26"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4dc8b8de7ff4b78a1a8ec92e5d95bebb08a0ae406e3b6e76256fe3b6561c18f2"
    sha256 cellar: :any,                 arm64_sonoma:  "c0756cac988fd50b981e32d371147c3cf4bc8d237c8ae4f4ec2fac5dae8eac67"
    sha256 cellar: :any,                 arm64_ventura: "b4ee5f3a06e95a2cffaa98eb6f1caeed695f361f3ab59446c9ea1958c52ec6fd"
    sha256 cellar: :any,                 sonoma:        "a5fedc40f7461eb310779b44c6c5cbaf1ed24b8c321c317d8c0d90ae2cd87f60"
    sha256 cellar: :any,                 ventura:       "0a59bb3f7ea4b639efb2528256223b3dbc63c19626a566fa3fef9ce081ac6419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce2716664cb34296d1419b2a6c3fea5c5aaeb5dc27023d2b413cd64f2bfccdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426f0851ac394ad5358c8db2a3e0f57140650891e99c51a9231bdc5b9656f4ff"
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