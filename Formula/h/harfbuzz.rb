class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.3.2.tar.gz"
  sha256 "b6120ebc56238474f4030b2fbcfd235912b6adaf1477c088f4a399a942dd0ab0"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "211fb413ebdb583b370a5d34693b8a8b5490ec348d8de10b0cfa7ed7ab55ac64"
    sha256 cellar: :any, arm64_sonoma:  "ead4c118a798f20503231055ec379a4a4585faa916f79fab0d381cada7f39a3a"
    sha256 cellar: :any, arm64_ventura: "5bf16e9bc4ea207e7fcc2f38bf29fbe1bb083af361b9c4eefb77998e3a2be19e"
    sha256 cellar: :any, sonoma:        "bdffa4992925cf9808e1d5d8f99f1d19cda51dacf958df20137cb17f9ed20609"
    sha256 cellar: :any, ventura:       "77d5ce7d388bc8245fdd324ac65dd2f5c9d686092065b78474ff52857307f46b"
    sha256               arm64_linux:   "703b41b04492d1a61b6031f4d322a72c6d9232a6c094d662012073d72eab8cf1"
    sha256               x86_64_linux:  "adf77ba0cd1c703a8b4729d0f0f7ec3c3d1992e1ec37c6a28bb828dbd0268202"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@77"

  def install
    args = %w[
      --default-library=both
      -Dcairo=enabled
      -Dcoretext=enabled
      -Dfreetype=enabled
      -Dglib=enabled
      -Dgobject=enabled
      -Dgraphite=enabled
      -Dicu=enabled
      -Dintrospection=enabled
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-test-ttf" do
      url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
      sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
    end

    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.13", "-c", "from gi.repository import HarfBuzz"
  end
end