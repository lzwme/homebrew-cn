class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.4.2.tar.gz"
  sha256 "5a0608c9c02dff7c3ed9ce8536a670b892d609b418492e3b000caab05f865e10"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fa65b0f6f85c06c1405ded55c3424f2a4012d717accd30395444caff009c0aa2"
    sha256 cellar: :any, arm64_sonoma:  "4a75d42811f8f5687a4437006902cfe173302782eedd6a847f1e7ce981c053c2"
    sha256 cellar: :any, arm64_ventura: "5420381aec6a5c9b61d80c431b90933822ae35f37648771a2046c2e9016a15ac"
    sha256 cellar: :any, sonoma:        "61c097a18c23d201e20a85b83117c13baa331cf68390e50caae257f2783b6845"
    sha256 cellar: :any, ventura:       "ae15e9d3c235ed4e2ad51d77bd1eeb4c95d53b2232b4963f4547baed28b54e72"
    sha256               arm64_linux:   "c58c0eac4d206fa220d1589ccf806627cb06bb1a1d522fc3c728ee94606b195c"
    sha256               x86_64_linux:  "f558b21abeb17b57fc963d083db9418e8114eff566ab422217b8c0004f01fa9b"
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