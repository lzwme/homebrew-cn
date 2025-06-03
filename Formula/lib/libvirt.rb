class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.4.0.tar.xz"
  sha256 "e10059efc655532b0cfe44d961c87c5a56e45393cc7bd343bd3348b40d73b267"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d6743cf0a6801d98480a7a1c7d5e5595ba1c982edc9345006f639905742df835"
    sha256 arm64_sonoma:  "fd39bf21bccfe4407c0bf23a0d8d7fa0b8efecae3405ef369ccf4fc694b975f9"
    sha256 arm64_ventura: "88036ef76b99fc34fa2a5a2ae83f3053b242c1c7dc5a646b931f142fab09f3d0"
    sha256 sonoma:        "aa7ae12a3ea0c2b80960d3fc719c64ca61e32868cf05aacf82a79db52a680aff"
    sha256 ventura:       "820150f9bddaebcfce0eca9b064861ecf58a2015e52c401b669ae50dc207556c"
    sha256 arm64_linux:   "b79095c964043152d214e6082e09c44dbd83be0f4c97cff912caadceffc13db9"
    sha256 x86_64_linux:  "0f16c73a5a704d9138130b5759c55b670be2d21ad6c0465cc8a14832cb1dace9"
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