class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://ghfast.top/https://github.com/harfbuzz/harfbuzz/archive/refs/tags/11.4.1.tar.gz"
  sha256 "2cde2c6dc10c797e89045097b9f7e3e42bf30942bb2a5d4f2fadbe89b0b418a8"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "53abe6e4c73f315e62b575f55e7eddbb1057bf29a975a79f7baf79b27a91072b"
    sha256 cellar: :any, arm64_sonoma:  "8fdfd3bac6599d866f18ae7995e0fd934828a985ded5296e6dad50674a9b48ee"
    sha256 cellar: :any, arm64_ventura: "4260dfe684e13ad73bd4103521b6fe040092ccbe63cdd462d93964d8ef81ad65"
    sha256 cellar: :any, sonoma:        "3696cc9bc459b1b77648e6e06498cbcf305b8ec07ab251f1ad7c73659d9da940"
    sha256 cellar: :any, ventura:       "d54b8f1c765edfbbeb7ce2e4967093934f13a8874f29d78c7a6d24fa472eece4"
    sha256               arm64_linux:   "d792c06b4ae9c910623c50c81b076674fe88ac798e98ea1132adc7c4b3cdeacf"
    sha256               x86_64_linux:  "230111e516568da5aa4c1a37f60916f2ca6aa81c5d5e931b847aaeeefd718424"
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