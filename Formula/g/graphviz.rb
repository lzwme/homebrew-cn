class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.0.1/graphviz-14.0.1.tar.xz"
  sha256 "2450df5d80c68f13f26362fafa797b2fbf887ebdc6733920cc5f7df5bec0cd23"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ad2df6afad074bcf0cff4e4050c035f78fb9f2cc089c04951c1116097d01021e"
    sha256 arm64_sequoia: "d12a926ca4d480ac297821c38e13d8eb0a9d2a29b23ee4df1d58616f97df629a"
    sha256 arm64_sonoma:  "fbf22998a13c95597a60b03990d23258fe94d87b7733d012994a7bb28875a104"
    sha256 sonoma:        "2e354d91e4c88c1797c8db0098dcd645058128fc9b78a0c49563b3b9ab43e887"
    sha256 arm64_linux:   "26c6b4c4560fa7fef9ce7d39b7b1674165d5749920efc0ce511583c66930563e"
    sha256 x86_64_linux:  "404c8157f691786e83f35fbdca34079206ef0ddae4a33aee2e46842c0486f55e"
  end

  head do
    url "https://gitlab.com/graphviz/graphviz.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"
  depends_on "webp"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    args = %w[
      --disable-silent-rules
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-gdk
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-freetype2
      --with-gdk-pixbuf
      --with-gts
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end