class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/13.1.1/graphviz-13.1.1.tar.xz"
  sha256 "6c49d7dda4329f5a35ce70035d1ec6602dadae7a7077cd7efe43cb57f4bc8f22"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1e778cc5e72be4b15f3c1fcb32e76b6aed81eb88c6c3091d68cfb4c9f0be73f5"
    sha256 arm64_sonoma:  "93702aaadbb54e422af2a73d1302ca29fc9b7b74283d0c6b6d5a2ccf4e20a5a5"
    sha256 arm64_ventura: "029e8cfc5f1193b06d9417176b1593df189f0cf27fe76c6fb156e8df2fea0106"
    sha256 sonoma:        "0230c51a8e447986acb19443024b4f5b76cac4425e61df2bfae8f1a6f5ba9a95"
    sha256 ventura:       "117f236c2b697f9a91c4b1de1a95bc63e922ec8a372cedd1e1cd01a6d1b110e2"
    sha256 arm64_linux:   "437db8208d3a2358d3e96f5f7a80694794f7f57ab433e18a8181cd7a06c8d752"
    sha256 x86_64_linux:  "5f29ec2a26af0e984a4ad97d31d14167e362aab68e6fb3e07ae5d1c2f73c70f1"
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