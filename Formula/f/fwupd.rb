class Fwupd < Formula
  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload1.9.10fwupd-1.9.10.tar.xz"
  sha256 "9b3834852393343ae4cd04b4750d0f8cf6b094fcebe5efecdae9ecd5f47ba81b"
  license "LGPL-2.1-or-later"
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "2d5940352dab26daf0f3b810ed73119defc744a7d94aa67aa7565a65db143fde"
    sha256 arm64_ventura:  "ce95d828df1760a0ba0c7f243a0e3170a780c93b575cbb6feed47194a5dcf7fd"
    sha256 arm64_monterey: "8f1bebecbba6752a4627b59d18b91f470266febb14f314e3359b4b56d955c81d"
    sha256 sonoma:         "e0119beb998c075a2bd24e32c1eeebfb8511bf0c8a5e617b26447843ab4c8775"
    sha256 ventura:        "8ad758ae0a0810c4124f0b90fcf2e305a7c6dff9244d5395ab2c6a1393ad05c8"
    sha256 monterey:       "606556f5d5b27db916b834a7b751f4a7ac8ec0193556975e25c8e88d5017a43a"
    sha256 x86_64_linux:   "60051e682d8d32131b35c5d52d1a7bfcbe550d15e718da878345d35c897114a7"
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