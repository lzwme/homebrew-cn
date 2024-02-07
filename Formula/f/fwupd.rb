class Fwupd < Formula
  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload1.9.12fwupd-1.9.12.tar.xz"
  sha256 "d2596ca8ff2320ca76e69d4617b72cf322f654979270553e4f0267ae2ccec839"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "284948e0d7ddd4f81295c47a7ba68230bbbe465bac5b33b6a69867454ab1e946"
    sha256 arm64_ventura:  "dff6903b76883780deb7c9f91d04c934cb10e0fa79816892aee0768f72d83cdd"
    sha256 arm64_monterey: "18821581720d4e189e2ee9a62f38881dba133e92bde77e87fdfd0fd76791661b"
    sha256 sonoma:         "75a4d781a8ab072d86de8b57f820ec9b12198ad7033a3365a6ab9f6efbd786ac"
    sha256 ventura:        "3e2b7b141511a3f49a4566aa00dd496c8d665c3dbb3c6deecadab22be58ccfc6"
    sha256 monterey:       "20962808a58f10097576696f2de677970a50ed5fdf1efec5ac55623f2b857d2e"
    sha256 x86_64_linux:   "ee2ba68c317085fd51cbe9460658623525bb29fa7667336ea93128f507c771f2"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-jinja" => :build
  depends_on "python-markupsafe" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libgusb"
  depends_on "libjcat"
  depends_on "libxmlb"
  depends_on "protobuf-c"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def python3
    "python3.12"
  end

  def install
    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
                    "-Dpython=#{which(python3)}",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_gpio=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_msr=disabled",
                    "-Dplugin_tpm=disabled",
                    "-Dplugin_uefi_capsule=disabled",
                    "-Dplugin_uefi_pk=disabled",
                    # these two are needed for https:github.comfwupdfwupdpull6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath"test.c").write <<~EOS
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{glib.opt_include}glib-2.0
      -I#{glib.opt_lib}glib-2.0include
      -I#{include}fwupd-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lfwupd
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system "#{bin}fwupdtool", "-h"
  end
end