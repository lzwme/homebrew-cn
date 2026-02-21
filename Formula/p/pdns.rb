class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.3.tar.bz2"
  sha256 "ec3120501950a772c785c600f599e8f4d711f703a02cbd1bec42edc1a05f81cc"
  license "GPL-2.0-or-later"

  # The first-party download page (https://www.powerdns.com/downloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page if/when it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3be30c1f436a7f3cc1eb547495c1f7c04c43b41bc981ea806601e105ca0f8523"
    sha256 arm64_sequoia: "8922251e43dfe1038b852c98291bc71a5195ccbc5bec589b9a4c8b9011cc5b88"
    sha256 arm64_sonoma:  "09817280f1cfe20378f0cd067bc1fa0dfcb98d9c4d3194fca98406734ccb0377"
    sha256 sonoma:        "c44f3629e9d29f836f0b20c7d039531b6ee71f66bde9d72711e95659e59625b4"
    sha256 arm64_linux:   "fbda5f2a76d01d98edae420b138980690da3a6f07af5d15d954a65e08e0ed0bc"
    sha256 x86_64_linux:  "9c5f71f1f96ae85bb3f4be22ef079a6a05eae0d5aff4b2168c12adc5d41d581c"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

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
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end