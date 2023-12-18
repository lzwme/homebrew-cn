class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https:www.powerdns.com"
  url "https:downloads.powerdns.comreleasespdns-4.8.3.tar.bz2"
  sha256 "77b91199bdf71874334501c67e26469c2667a373d8423803fe657417295c77ba"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https:downloads.powerdns.comreleases"
    regex(href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "0bec6105e793a8d8d08cda1d8c02586527b3789d0fc639bfb4eec8a571c779d5"
    sha256 arm64_ventura:  "477ec905932dde8d6eeed8171bf02fd2e3b62d8c50cef2986b3188612f64af54"
    sha256 arm64_monterey: "47cf2ae650b319c14eb3dc0ecc147b2e28235d1b55e9708b02fd8ca8356e6afb"
    sha256 sonoma:         "bbf5deb73f6318175120901a0e9c01799ddee5adf99ceca950d65a140374bc7d"
    sha256 ventura:        "beb940aac07440ad0138a28a099a0f27d3ec2306699904b7b8be0bfcd5a464a3"
    sha256 monterey:       "e77769a854176ef353a7821027a8f27a83231337c5f34380f7e185a3f4bfef22"
    sha256 x86_64_linux:   "0b86c97f289efff9e9719d846bd0135edacf62fda9d57fae71c729f7e7688ace"
  end

  head do
    url "https:github.compowerdnspdns.git", branch: "master"

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
      --sysconfdir=#{etc}powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system ".bootstrap" if build.head?
    system ".configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end