class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload2.0.7fwupd-2.0.7.tar.xz"
  sha256 "50cb8a5c1e66de941bb2be72d2a689cad992b86394e4e42dda58c81ddb847235"
  license "LGPL-2.1-or-later"
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "0f3549da428408ed545affa58e7c03c32773e532710b77905e81fd28be20de00"
    sha256 arm64_sonoma:  "1618d80aa915ce5d89678a6acb56a4cbcfd1d2fa470b66805ba1c4c6d09711c4"
    sha256 arm64_ventura: "64d5f419833af0c66de308e3f28b19d807f88f7572f8cfbdd05964ea2b1ee864"
    sha256 sonoma:        "87486b5e46cb1b0079a4d7ca6737c4382b03f892f3735d31122f025a48cef08c"
    sha256 ventura:       "09fca530d32606ec7678493e0628936e16832961007d5cebc6d505136aa7d4c1"
    sha256 arm64_linux:   "553a7ff20f38d8cc7d1439cd3b1a42b02a828325c27816b88bed11437c0dc9a6"
    sha256 x86_64_linux:  "134eebc2c3ac5f8df010a0749eab2db98512b8ed5598ca3f31a8a07d45c5913f"
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
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath"venv"Language::Python.site_packages(python3)

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
                    "-Dpython=#{which(python3)}",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_uefi_capsule_splash=false",
                    "-Dtests=false",
                    "-Dvendor_ids_dir=#{Formula["usb.ids"].opt_share}miscusb.ids",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath"test.c").write <<~C
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs fwupd").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system ".test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system bin"fwupdtool", "-h"
  end
end