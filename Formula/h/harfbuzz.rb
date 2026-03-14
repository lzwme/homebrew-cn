class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/13.1.1/harfbuzz-13.1.1.tar.xz"
  sha256 "e7f3b8bac3fdcc529985be8e84fbd65c675ac47ee58512b15a5dd620c79ffe2a"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c15bf7bd546f4d370fcc8999a08bfd62cc8bf64e58994e62493a3657a909aef7"
    sha256 cellar: :any, arm64_sequoia: "f2363f156ebba4303bb6ffeabb870dc68f5fef06aaad880c0b8f23e793ada7fe"
    sha256 cellar: :any, arm64_sonoma:  "56bdb4020f70b7fa5bd9405e02c5787f14d95c6579130770e9b80aedf987f4d7"
    sha256 cellar: :any, sonoma:        "c0692af139d0fc05c7187539f2a5fe55a7df412e268e66fda9b6c5e366aafb50"
    sha256               arm64_linux:   "2280421146141f675ab61a191fecb426d2d31108d6a90c55212a670f913af95b"
    sha256               x86_64_linux:  "eba9dc47ac385ace75320387a4ce65c830e99289e48f6a8d1c8581f3ac23e3b9"
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