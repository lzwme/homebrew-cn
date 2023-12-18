class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https:handbrake.fr"
  url "https:github.comHandBrakeHandBrakereleasesdownload1.7.1HandBrake-1.7.1-source.tar.bz2"
  sha256 "733e42c8f254f6c2f8f6b40f0d3572fd49167ebf30742beae605effa16939edc"
  license "GPL-2.0-only"
  head "https:github.comHandBrakeHandBrake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e9cd30f03be5c3edd01042c85c6cd1f6a7d56601dcbd1c42a57ff8f444b491a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e964027232e1102b2cf75f43b0e5a9d3d6bb6c137f678cb45415ba07778e835"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fd014e139a118df2b3ebb415aae6f19169a6271580141a9e6d8abbd59a03d6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "af6f09a01a00f3f8256e0acd697958371e2a5bfd540d6cb56219c36e63a0f773"
    sha256 cellar: :any_skip_relocation, ventura:        "b5b1e8ed2b6cc0cf44df314eed1342bc0e5b0eda47b2abe549e548e6ebd3943d"
    sha256 cellar: :any_skip_relocation, monterey:       "bb7afa429f1effe3867e5684d1754273b610664d7a6bb7842d4ee74a8af4b7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e4823f7e52e71f7333d7d916c2fb5c563fb808de74ed1b4c7cef8253101d89e"
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
    inreplace "contribffmpegmodule.defs", "$(FFMPEG.GCC.gcc)", "cc"

    ENV.append "CFLAGS", "-I#{Formula["libxml2"].opt_include}libxml2" if OS.linux?

    system ".configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin"HandBrakeCLI", "--help"
  end
end