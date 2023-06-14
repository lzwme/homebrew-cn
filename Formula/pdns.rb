class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.0.tar.bz2"
  sha256 "61a96bbaf8b0ca49a9225a2254b9443c4ff8e050d337437d85af4de889e10127"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "716f375350d236a02a1843c53e06193def68e31a6994b633cf58b0987f0fe09d"
    sha256 arm64_monterey: "0a8b29cec37da490052b6319cb630e97c54f9c5bfa385806f81b8fddfea70c25"
    sha256 arm64_big_sur:  "87b567e4cf43bf6be38c0e6d643f494ebc1df866c9ccea9b92d9eb609cf8df1f"
    sha256 ventura:        "97035664a1c7e11395fad582510fee37b40484aac02bff2ce53acc8597a72b17"
    sha256 monterey:       "8048b76a268cdeb23b3c28d9d673f6e1d25b18406c07294fbd69f97d643c8ee4"
    sha256 big_sur:        "ae6f680618b718cda06082961d7d9eb33e073f8bf27b5598b9030fd4b580da9c"
    sha256 x86_64_linux:   "c3f768c882896f54df7adf1a9b7f396a12b9137a5ef51725074a796e75622b80"
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
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
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