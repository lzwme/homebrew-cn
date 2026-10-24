class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/15.0.0/harfbuzz-15.0.0.tar.xz"
  sha256 "968536e9abd782f07f7954044c0c4020199fcdd39b41d221ec42d2a3be4a44df"
  license "MIT"
  compatibility_version 1
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6d406ba9a599aaf0cda1f57aa1cde191e3e6839b655c374cff08e7d0ccc923fc"
    sha256 cellar: :any, arm64_tahoe:       "31457bf639bdee6e9d70a8e167f9e4354f60277d02d2a29b8deec7d15ea2b185"
    sha256 cellar: :any, arm64_sequoia:     "90c783573c9a81fe679751aa9e2f66da7bc4a935aca3482efcc88da07c8a5ccb"
    sha256 cellar: :any, arm64_linux:       "62d538c3bbafca523a69e25a82ef6632036da8b0583626f079257c6bd88300a9"
    sha256 cellar: :any, x86_64_linux:      "114c87db7de0376e9180dba598e5f024d0019e8619ffdc843b4125d84bc8c090"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
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

  resource "homebrew-test-ttf", :test do
    url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  # downloads test resources
  allow_network_access! :test

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
    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system python3, "-c", "from gi.repository import HarfBuzz"
  end
end