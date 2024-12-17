class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https:www.powerdns.com"
  url "https:downloads.powerdns.comreleasespdns-4.9.2.tar.bz2"
  sha256 "f570640427041f4c5c5470d16eff951a7038c353ddc461b2750290ce99b2e3c2"
  license "GPL-2.0-or-later"
  revision 1

  # The first-party download page (https:www.powerdns.comdownloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page ifwhen it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https:downloads.powerdns.comreleases"
    regex(href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "d40da33081c772fa61a58ac41c75df3af9a8a6f29b45422318c84e40831238a3"
    sha256 arm64_sonoma:  "1708bb3be04eb6e41acc7ce54dcedb1e577124c527c3ce6bab6e11de29736d36"
    sha256 arm64_ventura: "34da42329200899c74950c758bccebd37101de1f93dab1d07793acdda47c308a"
    sha256 sonoma:        "abeba632933e685140893a6c7d31fca2304879c7f088f326b142673ec1d757e6"
    sha256 ventura:       "94e15ed4382d6d3432e04c9de5a653fc15b625cb6a8806fc5628f86c7fd09184"
    sha256 x86_64_linux:  "709c32085d98d77e4851dd8d631161e71cd5d64fca2a6be95b20055c0ce335ca"
  end

  head do
    url "https:github.compowerdnspdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

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
    output = shell_output("#{sbin}pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end