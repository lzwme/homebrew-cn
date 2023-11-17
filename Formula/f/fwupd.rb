class Fwupd < Formula
  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://ghproxy.com/https://github.com/fwupd/fwupd/releases/download/1.9.8/fwupd-1.9.8.tar.xz"
  sha256 "6060075ce02ab11c66c96d6ca689c75f3abc909730c7279c5edd8cf5bfaed46a"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "1e049ad4cf51a9113a159e7cf248446300420acf210ba8728b2c88cc4369b3cd"
    sha256 arm64_ventura:  "740333b1d8dc19652c3d52289181f76a2b8c4307a81aae37318cd4172dd94f6d"
    sha256 arm64_monterey: "d73512dc2de94b8237861dee26146d41fb0c79a5cfc66648d176455cb19c9887"
    sha256 sonoma:         "9857d0f1d567dc8893311eaf126c0708d5cf6e9786a8cef935cdecd0c2677d44"
    sha256 ventura:        "6a2f191eb1eaaab288cd298fe2933e917ca72f0e68f8e9e16080406bde95f3a1"
    sha256 monterey:       "56b8c797f7d274c7749d175509f42a5f8d1b5336fc250bc4dc851663ec1b06ef"
    sha256 x86_64_linux:   "0b0cfddea45cf216436d3e2f17745d4da693eaba1b33d0d1a39e195f2a920d87"
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