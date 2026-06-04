class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.0.tar.bz2"
  sha256 "29c4040b09fb6770dac864b73d986222d9fddac1b1d09dfc1ce4c030ebffbe15"
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
    sha256 arm64_tahoe:   "4bb87b9c4adc9ee4261e288474a995c75791ee3874231347d87b353ff53ebbf0"
    sha256 arm64_sequoia: "778fa732c224896930610f62043737c7c6f6af61f05fe012cee760ea75fc6fb9"
    sha256 arm64_sonoma:  "951f7e5fe069c974cdcdadce1b501093c64d86c0bac6efa7020abb6a973867aa"
    sha256 sonoma:        "060ed60a07ae92abb28ced4e8be0865033d00c07b01fcd1ba41e98381c8c3015"
    sha256 arm64_linux:   "9faccfe3f33418c4dc33870d7c38d6948f5d3abb6320b75635e2abedbdb034ce"
    sha256 x86_64_linux:  "3a0f0ecb8ab358150ea6f165dcbb13fdd7e28a1f545340e0f55ca7ffcc377e62"
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