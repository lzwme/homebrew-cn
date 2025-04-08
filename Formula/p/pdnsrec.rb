class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.1.tar.bz2"
  sha256 "a320d021f1be244f684549ab823803ed06b7e225b18b7b27234cb69cd5db7144"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "fd60dfa95d0fb88f8f28a8862ac7a4f37f070b1b6d2edda1c6c4bb670d4725be"
    sha256 arm64_sonoma:  "8f03ecbeb6031c3d8899a647ef531aadafb5dba3a19550161dc5a6f83affc7cc"
    sha256 arm64_ventura: "be69112b2b7f3aeefe6592ea1382ec12d04407ca566dc15ab1cbcde2b7bb752a"
    sha256 sonoma:        "9799c6704fca87adf800ab9448d9b5a33b096a2a420e933ac33fa653c50a44ec"
    sha256 ventura:       "235cc42960deb5d11435a706d8ea88887272a8dce2bd5939a7c8ab85ba5eedf7"
    sha256 arm64_linux:   "c52f22d69c1cdb902bcec676c7d162f893b1d65bf1672bc9bf8d5b89b44613c0"
    sha256 x86_64_linux:  "90d59c8c343becf4aaacf0bc675103224355b8b901bc4aed5ee6618910106042"
  end

  depends_on "pkgconf" => :build
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
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

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