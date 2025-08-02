class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.6.0.tar.xz"
  sha256 "cc0e8c226559b479833c8bc9c77a8ec301482ab0305fcd98d27f11cc6877fd23"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4f68053299a1691eabe1897fc8c12ef13b449a0e2230c4dbdd74ad19dc619c1d"
    sha256 arm64_sonoma:  "294a492b762dbf960397690586cbe7ca998e55a66709dc0256c1453f85f477dd"
    sha256 arm64_ventura: "9f2d8b4768b43ae75d122d9c721165ade3cb1816845a5d6a39a7e8289fb20709"
    sha256 sonoma:        "1402be4d40abd5183dbf28fe4a8d22e97e223d981fb97043b3731bd6c975ed7c"
    sha256 ventura:       "76dc54fc815ffc1b2f14322863aa1ecbed99efc460f161049a84883dbe612234"
    sha256 arm64_linux:   "26a4fb99574367f401c47e073a2c7f382605caf7fb03cb59797ebe212a5bf066"
    sha256 x86_64_linux:  "68968a9eee8f6633e48649ad20a401bc05ac33853892a849b2eefd31f394ff53"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-c"
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
    depends_on "libnl"
    depends_on "libtirpc"
    depends_on "util-linux"
  end

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
      -Drunstatedir=#{var}/run
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