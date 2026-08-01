class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/14.3.0/harfbuzz-14.3.0.tar.xz"
  sha256 "16070d77cfc4ba1f1e7327e83bf9b3f55898081cabdb94e56a33e04fc8874eae"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4d727f73af8892743817d9557e139866060de41302e1e6461908e9d31e2aa0a"
    sha256 cellar: :any, arm64_sequoia: "a056c8d6430223a0a1f0a9d31f6b04cd96fdcb88c74da40a61892d18243d347a"
    sha256 cellar: :any, arm64_sonoma:  "131f1b4340bdeed93485dec65fe04011bb62919bb13f69d86ddb5cf448817374"
    sha256 cellar: :any, sonoma:        "27a8737e7b05ea45b32bf727c32d87cfed2505840a07888a40d94ec742370a88"
    sha256               arm64_linux:   "e09e8d00dfef668abbb126cb8699857b41a254df86f3e511e7236e5d86be32f4"
    sha256               x86_64_linux:  "ddec7f52274aa95bd5ca762c97024de8d4bd10e7a4233511914dfd2696b6182a"
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