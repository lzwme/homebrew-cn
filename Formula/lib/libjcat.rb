class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https:github.comhughsielibjcat"
  url "https:github.comhughsielibjcatreleasesdownload0.2.0libjcat-0.2.0.tar.xz"
  sha256 "14dcfa678fe9fe7561ab8b795999dde2c02eb57d4bcc7da3153e1ea1a569a9ad"
  license "LGPL-2.1-or-later"
  head "https:github.comhughsielibjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "cd0ed9eed1fc1aa75a296e3638cc5e59bee98777cad1309d4297a5773c3c7598"
    sha256 cellar: :any, arm64_ventura:  "10bd003b763c2e743de8803f17b9b99466ca5a5eb8cb9718684ce45349f9d617"
    sha256 cellar: :any, arm64_monterey: "e5a595a947cefae1a57ca2e0ba4d2ae8673463969065e3ee71e988064502dba9"
    sha256 cellar: :any, sonoma:         "2d2b2fa88a30160b1a0b108d350f0adcdbfcc54f483115e94f5c0d2895e1661d"
    sha256 cellar: :any, ventura:        "d7bd17ba192f7d09be204251538987c386edeab0a6964c7d0fce441e1e2c6667"
    sha256 cellar: :any, monterey:       "a45d509a62cc478cd4702fa61039bbfd2e1d3b07feb28b49fe5a5d9709acbb46"
    sha256               x86_64_linux:   "da3ef9fdd19104673fdf7c66da8968c6f924ee9c4facd2719ad528f004cfb07f"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"

  def install
    rewrite_shebang detected_python_shebang, "contribgenerate-version-script.py"
    rewrite_shebang detected_python_shebang, "contribbuild-certs.py"

    system "meson", "setup", "build",
                    "-Dgpg=false",
                    "-Dman=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}jcat-tool", "-h"
    (testpath"test.c").write <<~EOS
      #include <jcat.h>
      int main(int argc, char *argv[]) {
        JcatContext *ctx = jcat_context_new();
        g_assert_nonnull(ctx);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gnutls = Formula["gnutls"]
    flags = %W[
      -I#{glib.opt_include}glib-2.0
      -I#{glib.opt_lib}glib-2.0include
      -I#{include}libjcat-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gnutls.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ljcat
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end