class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.0/graphviz-14.1.0.tar.xz"
  sha256 "d532ed4bf1449d0cfa44a532d033a8894290fd2d990afbc2a29091abcd2d9cb3"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "434f27697f7db4d89ca8ea0cdaba2c0935ef72dd3273a9b4a5957e31ccb5e979"
    sha256 arm64_sequoia: "5f5fb6b7bb6c9f99c32abea7ea68920dbb4118b8ea1f307b361d6bb0e36fe723"
    sha256 arm64_sonoma:  "d15df07f021a81760efb1a1c46e1958d91297c8685fa4f2af49f28a0982af038"
    sha256 sonoma:        "c4444acdf1ef74283e7d1e7cd5576c30e8721964ce34488403330be683e3cae9"
    sha256 arm64_linux:   "173a5e2ac5cfe7ec9c6f8f4e5be5a3b9ebf4b70238b2eb9678b2b39a92c11f13"
    sha256 x86_64_linux:  "b312fbd55d818042c33e411653810a8467fa2ef2ef7cd25c809142fb23e1c55c"
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