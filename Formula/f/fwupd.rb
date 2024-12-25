class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload2.0.3fwupd-2.0.3.tar.xz"
  sha256 "73690175d0dd81849d729a0f247c69146ee9105c3c8c5d8428b64ad42d49b2f7"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "5930222336830529919343a33540a0f8e1603a2a5695ed5e4e322cdfff860351"
    sha256 arm64_sonoma:  "5d818cf44344991cd367b181d89608844e2354541402785f5ebe721d344549cc"
    sha256 arm64_ventura: "1af8b3db3328365386419652f1b6b312e2b7754225f64c301cec766fc0a346fc"
    sha256 sonoma:        "72e98bddb44ebc8841a411cc2f48b6346926306c5157dd9fadfb0624ee11823d"
    sha256 ventura:       "84321c057422c3b94134ec73ccbe5a31eb28efe6d5ab99e712ed0babac759672"
    sha256 x86_64_linux:  "2f6c424f24827871f9a2c21c3f7671608de0238002d2b8ee6e8812ea775be4cd"
  end

  depends_on "gettext" => :build
  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "vala" => :build

  depends_on "gcab"
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
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
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
                    "-Dplugin_gpio=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_msr=disabled",
                    "-Dplugin_tpm=disabled",
                    "-Dplugin_uefi_capsule=disabled",
                    "-Dplugin_uefi_pk=disabled",
                    # these two are needed for https:github.comfwupdfwupdpull6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
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