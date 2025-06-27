class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.16.3.tar.gz"
  sha256 "a394bc8bc2c2402a5bbdfd8c0c23948ddb1757a6856e076a38d0fdec8b93e61a"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b9520107551e1d3afeda2940035fbb147e38da2f0ed4d6bb30e2f46761200f7"
    sha256 cellar: :any,                 arm64_sonoma:  "f74e01d83a1d8de00b50b6eedb49543708d18b6c7200fd680782a803ccadeed2"
    sha256 cellar: :any,                 arm64_ventura: "f2543a2e91462e708a6bd86cf619028adfbe171529bded72dd44fc4c3ab8aa1d"
    sha256 cellar: :any,                 sonoma:        "c58866c3ee6cab46384b635624fec9d90400f8c415c2113ed0f6836e78d4cd50"
    sha256 cellar: :any,                 ventura:       "14d13fe37c3e0cda4c86219b64169be9d578fce3a5ed47f86510ebf4827d0dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333c7f4ed9bf678887ce7746d4216bf2838ef5557582c2a0ee3e4ce6c92b06e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05344e9c514be3f89d859f53b3e1e392b618a4a06de4caa09e5b40abe7a01b71"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = pipe_output(bin/"yafscii", shell_output("#{bin}/yaf --in #{input}"))
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end