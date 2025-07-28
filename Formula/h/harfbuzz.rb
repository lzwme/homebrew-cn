class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.3.3.tar.gz"
  sha256 "5563e1eeea7399c37dc7f0f92a89bbc79d8741bbdd134d22d2885ddb95944314"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "98904ebda5dea947ef4ce81e1c9ae412cb8c5f1215fa2ecf3d2e5822fba05a8d"
    sha256 cellar: :any, arm64_sonoma:  "4bfc0f5cbce41803ecdaacfb98b7bc0ac5c21ffedeee52171855196ec8a9b636"
    sha256 cellar: :any, arm64_ventura: "247a3c35e392ecf6c0a6e24b9155a3c096788bca9da857662e24ef639135203c"
    sha256 cellar: :any, sonoma:        "33f8eb32c6409128386080cade5a4e2d7cd4fa7cd7b640fcc3cd417d59618b19"
    sha256 cellar: :any, ventura:       "7efd577fef5bc0b79806ac53d566069b424ba50e61262f36e34a00a3d32e64da"
    sha256               arm64_linux:   "2e487695f219f4f5625070d583a47b31f93fa59945bf7848a40c07c731fe1ecc"
    sha256               x86_64_linux:  "fe7605e09e46528a67f7a0b9c3ca4aa3e4520e24e28b7ba09cdc146c38d91a19"
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