class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/14.0.0/harfbuzz-14.0.0.tar.xz"
  sha256 "d4aa312728136e3dc7c3cda47b871614ce0d12bbb19f9dcac2ea70de836dc307"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8afb5ed5c0de07ba500959b3166b31175e96e89330a57516a894d72eb296163"
    sha256 cellar: :any, arm64_sequoia: "b0e7d22d3d41729a23207bd5e364bd73b238f9b37a6e7151c13ae463dc351c94"
    sha256 cellar: :any, arm64_sonoma:  "7b16e9aa16083df34ed4d23339fe623dc3454c5f30c15045b25e72bbf50c657a"
    sha256 cellar: :any, sonoma:        "70936fc82c48f76ad3c943221bc265b2417193c97c3123f0990e278638985402"
    sha256               arm64_linux:   "54e6a47e6c690081b5df55249ed441ccc5bcc26c25149aed0e52ecd9349656d9"
    sha256               x86_64_linux:  "96c947b5c39d932e7685c4e8efee34025ef5733c07fcfd5270130e81c09a3be4"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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