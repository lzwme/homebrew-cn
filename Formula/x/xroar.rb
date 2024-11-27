class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.7.2.tar.gz"
  sha256 "937b751ac6b553e399506863585dca912b21c62ff6ad9bb40cca35de00cf0924"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ccfa0dd915cfdc60742e1b285352184ef951b2357daa535e2dbed6bd6d29e73c"
    sha256 cellar: :any,                 arm64_sonoma:  "73ff267a6221e26c1752a97980fc43b37c86f8db612d839fd3c00b667bc25031"
    sha256 cellar: :any,                 arm64_ventura: "35527c68bcb1b9d2e45b6324f17cd08cebab932cae3271c4558c2c3d62f9713f"
    sha256 cellar: :any,                 sonoma:        "ec53965fb323f21ed79b675ab8dc69f3bc28d828bcdb72307dc35779e17eb3f2"
    sha256 cellar: :any,                 ventura:       "14b4c9936123103183d48a34f8f194065adae8c18f41cc6235f925d814dc1d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938c54d98571124f9cfb6aa0b3b96d7054773ada989f67127965178a8548901e"
  end

  head do
    url "https://www.6809.org.uk/git/xroar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "pulseaudio"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", "--without-x", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"xroar -config-print")

    assert_match(/machine dragon32/, output)
    assert_match(/machine dragon64/, output)
    assert_match(/machine tano/, output)
    assert_match(/machine dragon200e/, output)
    assert_match(/machine coco/, output)
    assert_match(/machine cocous/, output)
    assert_match(/machine coco2b/, output)
    assert_match(/machine coco2bus/, output)
    assert_match(/machine coco3/, output)
    assert_match(/machine coco3p/, output)
    assert_match(/machine mx1600/, output)
    assert_match(/machine mc10/, output)
    assert_match(/machine alice/, output)
  end
end