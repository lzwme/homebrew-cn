class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.50/at-spi2-core-2.50.0.tar.xz"
  sha256 "e9f5a8c8235c9dd963b2171de9120301129c677dde933955e1df618b949c4adc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "c2a3ae2db2f7c4c9a51ff267a637099e9a2b374236a161b64250cc27abb878f3"
    sha256 arm64_ventura:  "3b5eee43419542ae28c18fa30f3a129443a0af25ae7bdd568551a14666b4f1b8"
    sha256 arm64_monterey: "1e2f0b026b13f9ecc88d85ea7855979c075a0e81bac42fd1fb03f73f2c231552"
    sha256 sonoma:         "3b4398b7dc33d621b1e80f66eb29cfe671e5593decb734e4b1abe8972645034e"
    sha256 ventura:        "d71d12231a51bff89eebb65f146ffa81e41a0445558423c9190e5d991092ee81"
    sha256 monterey:       "b6b667cbb203fe6b4582ab9469f8217eb266d7098d10f8a85ba41e0f616993d6"
    sha256 x86_64_linux:   "639419ad4ec369801ebf8d0064f62573c8ddfd0bb70bf393942e5815f3d544b9"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "dbus"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxtst"
  depends_on "xorgproto"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      /*
       * List the applications registered on at-spi.
       */

      #include <atspi/atspi.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <string.h>


      int main(int argc, gchar **argv)
      {
        gint i;
        AtspiAccessible *desktop = NULL;
        AtspiAccessible *app = NULL;

        atspi_init ();

        desktop = atspi_get_desktop (0);
        for (i = 0; i < atspi_accessible_get_child_count (desktop, NULL); i++) {
          app = atspi_accessible_get_child_at_index (desktop, i, NULL);

          g_print ("(Index, application, application_child_count)=(%d,%s,%d)\\n",
                   i, atspi_accessible_get_name (app, NULL), atspi_accessible_get_child_count (app, NULL));
          g_object_unref (app);
        }

        return 1;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs atspi-2").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-lgobject-2.0", "-o", "test"
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", 133)
  end
end