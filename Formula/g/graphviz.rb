class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "12.0.0",
      revision: "a2902960366a3df263186bf099a7bfe2334fd1fe"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "c790fb58a57e9a2f14aa39a9f4800f18a1b525f875ad43a3c40394ad999e025a"
    sha256 arm64_ventura:  "7a0e25895fcbab177a78f78b99af58686c6a331602f457b87d4105d72ec7476b"
    sha256 arm64_monterey: "83682aaeca3ff91c043fe1a90c47cb3f9d0e065cf30e85cf19b8b1e91eeac180"
    sha256 sonoma:         "ab4541983b25a8923f6ab00b72713fa7c6e6536dfe3305e6cf35db363cd7b67e"
    sha256 ventura:        "d53c13c80166432394c6b7f40e026f41f3ba6a3047944a51d648e5dc15bdd471"
    sha256 monterey:       "6975b66387845eb2873d48e3019744a7801206a90df1272214c9c0562dfc3e0c"
    sha256 x86_64_linux:   "e3fba2a4b9202b094602c4d4edb887a0cece286f595057682512fc613185359b"
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
      --without-gdk
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-freetype2
      --with-gdk-pixbuf
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