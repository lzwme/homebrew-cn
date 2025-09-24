class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.5.1.tar.gz"
  sha256 "624ddaa8211a57b538360555f7358dac9fa7a9e6000b65de06a91dbb392882ca"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8bf7b92c754188b77f2a32733ddac523c17eb3770bbad2cb6552a95ba434b743"
    sha256 cellar: :any, arm64_sequoia: "46d771d4013faa433fb265e94c33dec31950b67211e61d7c329dab5d93a668be"
    sha256 cellar: :any, arm64_sonoma:  "e161fe0d132ea173c3bcd2bc6eabe93223ec01ddec20148a37aa500ba6f44675"
    sha256 cellar: :any, sonoma:        "5868225ca1f7ab478f715fa9b95de8c1bc0bccb3a10cfbe64a45435ce19b31e9"
    sha256               arm64_linux:   "a8bfc277129b406762fd56a2a9390b961b94fc8a03e257f9d9629d650f4145ac"
    sha256               x86_64_linux:  "a6353d8678871c08abd60daed4101b85f8e6fb8dc944cba67f2bc97e9d23dda8"
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