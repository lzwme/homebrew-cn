class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.7.1.tar.gz"
  sha256 "39a9182ac5a07993b42d70c218b29b13f0466711e2a31c223621db00e3b813c2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc3270b973d004022c161cb40209ee6068d4ff17976c7c655f58dde66743a915"
    sha256 cellar: :any,                 arm64_sonoma:  "97fbee483101f85766de0a347abfb8ea77326d13cd01cb446fd17962c236bb75"
    sha256 cellar: :any,                 arm64_ventura: "b1ebefebdca76490c291d8d609590eb8c50ad5612a06d9784219ed31c9057315"
    sha256 cellar: :any,                 sonoma:        "e8767586ba798e84ace2a0334aee0b753dac4a809d217320d1a768f903c36630"
    sha256 cellar: :any,                 ventura:       "9aa19a5bd419edae4cb6b63f3ee6034efddb4615a1743744562fb3cd6bd2e007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1a6130cf31e99b889457339e8c39dcd47b4c88d5b9777ddfb766ea0e195394"
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