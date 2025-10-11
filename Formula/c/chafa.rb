class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.16.2.tar.xz"
  sha256 "657898dd9a89b45130a44c1efe1fc03e2c7bd00c2f543ed7111613cb9e7861df"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eb1e2282d672d0439434d1519b04e6d8e3202ab7edd295cb9f284514de065a07"
    sha256 cellar: :any,                 arm64_sequoia: "44ef52795c501e98e7d1e213967f665589688c4fa487bbbbdb1ec76d8cca4038"
    sha256 cellar: :any,                 arm64_sonoma:  "ce061ba4632caaf54e69ac1695387fdfcac2869f649c3d62b629c0317d72d4ed"
    sha256 cellar: :any,                 sonoma:        "b253a0f400639cd5d42b2edb999f3feac3e09e5c17f93eeb95824a8d18abbe5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c973106fe70ff89574a8cf91014d5b1367825dbc8b66998a00445750f14dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1447ecf41721b3491d0a545ba0175dc6ee00527bf4bcd1e03acda061e1482d"
  end

  head do
    url "https://github.com/hpjansson/chafa.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    with_env(NOCONFIGURE: "1") { system "./autogen.sh" } if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1" if build.stable?
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end