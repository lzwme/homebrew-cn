class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.0.tar.xz"
  sha256 "64ea1d8e9edc1c25b45a920e80daf67559d1866ffcd7f8432fecfea6d0fe8897"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "a3d28d4743f36aa5324d601af39343d2cb0b927576f46de016bd52c1f1cf13fb"
    sha256 arm64_sonoma:  "9d7ab375e21486d33fa616e911aeec66dc72d8b733b93de1adc4d4c6ed7e4dcb"
    sha256 arm64_ventura: "8d73c7df6f06a5cb9a0d0ef7b95477fbb4748219a5ba1de3ea6e14293588efa8"
    sha256 sonoma:        "4ca7d04804be23a0d127de01fc012b20f16e4e77a3e1e89b304af4a4994a8674"
    sha256 ventura:       "1a49dc867546d57425ff125735d0a00a271d5573ce6da77895a0e37c7a13aeb7"
    sha256 x86_64_linux:  "24c3f7f7b162851fcbde7198b4d15d95dc399bc55d3b7463e61a0e3249c9bfce"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dtests=false
      -Dinstall_tests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end