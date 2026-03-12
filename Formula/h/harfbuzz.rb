class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/13.1.0/harfbuzz-13.1.0.tar.xz"
  sha256 "a9959a0db77554d266803e1e524249ed4504695fef63524aebca749ac6260a7f"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "987d5e6fe5f482087049e5bff3db9883eda79da47e54697ba519ce09976952c4"
    sha256 cellar: :any, arm64_sequoia: "b5b9aee1e46362283d2edae809606b750e95b5caa0f5f2db571c09af9643d8b5"
    sha256 cellar: :any, arm64_sonoma:  "24930f4e86049212cd64f03120e8746b19f5e530f2222d49f24325aadc447cc2"
    sha256 cellar: :any, sonoma:        "a9f9f3e58710a6a3831f3bf5e94466984d3005fe6593333e560da6af0437e3c8"
    sha256               arm64_linux:   "71c557fd6b2e059181795747dd71722688172c25d9128d41c42a3e06067d16c7"
    sha256               x86_64_linux:  "efccaf938c20749ca788bc74bc9c950837dd7ab4a0cb82d2ab552947de7ade12"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@78"
  depends_on "libpng"

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
    system "python3.14", "-c", "from gi.repository import HarfBuzz"
  end
end