class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.0.4.tar.bz2"
  sha256 "d52aab108a0ad9e8be1de2179a693bb85e995c6a4d958a50702dcf79eec8ef28"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d9d8eb1850dda6fdfd8515a24608c821297b20ef4d5a8d4344c218b247aa713d"
    sha256 arm64_ventura:  "6cec3c4e44c25e13a1e610090c3e9ce7d26d89d4e8449438a306fa4fead90cb2"
    sha256 arm64_monterey: "5e2b60042d0e8059f32d000feb9fa14f28256aa7d904cc023932af3050b4582d"
    sha256 sonoma:         "6cda2fe4e07d6a7e8a0eae9ab54a048e780fa2b89a159e25254a3b6973ca187b"
    sha256 ventura:        "869e759bbd6189b80445f11baa9d230fb4110c4b5bc64d0f8f772157a9cb1be3"
    sha256 monterey:       "be3bfae23ac533578e0bc0a960d123baec6d034bcdddba14c3ec32c7fc4eef0d"
    sha256 x86_64_linux:   "c5586934174928496f34a91ef9ebea88bde7a122552e27690318e942584da73a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end