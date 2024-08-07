class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https:graphviz.org"
  license "EPL-1.0"
  version_scheme 1

  stable do
    url "https:gitlab.comapiv4projects4207231packagesgenericgraphviz-releases12.0.0graphviz-12.0.0.tar.xz"
    sha256 "720d5392ccab391d50ac2131048705285fbd3fe8948cdb27c7e7b56160d11a9f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "c790fb58a57e9a2f14aa39a9f4800f18a1b525f875ad43a3c40394ad999e025a"
    sha256 arm64_ventura:  "7a0e25895fcbab177a78f78b99af58686c6a331602f457b87d4105d72ec7476b"
    sha256 arm64_monterey: "83682aaeca3ff91c043fe1a90c47cb3f9d0e065cf30e85cf19b8b1e91eeac180"
    sha256 sonoma:         "ab4541983b25a8923f6ab00b72713fa7c6e6536dfe3305e6cf35db363cd7b67e"
    sha256 ventura:        "d53c13c80166432394c6b7f40e026f41f3ba6a3047944a51d648e5dc15bdd471"
    sha256 monterey:       "6975b66387845eb2873d48e3019744a7801206a90df1272214c9c0562dfc3e0c"
    sha256 x86_64_linux:   "e3fba2a4b9202b094602c4d4edb887a0cece286f595057682512fc613185359b"
  end

  head do
    url "https:gitlab.comgraphvizgraphviz.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
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

    system ".autogen.sh" if build.head?
    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system bin"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end