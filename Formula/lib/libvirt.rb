class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.10.0.tar.xz"
  sha256 "1060afc0e85a84c579bcdc91cfaf6d471918f97a780f04c5260a034ff7db7519"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "efa80cb8cf32cb6391e62506f289da951ef6f383693dc3c0208cf6167fb4c3f5"
    sha256 arm64_ventura:  "168710d977d5c067a0a6de7c1d8a2744916f297e8d7a62edd384a7d09b434703"
    sha256 arm64_monterey: "cb4e016636418b3f3d5a762d9584cb0e0567f4078e1c1bb7271eb099586fc40b"
    sha256 sonoma:         "2887ff473639a51c043dc2cb4ac2eac26064c1f15a10bca79f350a9da90768ad"
    sha256 ventura:        "d53894e530637c8f150c0f52b3f4d1832910db0a889dda218148f2096aa8eb7b"
    sha256 monterey:       "373761b4094c7540eb4d52585ffe13e99a271f012a33ab8b8b638364da9cf307"
    sha256 x86_64_linux:   "094d626d7881aeeaa0f9fda0cadf3a29528cb6311c98ddeef90b085e74abd28f"
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