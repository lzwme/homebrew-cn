class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/16.1.0/graphviz-16.1.0.tar.xz"
  sha256 "0f661718f3e5268dc3bad0fb53ab646605d26db70f4080799aff1dc2f61783c3"
  license "EPL-1.0"
  version_scheme 1
  compatibility_version 2

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "ef2f6a5a452065bbe3f7214e9366e20f05b7cda0a1a5fe841ea323678559315f"
    sha256 arm64_tahoe:       "f7058305ab3e33cf9e6729ba7e68f0a2fed7bc7d188391be74163c8d956c28ea"
    sha256 arm64_sequoia:     "b21e979836c012ff0c48b671fc9dbf037e07e11f0b1e55ee6c67a256dc6ca9cc"
    sha256 arm64_linux:       "4e0f5b6bfa78ac2c9a1ef6a0fd8e5e0d68c82a6661659d1f49e53dc6fc819f6f"
    sha256 x86_64_linux:      "b67628bec6a481d8ead0cac5c3f5a4c840ca21e97d039b8caf4c199ed24f2c99"
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

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
    (testpath/"sample.dot").write <<~DOT
      digraph G {
        a -> b
      }
    DOT

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end