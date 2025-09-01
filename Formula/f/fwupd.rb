class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://ghfast.top/https://github.com/fwupd/fwupd/releases/download/2.0.14/fwupd-2.0.14.tar.xz"
  sha256 "3dc0bdc3b23aa7b56c3b4057e323a30db30f38b51c76b93948b1a4b5b2c833f2"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "ae62fbde436ec8d0d97de886e30d3860fcaa9e53adc0586b86be4b6908829ce4"
    sha256 arm64_sonoma:  "9ae3aac1d0954b44726f715083a95e9c5040dedbf893f6900b13d65c8b7ad29e"
    sha256 arm64_ventura: "af440dbbd24e68d2a8de19ec2c259ba4438ffe937345f1c9fc49d61492fe6c24"
    sha256 sonoma:        "e9701acd38005d04a65baa695b6bbd6a0aec6d73a3ee72f47fe094eb44af7db1"
    sha256 ventura:       "d7b250339806bebda8b0c4a89718db38f73c81cd9404c18dfa8ef23c72098e04"
    sha256 arm64_linux:   "ba5ace54ff120a316ffb38d396ae0b6e33b2506c08439d60c7ded4c05ff3487d"
    sha256 x86_64_linux:  "a96c15a2dd958d0b5f2ad81597577c980d2d6e6b709eefb0505dc7c57a6add30"
  end

  depends_on "gettext" => :build
  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libjcat"
  depends_on "libusb"
  depends_on "libxmlb"
  depends_on "protobuf-c"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "usb.ids"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
                    "-Dpython=#{which(python3)}",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_uefi_capsule_splash=false",
                    "-Dtests=false",
                    "-Dvendor_ids_dir=#{Formula["usb.ids"].opt_share}/misc/usb.ids",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~C
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs fwupd").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system bin/"fwupdtool", "-h"
  end
end