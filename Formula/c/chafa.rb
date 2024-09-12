class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.4.tar.xz"
  sha256 "d0708a63f05b79269dae862a42671e38aece47fbd4fc852904bca51a65954454"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4088a5399d141f648698c3b92236fa58d2596e784004ae8c79972a973698cb40"
    sha256 cellar: :any,                 arm64_sonoma:   "4b6496dea9a09c8e11facaaedcd7e4900d7ff74304032e89755930b15ceb2f1a"
    sha256 cellar: :any,                 arm64_ventura:  "ad976beba9aab5ce79b64e1c86be92b6098a1ca95687e644630ef28b5a39be2f"
    sha256 cellar: :any,                 arm64_monterey: "d198bfeabc561f979e4e40a304374098008cc3b054ffcf90ee108b1dc13370ac"
    sha256 cellar: :any,                 sonoma:         "9de0cf619fbfbf15a68c43674e130e75e049c974c92e13b3e2d091ca89657e47"
    sha256 cellar: :any,                 ventura:        "3ac89af501682d724878ead0fc7306958207f4a97f351a9dedd6b7937d953009"
    sha256 cellar: :any,                 monterey:       "509de37d41c8b7383beec276a0a59cd5755935c05d7af53890e16a8cb9c6f0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5934a8cd7f811ec13d46cb490b218624498cc528b7ea403d3bfc0891427531b5"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end