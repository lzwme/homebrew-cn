class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.3.0.tar.xz"
  sha256 "6bcb0c42c4580436fea262ced56f68a6afe20f7390b1bea2116718cc034a0283"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c79b83d66eff22f9abb1653338625946eb5089b727eeadf3adf82a43086c2112"
    sha256 arm64_sonoma:  "f83faa1ac33c04cf1c8f86525ced9f15f3004f9a22f9a19f6ca8e4c55ad544ed"
    sha256 arm64_ventura: "cacb47f56ae0021ed9583cf11d74011f570f5a2d0665b47af99568f7a5a1b048"
    sha256 sonoma:        "e3cb758c2e1581628bbf13a96effdacdd2f36d6b3b1ee5ecdc189e11a8457607"
    sha256 ventura:       "73f3205d3e026487b28effa6aaa8399f7e1b2c1d945c13c2bb28c225631917b2"
    sha256 arm64_linux:   "842bc2a03670642bf236330554c298dfe3b666a4da990c425d667d43049f6bbf"
    sha256 x86_64_linux:  "d8f7a348501fa17435dedab4f764f3899eeb98a0723710496d82536db0a0daa9"
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