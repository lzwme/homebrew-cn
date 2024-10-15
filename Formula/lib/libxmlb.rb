class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https:github.comhughsielibxmlb"
  url "https:github.comhughsielibxmlbreleasesdownload0.3.20libxmlb-0.3.20.tar.xz"
  sha256 "4c5b534d645f7328643d6a0d3040ffb9832e13e3530025af55086a06e3c018ed"
  license "LGPL-2.1-or-later"
  head "https:github.comhughsielibxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fbf35efd216293fa3f6a18300363536bfc90c090c36d253fbda655d3e67e3283"
    sha256 cellar: :any, arm64_sonoma:  "f854d2b34984e355f5ca753431eeb2e82d00e3f61682200245a4549f91c5cc59"
    sha256 cellar: :any, arm64_ventura: "a4b8f88f96ecae0d9de735c370855fc9382b47081a382ba51e0f267cf76cac16"
    sha256 cellar: :any, sonoma:        "59bcf0690669aa3728876cbf4c62a9eb028666ff5e94eb904cf8af254980c04e"
    sha256 cellar: :any, ventura:       "90a345693ab0ffd1156f180670fa769be3c045ec1e01199ad02b0f34cdcd42bd"
    sha256               x86_64_linux:  "340d33e020623263b77443c65a4e878829fb30522b9388a129ca334007aef244"
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
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "srcgenerate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin"xb-tool", "-h"

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