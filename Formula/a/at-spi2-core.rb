class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.62/at-spi2-core-2.62.0.tar.xz"
  sha256 "03a94f7bf35f300daf2843a37cdf36479a91bc53f59a8ea437c79e25d95d1de3"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "8130a3939d3d7ad67814d890d88868437dfef40509778d228c3d87befdbfcae4"
    sha256 arm64_tahoe:       "a684f41c458472642e7bd539f25e8605e768029351b3569199fcc7d639d64e29"
    sha256 arm64_sequoia:     "09e3f59bffc7c7d2e16b98ebacabd3f565391fe2bd8cfef6e193991889ea6785"
    sha256 arm64_linux:       "694b2e80232b00327b826cf9aa74814f6d567254a26c1db69c18c3638ab5ebe1"
    sha256 x86_64_linux:      "da06be8b3321ef6ee737b24ece51a44ea922cc5894de4bf5d6aa95583f37280b"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "xorgproto" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxtst"

  uses_from_macos "libxml2" => :build

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
    expected_exit_status = OS.linux? ? 134 : 133
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", expected_exit_status)
  end
end