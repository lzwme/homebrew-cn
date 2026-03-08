class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/13.0.1/harfbuzz-13.0.1.tar.xz"
  sha256 "3553d943401c34ab9b8c75f35cdb8452ca660233b0e9d4a22395ce5245484bd7"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12b132c9f3922090644c06959103f2a392ca93c483d4df0e08f9934eb85e6c37"
    sha256 cellar: :any, arm64_sequoia: "16aca123c1c3f13478590b9b885a109bfbe06998e19c9b8a56691a239721cfbb"
    sha256 cellar: :any, arm64_sonoma:  "8191cf2b352d0706a4019928d89efb41adef807e7b0bc14600f21710de6e8e04"
    sha256 cellar: :any, sonoma:        "1114809a07a4425f230b388289637f64b1b1464078ea85d050ed7a04c9380a19"
    sha256               arm64_linux:   "faee826c2d8815bd2dcdaa8ab35e0b3ed398eaf1ba80b681b7176fdd5c89ae28"
    sha256               x86_64_linux:  "1a4adc654714b5a0a44c0c68b3869b20f04d84d4f3d8938b2fde77e9b7565dc0"
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