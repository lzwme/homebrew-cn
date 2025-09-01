class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.4.5.tar.gz"
  sha256 "5bc7a571b476eeda0c1996a04006da7c25f8edbc01cdf394ef729a6ecd1296d6"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "caea11e390402d2201fa2430e4cff4a1fa0acec8b3c564f6ec792784e98fcd9a"
    sha256 cellar: :any, arm64_sonoma:  "07545fe2367614a4e4fc6665dd3738ee505358479a3adc8a6e3bc16af326da48"
    sha256 cellar: :any, arm64_ventura: "895e149d40199f23f9d28bd10f3433b0bc0bda69216ea0f7dd8d5dfd19c32942"
    sha256 cellar: :any, sonoma:        "bc7720ec7264304a5d7aee80590ee2f9302014553b10961fd366c2ac088f5caf"
    sha256 cellar: :any, ventura:       "93cdaff55c17154dd20cc85c9fce8fb52dc0edb889f68dfe44d427096f2cd5f2"
    sha256               arm64_linux:   "f4435568f5ff2177846ce4a1dff8654e08abd348e71ec9e8987785d3a4270e3c"
    sha256               x86_64_linux:  "4341c71140f804400eb56b74c3b719c5bb3949b685a8cb3a7d01b8e89c0b5757"
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