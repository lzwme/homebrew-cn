class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.56/at-spi2-core-2.56.0.tar.xz"
  sha256 "80d7e8ea0be924e045525367f909d6668dfdd3e87cd40792c6cfd08e6b58e95c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "7d5bc05a3e69c24d7725e15ec0b0c301ac0402c8ce696ebedaee9670f1b5266b"
    sha256 arm64_sonoma:  "02f6bf955df6fe1a970e557d3c791510b685581b280c8f29aa29e03508a93978"
    sha256 arm64_ventura: "0ab3fda7658c635cef173d6f57cda5bac6954c9c19de4b50f61f98501d11d17c"
    sha256 sonoma:        "8983df3d1e123b6b8bda47fca68fc8fb92465bb16cfc52201ae8a11c4849b984"
    sha256 ventura:       "ab8485e2944599f408731c4b818bf4a5e12c18a407cbb4a4d9ca8bac5075fdf6"
    sha256 arm64_linux:   "53aff781336b769c79b115ddd95a15d9c9ff67d8a5b668eea864881b0de42ce5"
    sha256 x86_64_linux:  "0054d8838fddd4ea562187c3ea27956829310a3d27205539ddfe2adaed604439"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "dbus"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxtst"
  depends_on "xorgproto"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs atspi-2").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-lgobject-2.0", "-o", "test"
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", 133)
  end
end