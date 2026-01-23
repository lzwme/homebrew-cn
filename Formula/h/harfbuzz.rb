class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/releases/download/12.3.1/harfbuzz-12.3.1.tar.xz"
  sha256 "3ee7133f7f160b27bc34c058e147a559bb781c2b8208bc760db9fa9fa69cea07"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "11756fbf1d542858de871b7da5b27cfa480b4b757809c16da3e2fd0f5b1e3243"
    sha256 cellar: :any, arm64_sequoia: "a442865d0593e31615514a23815ded8bd2745725f82e01d593ee3493d050c183"
    sha256 cellar: :any, arm64_sonoma:  "cf4200539a8b77b22293b4f2c9bac0bd35881039a7f1109c66826af2c798193b"
    sha256 cellar: :any, sonoma:        "fb74d40a26a9f043b53cbb7bde5eb500e7d492b0c9de22fa2f80fd6c2a50f53f"
    sha256               arm64_linux:   "63e50dee0ecd93768b44aae812dfe8e37613a812597812598584e8c0e0be66e4"
    sha256               x86_64_linux:  "c2422ebd6de66bca072f5194f4c7b0e5a83b8421b311572b297f66e204fa5dc3"
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