class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https:github.comhughsielibxmlb"
  url "https:github.comhughsielibxmlbreleasesdownload0.3.17libxmlb-0.3.17.tar.xz"
  sha256 "bdaf38779646e436cba73caf2bdc1ea07226e6ce418a01800595cd4702cc3caa"
  license "LGPL-2.1-or-later"
  head "https:github.comhughsielibxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f2a6fb1acdb32991d8da49df859ddf0f71f8436910c8d553a7ea1007d9015f4e"
    sha256 cellar: :any, arm64_ventura:  "c79b03ac4b4fee6b18469d37ee9122c63b3bc09aafb25ad9e83da8912defd989"
    sha256 cellar: :any, arm64_monterey: "1e1a2f59343952ce5a11e843413f0bae53e31f0f27856b102b2fc98cb382ce51"
    sha256 cellar: :any, sonoma:         "c1498faf586ae6cb64b8f86dc540d75b991b033aafecb158f60b892fa8822cb1"
    sha256 cellar: :any, ventura:        "ed04cc0c723cfce977d03882153971e3f1a8b432d8960e43a8013bee75df9c4c"
    sha256 cellar: :any, monterey:       "04e84745e17ac99fd91cb3b82149330c2b73650319e2aaf03c82530dacc1a455"
    sha256               x86_64_linux:   "10e3d2a7432d329e5bdcb87b863b37e26180f9a77200ff0db454bd629779f46d"
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