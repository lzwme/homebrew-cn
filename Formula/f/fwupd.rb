class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https:github.comfwupdfwupd"
  url "https:github.comfwupdfwupdreleasesdownload1.9.24fwupd-1.9.24.tar.xz"
  sha256 "12f560b35dbed981fde8cf774c6d1f2e658a157d3a63d6c439bf418dbcc44b4c"
  license "LGPL-2.1-or-later"
  head "https:github.comfwupdfwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "3098aa5f6ba05f9ac84c27fbdde0d829af379fb8f2ba1b05bc69a2786c9f58ef"
    sha256 arm64_ventura:  "c75324e3034e466d04900c38fead2eb9f18567f93b3cb6b2d67c29c0c5b54dc4"
    sha256 arm64_monterey: "efc0c6f7f49432e87b2a907b81681c3d299789c4509b814ac21031eb70b17b95"
    sha256 sonoma:         "a105fd3b81aebf55e0a80cb810d2560c274fb0d7c052f4e485517c4dff387b2c"
    sha256 ventura:        "b0fdce27ba07974bc08402260f381bf9796ea9ecf2f584f8dd92dc4538e4521f"
    sha256 monterey:       "bd5fdcf2e6dfa058306f59ed52d7f78d686a947dfd1265b3bea66d7d076eefc9"
    sha256 x86_64_linux:   "ce89989817d8a5004134e11ecf44ce75fa74e266a0191224fca27fedc930d4ff"
  end

  depends_on "gettext" => :build
  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build

  depends_on "gcab"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libgusb"
  depends_on "libjcat"
  depends_on "libxmlb"
  depends_on "protobuf-c"
  depends_on "sqlite"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def python3
    "python3.12"
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
    system bin"fwupdtool", "-h"
  end
end