class Fwupd < Formula
  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload1.9.11fwupd-1.9.11.tar.xz"
  sha256 "4c9598dc6ed1eb2adf4f728925703b9d720f5db30112095a06b5c35e38d3bb50"
  license "LGPL-2.1-or-later"
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "d6ce031aa8a03863b9dbdc3ea0ff37bde7c788cf3634f6cd1201106a71633a50"
    sha256 arm64_ventura:  "cd4f32850a3e648445ac021bfe7697becebe345ceb688c14c2c481a7f4c5c931"
    sha256 arm64_monterey: "d7c2d49864a2377ba99ac30a774a982bacfd68d34ea983a559e3c691244c810d"
    sha256 sonoma:         "fa46ec937379c90ee1ed240b8cf0a039421c212729822b9a17d96eef8167cb25"
    sha256 ventura:        "a647c2edd8bf2b8b871a66c5cfa8de6c197baa560595d3c4264cd4ae7121991b"
    sha256 monterey:       "0cabfed1420bc79f618c0af88cf83d742f1ba450ef5f45273a13ab8e905eeaf2"
    sha256 x86_64_linux:   "0a8af66e91154e8efe0cd284a1ca47fb809d1fd34e548971d14f18e0c39d7233"
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