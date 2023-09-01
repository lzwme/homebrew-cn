class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://ghproxy.com/https://github.com/hughsie/libxmlb/releases/download/0.3.13/libxmlb-0.3.13.tar.xz"
  sha256 "ae45ae4c0606f94d98fea16b7097b3470e48c2f277954ae9bc4d9d029ed72496"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9254cc28ae1f707d85af4da33112ec899d9ea423e30f01d11351215046477caa"
    sha256 cellar: :any, arm64_monterey: "2b41e04835d1b221e92c2457101e82c985cf79ffedd71292600af576263ab3e9"
    sha256 cellar: :any, arm64_big_sur:  "83d06ead9fd0f40f8633aeaf94768cdf22a4ae28c947a2523d93cb38511d0047"
    sha256 cellar: :any, ventura:        "5fb074755b8635f7ca54797438facf12276867b181e534e667f6ccae8867d39a"
    sha256 cellar: :any, monterey:       "8a7c22844f0e5fe14da453f61fbf56cdfbcac8b6f59a4e84759a57445d9bf95d"
    sha256 cellar: :any, big_sur:        "3326934369e5785e07d058f84e6722c958db07d7edb23b0b613d1a571f783879"
    sha256               x86_64_linux:   "0cfb3670114944252092f1ae43bad42947924562771529242b4472751fbb7af5"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang, "src/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/xb-tool", "-h"
    (testpath/"test.c").write <<~EOS
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
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libxmlb-2
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
    system "./test"
  end
end