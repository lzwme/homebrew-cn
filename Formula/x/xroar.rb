class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.6.2.tar.gz"
  sha256 "2d01721b5a8fa6933330b0d2f9690f51c6498719cb8d36c409e12e0ca82a2f8b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05dabc9546f17ba3cbab0ecfb214a00aae1bfde5bf2dd87565b87e81e4b0a8e5"
    sha256 cellar: :any,                 arm64_ventura:  "f6742becd514eb67962c9d4ea5009be2ddb86367465605fcc9ee40649076edc8"
    sha256 cellar: :any,                 arm64_monterey: "2c37cd83bf59a422fe12fda88461914639c6eed70687891344ada40f332d068f"
    sha256 cellar: :any,                 sonoma:         "fba25f473ad8705e3154b01642f9abbcab07a4ed994d386d76c098de627c1b1b"
    sha256 cellar: :any,                 ventura:        "e49d7ceb1d3049d5f4b76d8094bc903c6d326878d4ea2d80155520a6f62755cf"
    sha256 cellar: :any,                 monterey:       "339cab777090ea8990ab368ba0c211065640327e088ca52359f6b1c3dd459086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2b76bc46cd42d81fd49eba2eb5cd5e30e4885cdb60e50b5e041a2f6b0a2ea2"
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