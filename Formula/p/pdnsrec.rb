class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.5.tar.xz"
  sha256 "13105768d9490067596f263d7d348bcc0c6798574c7d991cc40952f18b9dac11"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "72ced3f0d883329059015750ef5a209c03b9d316a66ff4a5824f856fcdcf722b"
    sha256 arm64_sequoia: "f612e183409cccca9dd9d3baa9ece36081368fba349bb5dda26be958ab89196e"
    sha256 arm64_sonoma:  "e6f4b3e0460f91bb8d777b955697f103c50852c2a44f233c2c176cf1fea1c7f8"
    sha256 sonoma:        "ff8870101a3d39a1c30d3947229c61a89944766aedda5111959f1d742dcc0dbe"
    sha256 arm64_linux:   "7bd009b6f43c4e01b00882823c0129efdc2ee1f46a5252586b81f7677b5d50a5"
    sha256 x86_64_linux:  "7c8dd3ff20c2fa6be235d6881a8a01f5de2acc320d37e0e6bd6e55ca69bf497c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
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