class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.23.0.tar.gz"
  sha256 "cf83eb0960ba25e0855c4c45f86fe371ecc5f3f755790203f434a84f871065cf"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "324aacc439257c4679841ffedf2c0e8282a5b7bf45020c734bc15fad9869b904"
    sha256 arm64_sonoma:   "f12e6a010a351424c14ea5b4f7d22c23bdb12e6b0da9d07259219c7f27fba4f4"
    sha256 arm64_ventura:  "912070ff680bb0dd6996a42c132d5e7148875c0983345eeaa8698d969669e3c9"
    sha256 arm64_monterey: "3fe1b2927abfedce7920056f3f555b2c6878db91bb1edabc8226e2fa1de6d4d1"
    sha256 sonoma:         "1b5e0a040b20cc35637472dcd3a9fb513f87d4842ae1985224312dc627474cad"
    sha256 ventura:        "48d18f78bf1ea1b776348af588b80886795ba1a9bab7748209d5d67c2ce8e5c5"
    sha256 monterey:       "da008f1f90a12c2d99c95384e62424274b5d4f8f9a063dd3abfb9eb3bf92b9b2"
    sha256 x86_64_linux:   "4097d62607a2c7620854b51a4dedfec4cf8b586e4281adc27742369cc60b0814"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    args = %W[
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]
    # Work around macOS Sonoma having /usr/bin/podselect but Pod::Select was
    # removed from Perl 5.34 resulting in `Can't locate Pod/Select.pm in @INC`
    args << "ac_cv_prog_PODSELECT=" if OS.mac? && MacOS.version == :sonoma

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    yaf_output = shell_output("yaf --in #{input}")
    rwipfix2silk_output = pipe_output("#{bin}/rwipfix2silk", yaf_output)
    output = pipe_output("#{bin}/rwcount --no-titles --no-column", rwipfix2silk_output)
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end