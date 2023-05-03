class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.3.0.tar.xz"
  sha256 "751179b08e5a73b6cfd93200d110df199eaa3973f3554ba2ebcbd71e272bebe1"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7b1b9039529dd54dec14cead702f333b1a35a41f7060a7dca60b8d32108d09e9"
    sha256 arm64_monterey: "bfceb9ea6aad02b655d628a727d4f6a8f181b0710b8a9d78f1780b421b45f5e6"
    sha256 arm64_big_sur:  "8619fb5aba79ac4914979188828d82c195e658d80ac44f11d8523bc7c3a7164c"
    sha256 ventura:        "658c4805d58382b02b4d7a56cd34d7105eab1589cc0f3c29918243147a627429"
    sha256 monterey:       "42a337ca3eccc6484943177baf09e80bdf7a1773925245a42cb2cd0d1a20d39e"
    sha256 big_sur:        "8007e9b5ad7af9ce00c9a81eb986a708575bbdc21bb18509cf6fac535e967065"
    sha256 x86_64_linux:   "5d94bab6e111b9cdce66f5c1063b75cce78341b211055d1561c080698e1f9d61"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "libtirpc"
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      -Ddriver_esx=enabled
      -Ddriver_qemu=enabled
      -Ddriver_network=enabled
      -Dinit_script=none
      -Dqemu_datadir=#{Formula["qemu"].opt_pkgshare}
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    run [opt_sbin/"libvirtd", "-f", etc/"libvirt/libvirtd.conf"]
    keep_alive true
    environment_variables PATH: HOMEBREW_PREFIX/"bin"
  end

  test do
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end