class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.2/graphviz-14.1.2.tar.xz"
  sha256 "65572cd29317cfb96eac8434fac1d8861c905e9b761bd0442beb2cfcc0211354"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a5b731cc8481bd4d3ddf41be6d433e998b5a196c14df6e05cd14e4d74a6d6e27"
    sha256 arm64_sequoia: "e519f4b2b7972590fb041a991c964ee518ca94188e83ac16a6d5c09e7638d5d2"
    sha256 arm64_sonoma:  "bffb920d73e535f994451603bcbac081854233623e5febdca3a2b806a20d9a77"
    sha256 sonoma:        "09d187086cadad98495ba2d1abf2e1fa9503fe3cd6c3da102a4897097b3a55ee"
    sha256 arm64_linux:   "98954406eb8c892cd96611e128b6b59e64a7bdd4fc7fe72bf0fc0883fd510c94"
    sha256 x86_64_linux:  "fc78052bda38b11f3f3e298d96c0ee3b8505c4c7a22e0571be0615beac2eaca2"
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