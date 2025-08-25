class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.4.3.tar.gz"
  sha256 "46efd53e7dc2acb5568e06e338ccbbee85007017628c9f583551cb1e8325d71f"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "93920145998346f1af0b102296acc821481211a27098883d91e11e1a96e39413"
    sha256 cellar: :any, arm64_sonoma:  "5ec99ffe20d1c7778d1a90e430b2158eea6fa069cfbd2826f1e3eda050237549"
    sha256 cellar: :any, arm64_ventura: "0c134bdb8fde24e706dc50545061c09b8bef93a1268de1056d64e3d467e33bd6"
    sha256 cellar: :any, sonoma:        "5dfa537cc78ff5c18a964883dfb0ea9c6f42d6fda07eb7f589853e5e9a3fd61e"
    sha256 cellar: :any, ventura:       "05df990874b11dff3a8605352edd799e827255685623c06c0d3304dea15d094c"
    sha256               arm64_linux:   "cf6d73b33840f0ccde1b569df581b5fa0de0066202802214f338d92fb41f880d"
    sha256               x86_64_linux:  "f6b9afef1319b6387c17d4358b989ffce18ebffc1b4e0da8c6065302c74ef336"
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