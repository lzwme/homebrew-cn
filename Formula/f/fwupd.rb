class Fwupd < Formula
  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://ghproxy.com/https://github.com/fwupd/fwupd/releases/download/1.9.9/fwupd-1.9.9.tar.xz"
  sha256 "dd31c25b916005376be7ba31aa8e8d8f14eb2acabc24482412aaa2c88b7796e6"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "791e4de4f8adce81402c6c520ceece1e858def664799696e300b6fa86e072812"
    sha256 arm64_ventura:  "32233825ba647ffd61d7c20927b681932422f51f83ae3af51ad27dc102bdcb2b"
    sha256 arm64_monterey: "2c33ebd6359c7d419349fe77b64dc45fc6fa898850df71c139f6d5dac1a1ebec"
    sha256 sonoma:         "b7541379338fe891e659c798a815c6a7605c7a5270007363b66643093403644e"
    sha256 ventura:        "b1af103ed95436738636c6558a239a484d8e0c45d2c32cf4007b3d739ac26c84"
    sha256 monterey:       "e4f4bea3b21e6bdd43387b75dc59b4248144c4dc37b346649577a410667e3a30"
    sha256 x86_64_linux:   "6717a177fc250a2095767eb3431e75628cf77cae566af17b6b511bd6ff40d529"
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

  # Fix meson build issue
  # upstream PR ref, https://github.com/fwupd/fwupd/pull/6433
  patch do
    url "https://github.com/fwupd/fwupd/commit/8621c3039a10792ee4dfb7c461bb5e9dcffef4d5.patch?full_index=1"
    sha256 "83f7c244e41dfeec290ab52740df0b83979f3ef36c2d361f7dd077e30c237c7d"
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
                    # these two are needed for https://github.com/fwupd/fwupd/pull/6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~EOS
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
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/fwupd-1
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
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system "#{bin}/fwupdtool", "-h"
  end
end