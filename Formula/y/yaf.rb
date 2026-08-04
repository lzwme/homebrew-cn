class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.19.5.tar.gz"
  sha256 "8fcfc4d8b8f52460784c3a44c99a3221341b3c2d780541bad2b4bee87ea0d834"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f85b073bbbaca77e6912f035c909d52deefa4668bef6f3d255500f4f99734303"
    sha256 cellar: :any, arm64_sequoia: "bb1231519f58ed74574ae47b9e713cd14690ef7a0a94d30b313062c572efaa47"
    sha256 cellar: :any, arm64_sonoma:  "8bb775ee8a4ad17aa2641cef4b338ebe388b1c8e9dd5f5858876fc5a85846caa"
    sha256 cellar: :any, sonoma:        "3349c1813582e6e9f04aad79c3e1debfba709d06dc9e75f53f661d4af3f63cfd"
    sha256 cellar: :any, arm64_linux:   "d2a89fdb1e19085013e213bbf857fb275ffa611f69f907827dfb1b01268bd5ce"
    sha256 cellar: :any, x86_64_linux:  "54c186c95e25a8958a58d81dd1fae56fe68fb37396a1f20da065e90b4f41cf0b"
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