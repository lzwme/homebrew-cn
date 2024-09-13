class Xroar < Formula
  desc "Dragon and Tandy 8-bit computer emulator"
  homepage "https://www.6809.org.uk/xroar/"
  url "https://www.6809.org.uk/xroar/dl/xroar-1.6.3.tar.gz"
  sha256 "e8e8d5563dec2b77685db1b44f4bb8bc7b76cdbdf55d06eee905d986f059dbb5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8c606b1bbed48fa8c1bc0840ac2e1152eb1aafea9d59daf8ac5d03e05aea01be"
    sha256 cellar: :any,                 arm64_sonoma:   "4e5a4c5b2671af95c92174d2622e7ce47aacffa3a13af19c13a0cf1044ed2cde"
    sha256 cellar: :any,                 arm64_ventura:  "f1cd591c5476fe261ad30a92e2a5598825ce7bd172dea3c1483266b3ab3ed682"
    sha256 cellar: :any,                 arm64_monterey: "68441cd6dafaee71289c7c4712e7b03665f8ba3b783d0e4c4f83d2d8af2c0247"
    sha256 cellar: :any,                 sonoma:         "3e1e76b6354669bd27d72e055bc0984123bf0f40d5fab6a58527e428dcae1dae"
    sha256 cellar: :any,                 ventura:        "3e30345a0d607f7beb33488a1eb6a56db328bbdc9b0f79078eedd39040e2fe65"
    sha256 cellar: :any,                 monterey:       "df607176efa0760f0e5b94f24e3d0520eaf901867319720878085bb156c4c8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ebf55e433dfde15881fc9a9f0d9baabb598efaf1c1d93f24885b6445f91005"
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