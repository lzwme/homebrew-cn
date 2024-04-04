class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https:github.comhughsielibxmlb"
  url "https:github.comhughsielibxmlbreleasesdownload0.3.16libxmlb-0.3.16.tar.xz"
  sha256 "8007d39eefaa047d23e323523ae3c4da5fca77543b0fc4e188f7a3cd28872ff4"
  license "LGPL-2.1-or-later"
  head "https:github.comhughsielibxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c81b7bd8e6bde45efb8e5a1115c58c116229ada80e294282ee7d702967b25909"
    sha256 cellar: :any, arm64_ventura:  "8b4d8210f6ede89c63cc1d1487a694b147cfe7d9209684fc0d8e009cc0d5cf83"
    sha256 cellar: :any, arm64_monterey: "6b1e967c7e10f5e64dad0052873529b5d0c041541462fbde67b1c2ec75759c3e"
    sha256 cellar: :any, sonoma:         "06a8b65c7b19e56c44a5a734a08b1de506a819ff5487c3192db4258d9e6e014b"
    sha256 cellar: :any, ventura:        "cd1e2cc4d74f3729f334565c74736b34bfcfe2882ef657ed2d0e80d5d9644d13"
    sha256 cellar: :any, monterey:       "65b1ab244b4b3d2e58641910acf00f506e155d6dc708746cecc17b3cc86d57c1"
    sha256               x86_64_linux:   "c856e9e833e05f0d10b8c52d0dc8b0976c74362dac451bdc5650139a9a1124c6"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang, "srcgenerate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}xb-tool", "-h"
    (testpath"test.c").write <<~EOS
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    xz = Formula["xz"]
    flags = %W[
      -I#{glib.opt_include}glib-2.0
      -I#{glib.opt_lib}glib-2.0include
      -I#{include}libxmlb-2
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{xz.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lxmlb
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end