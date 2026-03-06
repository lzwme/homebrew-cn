class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.5.tar.xz"
  sha256 "74497ae620167d857ce2d5702bd14018e5f4c848e878f29cef51581a74b0d05e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a5b7e1e9596b536525b4ff6cfe81c3ab71243f90900f04db3ca299f1eb372b9a"
    sha256 arm64_sequoia: "36c335c431f2055f394e89ea0a3fcd7d1e05838cd5116c6b0974703df98399ac"
    sha256 arm64_sonoma:  "5495ddef9e11fc3b3645508ef808de18e0f9182e74986aa096132cc0ecebec4d"
    sha256 sonoma:        "aa6cd8589947c8a2374fa630b0b6000b11c55363275b58f3266d26dea07b8334"
    sha256 arm64_linux:   "c80886e06d1ec955dc6860a28810014c1b664cfd84244b7eefa553c2b19b15b2"
    sha256 x86_64_linux:  "8a06fa4b8e475ba8fab0454e99d0880971f0372ef91612966bd09614f4efe7e1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end