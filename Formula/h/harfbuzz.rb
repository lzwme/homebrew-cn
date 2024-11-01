class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https:github.comharfbuzzharfbuzz"
  url "https:github.comharfbuzzharfbuzzarchiverefstags10.0.1.tar.gz"
  sha256 "e7358ea86fe10fb9261931af6f010d4358dac64f7074420ca9bc94aae2bdd542"
  license "MIT"
  revision 2
  head "https:github.comharfbuzzharfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "aefbd0dc673b6ac8c680e73113a9341e92e9bbecefb0b651214b4c1772c1d0f7"
    sha256 cellar: :any, arm64_sonoma:  "022fc58cf542375163e9bd5ea65cad2bddf23c81d8dc7424d3815d1f6ebea25c"
    sha256 cellar: :any, arm64_ventura: "567e507de1a1dba9ae2183f40b5eab427e02f021c9ebaad3b8e110e0fb751b63"
    sha256 cellar: :any, sonoma:        "a7a541d7239372f5cda14d6afd3bc98bfcccb2bf2615be73b79eced2bbc48e48"
    sha256 cellar: :any, ventura:       "88470083fcb616bbbce103345773ac226fdfff4fdd572424c569430a58c8726c"
    sha256               x86_64_linux:  "3a8df5b0bc86fdf08c52a240343c1c6c7ebc96c4694d48e33b42d823f3368d35"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@76"

  resource "homebrew-test-ttf" do
    url "https:github.comharfbuzzharfbuzzrawfc0daafab0336b847ac14682e581a8838f36a0bftestshapingfontssha1sum270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
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

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.13", "-c", "from gi.repository import HarfBuzz"
  end
end