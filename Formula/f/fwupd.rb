class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload2.0.9fwupd-2.0.9.tar.xz"
  sha256 "091947258ffe7d7d0724864afdc79fcc3c64a42303622b1577a829e7d8ebc2c9"
  license "LGPL-2.1-or-later"
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "a851b08724e82513c7fd9ae3332d9ace21b1bd1012dc8730ab0b12bc4584fd26"
    sha256 arm64_sonoma:  "c8ea6d0e368ac08535802ad195fd1a52445ca7d0e62c8cc991a73e06ddb0fcf5"
    sha256 arm64_ventura: "e1d6cd82871dee54d600a3afd1816fea623778774f8080aa5296e287d6c17f5c"
    sha256 sonoma:        "fbcc943c9c91fe26948521a6d7e20e3ee56ca3aec7201b1b13be4469f57f7534"
    sha256 ventura:       "da7d409f4633c13ac3198805a170e96513fcbd2a89e7b74a0cd49517de99efba"
    sha256 arm64_linux:   "a2f7ce99b63d187a9080b9ae599debe2a24e3161b8a04df20887b1818cf03f75"
    sha256 x86_64_linux:  "6c2b83904e3c74fe5db555e4b46eb1ce288965d83d6b6b58495209cb049a0759"
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