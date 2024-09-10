class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.6.tar.gz"
  sha256 "c1b981b1c0b53ff4ea04a62d8ff5a02e391f365abd7b709a90c99a4d162abba2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f0496b96599dfcd52480197d66a0f3a9f2a6ebbabe6f39c3acbe1ed14db32da4"
    sha256 cellar: :any,                 arm64_ventura:  "bfe32a0d00748395cbfa201ba3c69ae6bc47fb8c056bdbb7b892ddc13e426f14"
    sha256 cellar: :any,                 arm64_monterey: "c74638cc13599e139cc63bc12a367b17515cb896cbb1db822ba827ba395afa78"
    sha256 cellar: :any,                 sonoma:         "27ec8fe70f1d45dccff63fcdccea4bfa2434cd7d289005e7e6b950a65af571ee"
    sha256 cellar: :any,                 ventura:        "c4f7213df9b0b62d4a80aebf61cdd82e2d758839f045d56a0db4959150534e70"
    sha256 cellar: :any,                 monterey:       "fab97bd38b5788eecd4417805cd5fab418305cd14827908dedf32cad506056e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7004c2c1d0db6a48d069d300c3bb5675a46c6aaa1c2f65b5c9d26c34096aec41"
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