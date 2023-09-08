class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.2.tar.bz2"
  sha256 "3b173fda4c51bb07b5a51d8c599eedd7962a02056b410e3c9d9d69ed97be35b9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a6658f1bcb021848f0fb7f21c2e1b144edf6adfe2ee412dd4f7c1849579f3aff"
    sha256 arm64_monterey: "14df5c6ac5665eb5755e74e568e3b19988f89719272ea5eb1ff337cd148d8bf0"
    sha256 arm64_big_sur:  "a808012fbe120a53f13fbe4c7a60e9a2d7bb6b86b32d7a1b461c607681ef6696"
    sha256 ventura:        "1274e8cce28f2f96593cff57bfc3c34bc82c8eaec47be32f1a570b7932b8baeb"
    sha256 monterey:       "54b36fac85ce50fe8c4b12a052a8e1e505c130719a1dd7bb8379f511890922ad"
    sha256 big_sur:        "530b181365a4dbf206c3d4d4885df1cd7a52af55ed6ae4ee69366e961de411ca"
    sha256 x86_64_linux:   "7f37b17ae68d5693792938326b6a63532e3c3f3076cbaadc6cca50c4090a3f32"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end