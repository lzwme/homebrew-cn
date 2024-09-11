class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https:graphviz.org"
  license "EPL-1.0"
  version_scheme 1

  stable do
    url "https:gitlab.comapiv4projects4207231packagesgenericgraphviz-releases12.1.1graphviz-12.1.1.tar.xz"
    sha256 "8dd4fa2a30a80e9ee4a11ad4f43f4a900d683684e824681b084a1dc86777a2a3"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "dd45b9ea58f4baa6813c807ea0416f302faa5e1069f8a8143044d5bd89a3aa83"
    sha256 arm64_ventura:  "94de859a11b2f236133b2f541c00a6bed2a730c81a4bc6d729930480009881a9"
    sha256 arm64_monterey: "5557ee94735171a98bb962f0f0a2026eab01f770a05572cdd7a0d75bb68e6c86"
    sha256 sonoma:         "32045b867d4fba1e3fbfb64cf9b5f001aa5014e0987d7a9a9b0d4a589d4b6e7f"
    sha256 ventura:        "11d1e6b2726cf8283a30abdcb5540c5d08709d6b8dfed8ba61d7584b3373a41d"
    sha256 monterey:       "c32bfeb0330478975e6507829b92ea13adba64e644681451d3d8b7556c7adbf0"
    sha256 x86_64_linux:   "52d08a6c684768e83853e1210eef6b7404cc42487eae026146a9b00342505cec"
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