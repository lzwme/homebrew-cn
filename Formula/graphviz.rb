class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "8.0.2",
      revision: "cd2cd8f282a5d11f38ddbf4ffbeb4bdd77c489e9"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "4824fc5108cc3fec7a545fc4e6dd50888b854a053dadc84283e5b51b485a7dfb"
    sha256 arm64_monterey: "e5809aace3415fb8d75e5926a5fbdb5996e19c357342d1aa235d3174e435cd86"
    sha256 arm64_big_sur:  "224310de62eca969c0b6c2af16d1a3900fa2e8159eb895671730ebb87ca687f9"
    sha256 ventura:        "95e277bb062a78006416236bbaccc72b08b3426e297378af28b60c0e4d40447b"
    sha256 monterey:       "03b50571ab37e17be2073d9502a7625789a4ebb3b8bb46d8e24ef86f0f622a82"
    sha256 big_sur:        "05a48ca168c0e0bc7c8ff95ce8d7f3ea0fd801812f81072b5b74d7a8ffb46292"
    sha256 x86_64_linux:   "43cf5297d782aac6dbd0cc3af8babbfcb28df3143ed1adbeae29d420444632d2"
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