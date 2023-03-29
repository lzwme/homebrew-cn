class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "8.0.1",
      revision: "8cd5300e2e31c80dbbfcdd65aad697187e5ac0b0"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "d77c78d38cd7204276561808d8dc5054619031163ff8becba5dd4cfc0a82e74a"
    sha256 arm64_monterey: "1a84534a4c9453490005bcb104d1a32edd1b4bd45516319b5d88354670333853"
    sha256 arm64_big_sur:  "015fafdbbd3bf6d0c7156db0420f4f0c7ed7e05a7b1acdeb0d99cb5df861eb26"
    sha256 ventura:        "83d6d06b87f55fd86e53e0e4c5e71cb37d9cdafd5fc7542a40695600d58db4af"
    sha256 monterey:       "f5b9a025a65eaa606096e2f99ca3e0e936cbcb68cc66d0df9319f19b2ca5b78b"
    sha256 big_sur:        "bd33f2c0f889376a25421960a429b32b77e8d07b48b43e396a399b6597581d3c"
    sha256 x86_64_linux:   "b58e1e0870c8c02def45492071439b49a8e1a0895690bd87993bf864166b0094"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end