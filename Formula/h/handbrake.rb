class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://ghproxy.com/https://github.com/HandBrake/HandBrake/releases/download/1.7.0/HandBrake-1.7.0-source.tar.bz2"
  sha256 "0a1ad417e921175417af0761dc47f7ba950c72b6351ec0dcbea5a5398bd6f6de"
  license "GPL-2.0-only"
  head "https://github.com/HandBrake/HandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a15acc88927a27a9c6460903a552b03a15b3577daec94c241df1b83561fc0218"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6dd8caecbccd034a28b34ac8526e7dde72c6c379e68ad0dfa444a8874ecaf25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db92e7c3943e103316c6ca530e6ea3c167b4e269dc8894adff3c05bb333ead36"
    sha256 cellar: :any_skip_relocation, sonoma:         "4610a843648f844ded8c65516f4f81acb697a1bd2996ab5f756e34eb0b5141e1"
    sha256 cellar: :any_skip_relocation, ventura:        "b893bfce604843b6fb27a7dbc341b18a2b06d3875cc10708c06713c9ef09023a"
    sha256 cellar: :any_skip_relocation, monterey:       "63939bd404187d90c6a06cbbf3a7c5361335b5d44fdb18cdf8ec5d49295967fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4234e972147e9aa113dfd681df6003999d95e2f42925192f0a0b677f9fb10176"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on xcode: ["10.3", :build]
  depends_on "yasm" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jansson"
    depends_on "jpeg-turbo"
    depends_on "lame"
    depends_on "libass"
    depends_on "libvorbis"
    depends_on "libvpx"
    depends_on "numactl"
    depends_on "opus"
    depends_on "speex"
    depends_on "theora"
    depends_on "x264"
    depends_on "xz"
  end

  def install
    inreplace "contrib/ffmpeg/module.defs", "$(FFMPEG.GCC.gcc)", "cc"

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