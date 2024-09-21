class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.6.4.tar.gz"
  sha256 "d9361abc5ce63821bfce0c72a921a74bedc366856413f09221ce9592af45d8d5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcd99df794b1712bc5c5b2bcce44dcd7200bb68633bf074070ced16ce6e4dbec"
    sha256 cellar: :any,                 arm64_sonoma:  "b21f01e4114fe2ee263789d287bdc41f34895c7cb1a2357a2fcc014b8131b9f8"
    sha256 cellar: :any,                 arm64_ventura: "05faacdf10bfd45f820543a1be54828cdea0845fc9a6f8694e1dec87da6b3de9"
    sha256 cellar: :any,                 sonoma:        "5dbf74c73f2edbb616e0801c4460414f953782fe87e7b69fd8e2cea70fd1164b"
    sha256 cellar: :any,                 ventura:       "4ee8cfecb6c789fe819e3b5f336bf1670575e54fd7440926b7a8a9d4b5ee5de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d4b10a2f5ef83fceec4857570286eb0fe2bfbb7627f9a60d5b18783644def2f"
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