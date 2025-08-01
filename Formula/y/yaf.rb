class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.17.0.tar.gz"
  sha256 "99a9e8651bcee516a20ddca093d248c5cda3890c5561b2dfd893c4414a0ed52b"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "918a773cde1d25ae6be6a1ac5bbfc6ac588c84d75799f22e71f8b4dbb4fbd6d8"
    sha256 cellar: :any,                 arm64_sonoma:  "85e728a2315298304f6c8e36f23881089da7d6f31acf56a27ad97005435fa049"
    sha256 cellar: :any,                 arm64_ventura: "bc99bc1cac7decbc775dbe88f68bbfb9797b1e87586993d5c696a2fffed0441f"
    sha256 cellar: :any,                 sonoma:        "418e7e78980fa7986d455c2623537c82bf1283ff7eeb0da0ed7d3f55558cddf3"
    sha256 cellar: :any,                 ventura:       "98538ffc2a1a83eaec7e8439cc4cd35e389414152d427e7a6984e4c486c486f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ca3aecaf2f8f208fda205a863d4a0f148164fb239353277d443309e8fb4cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ab3bbc046bcbd9a273ed47010b2cc2d42aff9817134b77d42e0754ebb3a5c8"
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
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"))
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end