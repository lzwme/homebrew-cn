class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.20.1.tar.gz"
  sha256 "fbcb2550a78c5427858abad53472fdde19c14f8b020aa0136e85db1cee62230a"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5987ba47032c23f7caf2a8222fe4572645a26a4e883928b6dbd123103fbdef38"
    sha256 cellar: :any, arm64_sequoia: "d7400f703b8b49d1a15e564e5e11e3df52774f6ffd9042b876f161590e36f97d"
    sha256 cellar: :any, arm64_sonoma:  "6e5bb1918fd52c8ee634d2f131202e54fef45ea841bc818aa8e0caa6a56442b2"
    sha256 cellar: :any, sonoma:        "73f3cda3958c07c73ea700de6105d31a8e3586ec1842c3ce2957e40f5e3ab22e"
    sha256 cellar: :any, arm64_linux:   "2cb3c1dd2d388b1f64b9a69a56bcd2dc53dc8fa9ab9c49537a39426dc7c11f36"
    sha256 cellar: :any, x86_64_linux:  "358962d3a1aa1952ee6d3aa4c4635704b3a67925a866f6c098b5ee5faa82e9f3"
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