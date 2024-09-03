class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.7.0.tar.xz"
  sha256 "ca757322eed998013b21f474c6c0c15dc08320ba6c8bae54aa16a93a1c3b7054"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "41e99d6ffe8c13d58270e6b325dd824eae6b68c22b790bdb8221484fbed2c27b"
    sha256 arm64_ventura:  "2b015649eb888517520df400de58bac7127bc24ef7af71f63e9720073970dc31"
    sha256 arm64_monterey: "f3d85a99580795f635ffe65cfd2d67eda64e0fc2ec2a2928022ac1e5373239f0"
    sha256 sonoma:         "bd0f85a285e0fe8ab45ed4eb82901e26d3999229fb59aa88d6d890871fc0cfbf"
    sha256 ventura:        "80218b79121cb518e0e4a1ed1439826660e7a782ae371c62a2e9b6ffb48a85b3"
    sha256 monterey:       "d58f916f7b04f599d128dfe4e4d5a26bab7433a66000dd2af70088f937dad70f"
    sha256 x86_64_linux:   "5f2dbd9aef8e194299fb4a7023dbe0b81c2b07f9bfbabe9df80a7d40e015a534"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "yajl"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "libtirpc"
    depends_on "util-linux"
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
    assert_match version.to_s, shell_output("#{bin}/virsh -v")
  end
end