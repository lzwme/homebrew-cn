class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.2.0.tar.xz"
  sha256 "215772bc5dc4a672e67ffa9de3774f05ed4b7ed282dbe296ec5c9fec01dd7ae3"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c27dc30b20c655268a8bedb2d609c50fcd3c23135348dd10c20adb4fed574614"
    sha256 arm64_ventura:  "bf0a7392eab9f25ff4b5ea93c9d5a6aeea275a9f4231e5e1875d0c35fbb79f70"
    sha256 arm64_monterey: "f568f1711aa0046b2ef5e6cc571b6582036e9bcc5bcaff682aa99f8058b604a0"
    sha256 sonoma:         "872a3230743fe23d6061cb7dce7804b7588c3225baf202ef9d50f47d20d5350f"
    sha256 ventura:        "a5f0880c59b029b48d40a40b8f03401babcd24ef78f8c46eaedadd82e29b1cdd"
    sha256 monterey:       "1fb5dd40c5acb81bad7ced0fb38671b530532dc506153ad8cd14c30ad0f0b2a8"
    sha256 x86_64_linux:   "16930b0d4364a713341d864bd41dc8ea6553b2ba3ebf43bc8bdc0094d17fb25c"
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