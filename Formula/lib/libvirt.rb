class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.3.0.tar.xz"
  sha256 "6bcb0c42c4580436fea262ced56f68a6afe20f7390b1bea2116718cc034a0283"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "9e191cd68b06bde9cdf861afac997d13ed0f7cf1cfae26eeefe8c416ac4fb98a"
    sha256 arm64_sonoma:  "d2562c47fbd6813ab281245002297f151b2034f79e51625d9c2fbd66a34f6fbd"
    sha256 arm64_ventura: "238c6a29cc492ca2f1f956fd7e09ebe9931f7d520f2f9f428ffd15faf05926a6"
    sha256 sonoma:        "db653c3adb0040dbd5d2a87fee03e766fef21a34c9ac652b360e6bd178d73c13"
    sha256 ventura:       "2a5fbba33bcd05319e0d7fbec4c7ed7bbdff5367d2d96339b6d5ae9d765542ec"
    sha256 arm64_linux:   "7a7540da5bfe0ccb74c26d7ed964313c86d425565be77e6b03e9074d8638b97f"
    sha256 x86_64_linux:  "f5af84225d93f7481f76abb99d929aafbe3eae8bb0e0e9996c658aa63d9961c8"
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