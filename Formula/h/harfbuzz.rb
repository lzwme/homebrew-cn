class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/12.1.0.tar.gz"
  sha256 "0238bf7ada6b1fb92984f69f8b9cd66518af83cf24f7db1cfe60c772c42312d3"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "e9b384e96325c4ca7f168c046051e7fb7e0c68f8c42dade3318f4bdbfbffdf7b"
    sha256 cellar: :any, arm64_sequoia: "b4db264daa19318a3e8e3368e2e38a1dab65fab75123dd056a646362a21095d1"
    sha256 cellar: :any, arm64_sonoma:  "0e340bd24ca32456b06c065347f74cb6b9a427a814f7d1909dd527d3778d40c2"
    sha256 cellar: :any, sonoma:        "8723a67520f71142fb80d9a68ec9d431f5e8d9c93f277a668414588890912895"
    sha256               arm64_linux:   "866e1da31dd7decdddc5785a6d6e079b7ff52c17f32aefa6175b3433fe8591e8"
    sha256               x86_64_linux:  "b736960d0c89b51ba4ec9ce7ef298ec459d80777ca6151a217d55a09b47c9d18"
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
    system "python3.14", "-c", "from gi.repository import HarfBuzz"
  end
end