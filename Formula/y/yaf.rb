class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.20.2.tar.gz"
  sha256 "d5365a76ce766891e98cb9e556a38c0077629727496d734725b24fcaed8a3534"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "898eac0792eb9a8de378f077b818e63490d3024420b8d01d2f5e9c35b33e09c4"
    sha256 cellar: :any, arm64_sequoia: "33a66b87296abdb8a19a53eeabc5d5b9cd553f2dc050db0359bce68cced78e7e"
    sha256 cellar: :any, arm64_sonoma:  "20b2e38fe85241ee3f69d87ab4b50905b4f319d8eb5d02367c6ecf41533b50db"
    sha256 cellar: :any, sonoma:        "44b43d5d4dc429a3f61dfb74c246b595baf82082616671430b48e91d4ff2594f"
    sha256 cellar: :any, arm64_linux:   "adb75add0daf0ac63b0031e1857360dcde4524d48258b52aac95311d2788f153"
    sha256 cellar: :any, x86_64_linux:  "ad88961b3034a6af07349a930def668691de428c9999c0d6d962232de3ef85b0"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # OpenSSL is disabled as Apache-2.0 is not compatible with GPL-2.0-only
    # Ref: https://www.gnu.org/licenses/license-list.html#apache2
    system "./configure", "--without-openssl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # FIXME: yafscii 2.19.1 segfaults when reading stdin or writing stdout
    system bin/"yaf", "--in", test_fixtures("test.pcap"), "--out", testpath/"flow.ipfix"
    system bin/"yafscii", "--in", testpath/"flow.ipfix", "--out", testpath/"flow.txt"
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, (testpath/"flow.txt").read.strip
  end
end