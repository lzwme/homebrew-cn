class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.5.0.tar.xz"
  sha256 "8e853a9c91c9029b9019cf5fdf2b5fea36d501d563e43254efc20e12c00557e8"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "488327e99fde383626ab960ee32a9fa7616eb16395e89596f4a8258adb6abc1a"
    sha256 arm64_ventura:  "a80e4ffe76f00d027b7ff8fbdca4989ff20323a802579a272f7ca6fed6437b75"
    sha256 arm64_monterey: "c4db7fa7a92caf0b43a50be92b70c4d64a18df87b7e0b5b5fa7244dadf862093"
    sha256 sonoma:         "6e5db5d134db8c1ae58368dc154af0d87fdd9915aeaa06696368652f2651b621"
    sha256 ventura:        "6fea0722ec7498cce38a49d0c52d9fec57085df224d83e8d1c4363af18c33d15"
    sha256 monterey:       "d2280d67693299eb514d6e5aa5e2c39bd619ba0f99984c8d7830d8fe3b7977a9"
    sha256 x86_64_linux:   "13786db0c6f320422e2555c8ae3dee4eae20f273eaa032b1af2918b196496857"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
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
    depends_on "acl"
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